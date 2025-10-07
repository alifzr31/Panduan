import 'package:panduan/app/models/spm.dart';
import 'package:panduan/app/models/spm_count.dart';
import 'package:panduan/app/models/spm_district_count.dart';
import 'package:panduan/app/models/spm_field_count.dart';
import 'package:panduan/app/models/spm_hp_count.dart';
import 'package:panduan/app/models/spm_subdistrict_count.dart';
import 'package:panduan/app/services/dashboard_service.dart';

abstract class DashboardRepository {
  Future<int> fetchUnreadNotificationCount();
  Future<SpmCount?> fetchSpmCount({DateTime? startDate, DateTime? endDate});
  Future<SpmFieldCount?> fetchSpmFieldCount({
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<List<SpmDistrictCount>> fetchSpmDistrictCount({
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<List<SpmSubDistrictCount>> fetchSpmSubDistrictCount({
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<List<SpmHpCount>> fetchSpmHpCount({
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<List<Spm>> fetchSpm();
}

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardService _service;

  DashboardRepositoryImpl(this._service);

  @override
  Future<int> fetchUnreadNotificationCount() async {
    return await _service.fetchUnreadNotificationCount();
  }

  @override
  Future<SpmCount?> fetchSpmCount({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _service.fetchSpmCount(startDate: startDate, endDate: endDate);
  }

  @override
  Future<SpmFieldCount?> fetchSpmFieldCount({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _service.fetchSpmFieldCount(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<List<SpmDistrictCount>> fetchSpmDistrictCount({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _service.fetchSpmDistrictCount(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<List<SpmSubDistrictCount>> fetchSpmSubDistrictCount({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _service.fetchSpmSubDistrictCount(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<List<SpmHpCount>> fetchSpmHpCount({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _service.fetchSpmHpCount(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<List<Spm>> fetchSpm() async {
    return await _service.fetchSpm();
  }
}
