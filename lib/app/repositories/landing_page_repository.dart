import 'package:dio/dio.dart';
import 'package:panduan/app/services/landing_page_service.dart';

abstract class LandingPageRepository {
  Future<String?> fetchUserManualUrl({CancelToken? cancelToken});
}

class LandingPageRepositoryImpl implements LandingPageRepository {
  final LandingPageService _service;

  LandingPageRepositoryImpl(this._service);

  @override
  Future<String?> fetchUserManualUrl({CancelToken? cancelToken}) async {
    return await _service.fetchUserManualUrl(cancelToken: cancelToken);
  }
}
