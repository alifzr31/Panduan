import 'package:panduan/app/models/district.dart';
import 'package:panduan/app/models/subdistrict.dart';
import 'package:panduan/app/services/region_service.dart';

abstract class RegionRepository {
  Future<List<District>> fetchDistricts({String? keyword});
  Future<List<SubDistrict>> fetchSubDistricts({
    String? districtCode,
    String? keyword,
  });
}

class RegionRepositoryImpl implements RegionRepository {
  final RegionService _service;

  RegionRepositoryImpl(this._service);

  @override
  Future<List<District>> fetchDistricts({String? keyword}) async {
    return await _service.fetchDistricts(keyword: keyword);
  }

  @override
  Future<List<SubDistrict>> fetchSubDistricts({
    String? districtCode,
    String? keyword,
  }) async {
    return await _service.fetchSubDistricts(
      districtCode: districtCode,
      keyword: keyword,
    );
  }
}
