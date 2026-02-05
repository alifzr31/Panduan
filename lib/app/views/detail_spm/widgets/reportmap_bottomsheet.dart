import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/widgets/base_button.dart';
import 'package:panduan/app/widgets/base_gmaps.dart';

class ReportMapBottomsheet extends StatefulWidget {
  const ReportMapBottomsheet({
    required this.latitude,
    required this.longitude,
    super.key,
  });

  final double latitude;
  final double longitude;

  @override
  State<ReportMapBottomsheet> createState() => _ReportMapBottomsheetState();
}

class _ReportMapBottomsheetState extends State<ReportMapBottomsheet> {
  Completer<GoogleMapController> _googleMapController =
      Completer<GoogleMapController>();
  late final GoogleMapController _mapController;

  @override
  void dispose() {
    _googleMapController = Completer();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Titik Koordinat Lokasi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      'Latitude: ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.latitude.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Longitude: ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.longitude.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 240,
            width: double.infinity,
            child: Material(
              elevation: 1,
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(10),
              child: BaseGmaps(
                lat: widget.latitude,
                long: widget.longitude,
                scrollGesturesEnabled: false,
                zoom: 18,
                markers: {
                  Marker(
                    markerId: const MarkerId('id'),
                    icon: BitmapDescriptor.defaultMarker,
                    position: LatLng(widget.latitude, widget.longitude),
                  ),
                },
                onMapCreated: (mapController) {
                  if (!_googleMapController.isCompleted) {
                    _googleMapController.complete(mapController);
                    _mapController = mapController;
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              child: BaseButtonIcon(
                icon: MingCute.arrow_left_line,
                label: 'Tutup',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
