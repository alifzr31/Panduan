import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:panduan/app/cubits/location/location_cubit.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/views/map_coordinate/widgets/maplocation_handle.dart';
import 'package:panduan/app/widgets/base_button.dart';
import 'package:panduan/app/widgets/base_gmaps.dart';
import 'package:panduan/app/widgets/show_customtoast.dart';
import 'package:toastification/toastification.dart';
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

class _MapCoordinatePageState extends State<MapCoordinatePage>
    with WidgetsBindingObserver {
  Completer<GoogleMapController> _googleMapController =
      Completer<GoogleMapController>();
  GoogleMapController? _mapController;

  void _onCameraMove(CameraPosition position) {
    context.read<LocationCubit>().onChangedMyLocation(
      position.target.latitude,
      position.target.longitude,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.latitude != null && widget.longitude != null) {
      context.read<LocationCubit>().onChangedMyLocation(
        widget.latitude ?? 0,
        widget.longitude ?? 0,
      );
    }

    if (!widget.viewOnly) {
      context.read<LocationCubit>().checkLocationService();
    }
  }

  @override
  void dispose() {
    _googleMapController = Completer();
    _mapController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (!widget.viewOnly) {
        context.read<LocationCubit>().checkLocationService();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Titik Koordinat Lokasi',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, state) {
          return !state.serviceEnabled && !widget.viewOnly
              ? MapLocationHandle(
                  icon: Iconsax.location_slash_bold,
                  title: 'Lokasi Tidak Aktif',
                  description:
                      'Silahkan nyalakan layanan lokasi pada perangkat anda agar aplikasi dapat mengakses lokasi anda secara akurat.',
                  buttonLabel: 'Aktifkan Lokasi',
                  onPressedButton: () async {
                    try {
                      await Geolocator.openLocationSettings();
                    } catch (e) {
                      rethrow;
                    }
                  },
                )
              : !state.permissionGranted && !widget.viewOnly
              ? MapLocationHandle(
                  icon: Iconsax.location_cross_bold,
                  title: 'Lokasi Tidak Diizinkan',
                  description:
                      'Silahkan izinkan aplikasi untuk mengakses lokasi pada perangkat anda agar aplikasi dapat mengakses lokasi anda secara akurat.',
                  buttonLabel: 'Izinkan Lokasi',
                  onPressedButton: () async {
                    try {
                      final status = await Geolocator.checkPermission();

                      if (status == LocationPermission.denied) {
                        final requestPermission =
                            await Geolocator.requestPermission();

                        if (requestPermission == LocationPermission.denied ||
                            requestPermission ==
                                LocationPermission.deniedForever) {
                          await Geolocator.openAppSettings();
                        }
                      }

                      if (status == LocationPermission.deniedForever) {
                        await Geolocator.openAppSettings();
                      }
                    } catch (e) {
                      rethrow;
                    }
                  },
                )
              : Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          BaseGmaps(
                            lat: state.myLocation.latitude,
                            long: state.myLocation.longitude,
                            markers: widget.viewOnly ? state.marker : null,
                            zoom: 18,
                            onCameraMove: widget.viewOnly
                                ? null
                                : _onCameraMove,
                            onMapCreated: (mapController) {
                              if (!_googleMapController.isCompleted) {
                                _googleMapController.complete(mapController);
                                _mapController = mapController;

                                if (widget.viewOnly) {
                                  context.read<LocationCubit>().createMarker(
                                    widget.latitude ?? 0,
                                    widget.longitude ?? 0,
                                  );
                                }
                              }
                            },
                          ),
                          if (!widget.viewOnly &&
                              state.serviceEnabled &&
                              state.permissionGranted) ...{
                            BlocListener<LocationCubit, LocationState>(
                              listenWhen: (previous, current) =>
                                  previous.myLocationStatus !=
                                  current.myLocationStatus,
                              listener: (context, state) {
                                if (state.myLocationStatus ==
                                    MyLocationStatus.loading) {
                                  context.loaderOverlay.show();
                                }

                                if (state.myLocationStatus ==
                                    MyLocationStatus.success) {
                                  context.loaderOverlay.hide();

                                  _mapController?.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                        zoom: 18,
                                        target: state.myLocation,
                                      ),
                                    ),
                                  );
                                }

                                if (state.myLocationStatus ==
                                    MyLocationStatus.error) {
                                  context.loaderOverlay.hide();
                                  showCustomToast(
                                    context,
                                    type: ToastificationType.error,
                                    title: 'Gagal Mendapatkan Lokasi',
                                    description: state.myLocationError,
                                  );
                                }
                              },
                              child: Positioned(
                                bottom: 30,
                                left: 6,
                                child: BaseButtonIcon(
                                  bgColor: AppColors.pinkColor,
                                  icon: MingCute.location_2_fill,
                                  label: 'Dapatkan Lokasi Saya',
                                  onPressed: () {
                                    context
                                        .read<LocationCubit>()
                                        .fetchMyLocation();
                                  },
                                ),
                              ),
                            ),
                          },
                          if (!widget.viewOnly) ...{
                            const Center(
                              child: Icon(
                                Icons.location_on,
                                size: 50,
                                color: Colors.red,
                              ),
                            ),
                          },
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
                              icon: widget.viewOnly
                                  ? MingCute.navigation_line
                                  : MingCute.map_pin_line,
                              label: widget.viewOnly
                                  ? 'Mulai Navigasi'
                                  : 'Pilih Titik',
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
                                  Navigator.pop(context, state.myLocation);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
