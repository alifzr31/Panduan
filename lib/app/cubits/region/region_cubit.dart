import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:panduan/app/models/district.dart';
import 'package:panduan/app/models/subdistrict.dart';
import 'package:panduan/app/repositories/region_repository.dart';
import 'package:panduan/app/utils/app_helpers.dart';

part 'region_state.dart';

class RegionCubit extends Cubit<RegionState> {
  RegionCubit(this._repository) : super(const RegionState());

  final RegionRepository _repository;

  Future<void> fetchDistricts({String? keyword}) async {
    emit(state.copyWith(districtStatus: DistrictStatus.loading));

    try {
      final districts = await _repository.fetchDistricts(keyword: keyword);

      emit(
        state.copyWith(
          districtStatus: DistrictStatus.success,
          districts: districts,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          districtStatus: DistrictStatus.error,
          districtError: AppHelpers.errorHandlingApiMessage(e),
        ),
      );
    }
  }

  FutureOr<List<District>?> searchDistrict(
    List<District> districts,
    String keyword,
  ) async {
    return districts.where((element) {
      return element.name?.toLowerCase().contains(keyword.toLowerCase()) ??
          false;
    }).toList();
  }

  Future<void> fetchSubDistricts({
    String? districtCode,
    String? keyword,
  }) async {
    emit(state.copyWith(subDistrictStatus: SubDistrictStatus.loading));

    try {
      final subDistricts = await _repository.fetchSubDistricts(
        districtCode: districtCode,
        keyword: keyword,
      );

      emit(
        state.copyWith(
          subDistrictStatus: SubDistrictStatus.success,
          subDistricts: subDistricts,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          subDistrictStatus: SubDistrictStatus.error,
          subDistrictError: AppHelpers.errorHandlingApiMessage(e),
        ),
      );
    }
  }

  FutureOr<List<SubDistrict>?> searchSubDistrict(
    List<SubDistrict> subDistricts,
    String keyword,
  ) async {
    return subDistricts.where((element) {
      return element.name?.toLowerCase().contains(keyword.toLowerCase()) ??
          false;
    }).toList();
  }
}
