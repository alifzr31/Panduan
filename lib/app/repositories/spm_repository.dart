import 'package:panduan/app/models/spm.dart';
import 'package:panduan/app/models/spm_field.dart';
import 'package:panduan/app/services/spm_service.dart';

abstract class SpmRepository {
  Future<List<Spm>> fetchSpm({
    int? page,
    String? keyword,
    int? month,
    int? year,
    Set<String>? statuses,
  });
  Future<List<SpmField>> fetchSpmFields();
}

class SpmRepositoryImpl implements SpmRepository {
  final SpmService _service;

  SpmRepositoryImpl(this._service);

  @override
  Future<List<Spm>> fetchSpm({
    int? page,
    String? keyword,
    int? month,
    int? year,
    Set<String>? statuses,
  }) async {
    return await _service.fetchSpm(
      page: page,
      keyword: keyword,
      month: month,
      year: year,
      statuses: statuses,
    );
  }

  @override
  Future<List<SpmField>> fetchSpmFields() async {
    return await _service.fetchSpmFields();
  }
}
