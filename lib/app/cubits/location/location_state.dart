part of 'location_cubit.dart';

enum DistrictStatus { initial, loading, success, error }

enum SubDistrictStatus { initial, loading, success, error }

class LocationState extends Equatable {
  final DistrictStatus districtStatus;
  final List<District> districts;
  final String? districtError;
  final SubDistrictStatus subDistrictStatus;
  final List<SubDistrict> subDistricts;
  final String? subDistrictError;

  const LocationState({
    this.districtStatus = DistrictStatus.initial,
    this.districts = const [],
    this.districtError,
    this.subDistrictStatus = SubDistrictStatus.initial,
    this.subDistricts = const [],
    this.subDistrictError,
  });

  LocationState copyWith({
    DistrictStatus? districtStatus,
    List<District>? districts,
    String? districtError,
    SubDistrictStatus? subDistrictStatus,
    List<SubDistrict>? subDistricts,
    String? subDistrictError,
  }) {
    return LocationState(
      districtStatus: districtStatus ?? this.districtStatus,
      districts: districts ?? this.districts,
      districtError: districtError,
      subDistrictStatus: subDistrictStatus ?? this.subDistrictStatus,
      subDistricts: subDistricts ?? this.subDistricts,
      subDistrictError: subDistrictError,
    );
  }

  @override
  List<Object?> get props => [
    districtStatus,
    districts,
    districtError,
    subDistrictStatus,
    subDistricts,
    subDistrictError,
  ];
}
