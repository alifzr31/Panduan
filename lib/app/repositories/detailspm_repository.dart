import 'package:dio/dio.dart';
import 'package:panduan/app/models/spm.dart';
import 'package:panduan/app/services/detailspm_service.dart';

abstract class DetailSpmRepository {
  Future<Spm?> fetchDetailSpm({String? uuid, bool? isEdit});
  Future<Response> deleteSpm({String? uuid});
}

class DetailSpmRepositoryImpl implements DetailSpmRepository {
  final DetailSpmService _service;

  DetailSpmRepositoryImpl(this._service);

  @override
  Future<Spm?> fetchDetailSpm({String? uuid, bool? isEdit}) async {
    return await _service.fetchDetailSpm(uuid: uuid, isEdit: isEdit);
  }

  @override
  Future<Response> deleteSpm({String? uuid}) async {
    return await _service.deleteSpm(uuid: uuid);
  }
}
