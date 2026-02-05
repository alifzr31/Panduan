import 'package:panduan/app/models/spm_field.dart';
import 'package:panduan/app/services/spm_service.dart';

abstract class SpmRepository {
  Future<List<SpmField>> fetchSpmFields();
}

class SpmRepositoryImpl implements SpmRepository {
  final SpmService _service;

  SpmRepositoryImpl(this._service);

  @override
  Future<List<SpmField>> fetchSpmFields() async {
    return await _service.fetchSpmFields();
  }
}
