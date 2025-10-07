import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BaseGmaps extends StatelessWidget {
  const BaseGmaps({
    super.key,
    required this.lat,
    required this.long,
    this.onMapCreated,
    this.onCameraMove,
    this.zoom = 16,
    this.markers,
    this.polylines,
    this.scrollGesturesEnabled = true,
    this.onTap,
  });

  final double lat;
  final double long;
  final void Function(GoogleMapController)? onMapCreated;
  final void Function(CameraPosition)? onCameraMove;
  final double zoom;
  final Set<Marker>? markers;
  final Set<Polyline>? polylines;
  final bool scrollGesturesEnabled;
  final void Function(LatLng)? onTap;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(lat, long),
        zoom: zoom,
      ),
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
      },
      polylines: polylines ?? const {},
      onMapCreated: onMapCreated,
      onCameraMove: onCameraMove,
      markers: markers ?? const {},
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      buildingsEnabled: true,
      indoorViewEnabled: true,
      mapToolbarEnabled: false,
      scrollGesturesEnabled: scrollGesturesEnabled,
      tiltGesturesEnabled: false,
      trafficEnabled: false,
      zoomGesturesEnabled: true,
      onTap: onTap,
      zoomControlsEnabled: false,
    );
  }
}
