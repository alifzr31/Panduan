import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  RemoteConfigService._(this._remote);
  static final RemoteConfigService instance = RemoteConfigService._(
    FirebaseRemoteConfig.instance,
  );

  final FirebaseRemoteConfig _remote;

  static const _kDefault = {
    'latest_version': '1.0.2',
    'latest_build_number': 3,
    'mandatory_update': true,
    'update_description':
        'Pembuatan fitur ubah kata sandi, perbaikan bugs dan optimalisasi performa aplikasi.',
  };

  Future<void> init() async {
    await _remote.setDefaults(_kDefault);

    await _remote.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: kDebugMode
            ? const Duration(seconds: 10)
            : const Duration(hours: 1),
      ),
    );

    try {
      await _remote.fetchAndActivate();
    } on FirebaseException catch (e, s) {
      if (kDebugMode) {
        print('RemoteConfig fetch error: $e, stackTrace: $s');
      }
    }
  }

  String get latestVersion => _remote.getString('latest_version');
  int get latestBuildNumber => _remote.getInt('latest_build_number');
  bool get mandatoryUpdate => _remote.getBool('mandatory_update');
  String get updateDescription => _remote.getString('update_description');
}
