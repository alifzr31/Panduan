import 'package:dio/dio.dart';
import 'package:panduan/app/models/spm.dart';
import 'package:panduan/app/services/detailspm_service.dart';

abstract class DetailSpmRepository {
  Future<Spm?> fetchDetailSpm({String? uuid});
  Future<Response> deleteSpm({String? uuid});
}

class DetailSpmRepositoryImpl implements DetailSpmRepository {
  final DetailSpmService _service;

  DetailSpmRepositoryImpl(this._service);

  @override
  Future<Spm?> fetchDetailSpm({String? uuid}) async {
    return await _service.fetchDetailSpm(uuid: uuid);
  }

  @override
  Future<Response> deleteSpm({String? uuid}) async {
    return await _service.deleteSpm(uuid: uuid);
  }
}
