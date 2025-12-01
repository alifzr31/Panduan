import 'package:panduan/app/models/hp_registration.dart';
import 'package:panduan/app/services/hpregistration_service.dart';

abstract class HpRegistrationRepository {
  Future<HpRegistration?> fetchHpRegistration({int? healthPostId});
}

class HpRegistrationRepositoryImpl implements HpRegistrationRepository {
  final HpRegistrationService _service;

  HpRegistrationRepositoryImpl(this._service);

  @override
  Future<HpRegistration?> fetchHpRegistration({int? healthPostId}) async {
    return await _service.fetchHpRegistration(healthPostId: healthPostId);
  }
}
