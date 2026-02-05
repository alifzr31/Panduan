part of 'region_cubit.dart';

enum DistrictStatus { initial, loading, success, error }

enum SubDistrictStatus { initial, loading, success, error }

class RegionState extends Equatable {
  final DistrictStatus districtStatus;
  final List<District> districts;
  final String? districtError;
  final SubDistrictStatus subDistrictStatus;
  final List<SubDistrict> subDistricts;
  final String? subDistrictError;

  const RegionState({
    this.districtStatus = DistrictStatus.initial,
    this.districts = const [],
    this.districtError,
    this.subDistrictStatus = SubDistrictStatus.initial,
    this.subDistricts = const [],
    this.subDistrictError,
  });

  RegionState copyWith({
    DistrictStatus? districtStatus,
    List<District>? districts,
    String? districtError,
    SubDistrictStatus? subDistrictStatus,
    List<SubDistrict>? subDistricts,
    String? subDistrictError,
  }) {
    return RegionState(
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
