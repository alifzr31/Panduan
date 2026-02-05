part of 'location_cubit.dart';

enum MyLocationStatus { initial, loading, success, error }

class LocationState extends Equatable {
  final bool serviceEnabled;
  final bool permissionGranted;
  final MyLocationStatus myLocationStatus;
  final LatLng myLocation;
  final String? myLocationError;
  final Set<Marker>? marker;

  const LocationState({
    this.serviceEnabled = false,
    this.permissionGranted = false,
    this.myLocationStatus = MyLocationStatus.initial,
    this.myLocation = const LatLng(-6.911642008579426, 107.60975662618876),
    this.myLocationError,
    this.marker,
  });

  LocationState copyWith({
    bool? serviceEnabled,
    bool? permissionGranted,
    MyLocationStatus? myLocationStatus,
    LatLng? myLocation,
    String? myLocationError,
    Set<Marker>? marker,
  }) {
    return LocationState(
      serviceEnabled: serviceEnabled ?? this.serviceEnabled,
      permissionGranted: permissionGranted ?? this.permissionGranted,
      myLocationStatus: myLocationStatus ?? this.myLocationStatus,
      myLocation: myLocation ?? this.myLocation,
      myLocationError: myLocationError,
      marker: marker,
    );
  }

  @override
  List<Object?> get props => [
    serviceEnabled,
    permissionGranted,
    myLocationStatus,
    myLocation,
    myLocationError,
    marker,
  ];
}
