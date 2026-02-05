import 'package:panduan/app/models/health_post.dart';
import 'package:panduan/app/services/healthpost_service.dart';

abstract class HealthPostRepository {
  Future<List<HealthPost>> fetchHealthPosts({
    int? page,
    int? limit,
    String? keyword,
    String? districtCode,
    String? subDistrictCode,
  });
}

class HealthPostRepositoryImpl implements HealthPostRepository {
  final HealthPostService _service;

  HealthPostRepositoryImpl(this._service);

  @override
  Future<List<HealthPost>> fetchHealthPosts({
    int? page,
    int? limit,
    String? keyword,
    String? districtCode,
    String? subDistrictCode,
  }) async {
    return await _service.fetchHealthPosts(
      page: page,
      limit: limit,
      keyword: keyword,
      districtCode: districtCode,
      subDistrictCode: subDistrictCode,
    );
  }
}
