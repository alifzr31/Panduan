import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/widgets/base_button.dart';
import 'package:panduan/app/widgets/base_gmaps.dart';
import 'package:url_launcher/url_launcher.dart';

class MapCoordinatePage extends StatefulWidget {
  const MapCoordinatePage({
    required this.latitude,
    required this.longitude,
    this.viewOnly = false,
    super.key,
  });

  final double? latitude;
  final double? longitude;
  final bool viewOnly;

  static const String routeName = '/mapCoordinate';

  @override
  State<MapCoordinatePage> createState() => _MapCoordinatePageState();
}

class _MapCoordinatePageState extends State<MapCoordinatePage> {
  bool _serviceEnabled = false;
  bool _hasPermission = false;
  Completer<GoogleMapController> _googleMapController =
      Completer<GoogleMapController>();
  late final GoogleMapController _mapController;
  late LatLng _center;
  Set<Marker>? _marker;

  Future<void> _initLocation() async {
    try {
      LocationPermission permission;

      final service = await Geolocator.isLocationServiceEnabled();

      setState(() {
        _serviceEnabled = service;
      });

      if (_serviceEnabled) {
        permission = await Geolocator.checkPermission();

        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
          } else if (permission == LocationPermission.deniedForever) {
            permission = await Geolocator.requestPermission();
          } else {
            setState(() {
              _hasPermission = true;
            });
          }
        } else {
          setState(() {
            _hasPermission = true;
          });
        }
      } else {
        await Geolocator.openLocationSettings();
      }
    } on PlatformException catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<void> _fetchMyLocation(
    Completer<GoogleMapController> googleMapController,
    GoogleMapController mapController,
  ) async {
    try {
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 100,
      );

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      LatLng nowPosition = LatLng(position.latitude, position.longitude);

      await _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(zoom: 16, target: nowPosition),
        ),
      );

      setState(() {
        _center = nowPosition;
      });
    } on PlatformException catch (e) {
      if (kDebugMode) print(e);
    }
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _center = position.target;
    });
  }

  void _createMarker() async {
    Marker newMarker = Marker(
      markerId: MarkerId(1.toString()),
      position: LatLng(widget.latitude ?? 0, widget.longitude ?? 0),
      icon: BitmapDescriptor.defaultMarker,
    );

    setState(() {
      _marker = {newMarker};
    });
  }

  @override
  void initState() {
    setState(() {
      _center = LatLng(
        widget.latitude ?? -6.911642008579426,
        widget.longitude ?? 107.60975662618876,
      );
    });

    if (!widget.viewOnly) {
      _initLocation();
    }
    super.initState();
  }

  @override
  void dispose() {
    _googleMapController = Completer();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Titik Koordinat Lokasi',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButton: widget.viewOnly
          ? null
          : _serviceEnabled && _hasPermission
          ? Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: FloatingActionButton(
                elevation: 2,
                backgroundColor: AppColors.pinkColor,
                foregroundColor: Colors.white,
                onPressed: () async {
                  context.loaderOverlay.show();

                  await Future.delayed(
                    const Duration(milliseconds: 1500),
                    () async {
                      await _fetchMyLocation(
                        _googleMapController,
                        _mapController,
                      ).then((value) {
                        if (context.mounted) {
                          context.loaderOverlay.hide();
                        }
                      });
                    },
                  );
                },
                child: const Icon(MingCute.location_2_fill),
              ),
            )
          : null,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                BaseGmaps(
                  lat: _center.latitude,
                  long: _center.longitude,
                  markers: widget.viewOnly ? _marker : null,
                  zoom: widget.latitude == null && widget.longitude == null
                      ? 16
                      : 18,
                  onCameraMove: widget.viewOnly ? null : _onCameraMove,
                  onMapCreated: (mapController) {
                    if (!_googleMapController.isCompleted) {
                      _googleMapController.complete(mapController);
                      _mapController = mapController;

                      if (widget.viewOnly) {
                        _createMarker();
                      }
                    }
                  },
                ),
                if (!widget.viewOnly)
                  const Center(
                    child: Icon(Icons.location_on, size: 50, color: Colors.red),
                  ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2,
                  offset: Offset(0, 0),
                  spreadRadius: 0.1,
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: BaseButtonIcon(
                    icon: MingCute.map_pin_line,
                    label: widget.viewOnly ? 'Lihat Rute' : 'Pilih Titik',
                    onPressed: () async {
                      if (widget.viewOnly) {
                        final url = Uri.parse(
                          'https://www.google.com/maps/dir/?api=1&destination=${widget.latitude},${widget.longitude}&dir_action=driving',
                        );

                        try {
                          await launchUrl(url);
                        } catch (e) {
                          if (kDebugMode) print(e);
                        }
                      } else {
                        Navigator.pop(context, _center);
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
