import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:panduan/app/utils/app_strings.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(const LocationState());

  Future<void> checkLocationService() async {
    try {
      final service = await Geolocator.isLocationServiceEnabled();

      if (!service) {
        emit(state.copyWith(serviceEnabled: false));
        return;
      } else {
        emit(state.copyWith(serviceEnabled: true));
        await _checkLocationPermission();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _checkLocationPermission() async {
    try {
      final permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        emit(state.copyWith(permissionGranted: false));
        return;
      } else {
        emit(state.copyWith(permissionGranted: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  void onChangedMyLocation(double latitude, double longitude) {
    emit(state.copyWith(myLocation: LatLng(latitude, longitude)));
  }

  Future<void> fetchMyLocation() async {
    emit(state.copyWith(myLocationStatus: MyLocationStatus.loading));

    try {
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10,
      );

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      emit(
        state.copyWith(
          myLocationStatus: MyLocationStatus.success,
          myLocation: LatLng(position.latitude, position.longitude),
        ),
      );
    } on PlatformException catch (e) {
      emit(
        state.copyWith(
          myLocationStatus: MyLocationStatus.error,
          myLocationError: e.message ?? AppStrings.unknownErrorApiMessage,
        ),
      );
    }
  }

  void createMarker(double latitude, double longitude) async {
    Marker newMarker = Marker(
      markerId: MarkerId(1.toString()),
      position: LatLng(latitude, longitude),
      icon: BitmapDescriptor.defaultMarker,
    );

    emit(state.copyWith(marker: {newMarker}));
  }
}
