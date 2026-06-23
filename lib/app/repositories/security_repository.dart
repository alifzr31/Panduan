import 'package:panduan/app/services/security_service.dart';

abstract class SecurityRepository {
  Future<void> startRasp({
    required Function(String threatMessage) onThreatDetected,
  });
}

class SecurityRepositoryImpl implements SecurityRepository {
  final SecurityService _service;

  SecurityRepositoryImpl(this._service);

  @override
  Future<void> startRasp({
    required Function(String threatMessage) onThreatDetected,
  }) async {
    return await _service.startRasp(onThreatDetected: onThreatDetected);
  }
}
