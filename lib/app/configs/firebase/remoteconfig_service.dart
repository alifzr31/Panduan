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
    'ssl_pinning_actived': true,
    'latest_version': '1.0.8',
    'latest_build_number': 9,
    'latest_version_ios': '1.0.8',
    'latest_build_number_ios': 9,
    'mandatory_update': true,
    'update_description': 'Perbaikan bugs dan ptimalisasi performa aplikasi.',
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

  bool get sslPinningActived => _remote.getBool('ssl_pinning_actived');
  String get latestVersion => _remote.getString('latest_version');
  int get latestBuildNumber => _remote.getInt('latest_build_number');
  String get latestVersionIOS => _remote.getString('latest_version_ios');
  int get latestBuildNumberIOS => _remote.getInt('latest_build_number_ios');
  bool get mandatoryUpdate => _remote.getBool('mandatory_update');
  String get updateDescription => _remote.getString('update_description');
}
