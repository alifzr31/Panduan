import 'package:dio/dio.dart';
import 'package:panduan/app/models/spm_district_count.dart';
import 'package:panduan/app/models/spm_hp_count.dart';
import 'package:panduan/app/models/spm_subdistrict_count.dart';
import 'package:panduan/app/services/recapitulation_service.dart';

abstract class RecapitulationRepository {
  Future<List<SpmDistrictCount>> fetchSpmDistrictCount({
    DateTime? startDate,
    DateTime? endDate,
    CancelToken? cancelToken,
  });
  Future<List<SpmSubDistrictCount>> fetchSpmSubDistrictCount({
    DateTime? startDate,
    DateTime? endDate,
    CancelToken? cancelToken,
  });
  Future<List<SpmHpCount>> fetchSpmHpCount({
    DateTime? startDate,
    DateTime? endDate,
    CancelToken? cancelToken,
  });
}

class RecapitulationRepositoryImpl implements RecapitulationRepository {
  final RecapitulationService _service;

  RecapitulationRepositoryImpl(this._service);

  @override
  Future<List<SpmDistrictCount>> fetchSpmDistrictCount({
    DateTime? startDate,
    DateTime? endDate,
    CancelToken? cancelToken,
  }) async {
    return await _service.fetchSpmDistrictCount(
      startDate: startDate,
      endDate: endDate,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<List<SpmSubDistrictCount>> fetchSpmSubDistrictCount({
    DateTime? startDate,
    DateTime? endDate,
    CancelToken? cancelToken,
  }) async {
    return await _service.fetchSpmSubDistrictCount(
      startDate: startDate,
      endDate: endDate,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<List<SpmHpCount>> fetchSpmHpCount({
    DateTime? startDate,
    DateTime? endDate,
    CancelToken? cancelToken,
  }) async {
    return await _service.fetchSpmHpCount(
      startDate: startDate,
      endDate: endDate,
      cancelToken: cancelToken,
    );
  }
}
