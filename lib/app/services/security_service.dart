import 'package:flutter/foundation.dart' show kDebugMode, kReleaseMode;
import 'package:freerasp/freerasp.dart';
import 'package:package_info_plus/package_info_plus.dart' as pi;
import 'package:panduan/app/utils/app_env.dart';
import 'package:panduan/app/utils/app_helpers.dart';

class SecurityService {
  Future<void> startRasp({
    required Function(String threatMessage) onThreatDetected,
  }) async {
    final packageInfo = await pi.PackageInfo.fromPlatform();
    final packageName = packageInfo.packageName;

    final playSigningBase64 = AppHelpers.covertSigningToBase64(
      AppEnv.playConsoleSha256,
    );
    final keystoreSigningBase64 = AppHelpers.covertSigningToBase64(
      AppEnv.keystoreSha256,
    );

    final config = TalsecConfig(
      androidConfig: AndroidConfig(
        packageName: packageName,
        signingCertHashes: [playSigningBase64, keystoreSigningBase64],
      ),
      iosConfig: IOSConfig(bundleIds: [packageName], teamId: AppEnv.appStoreId),
      watcherMail: AppEnv.watcherMail,
      isProd: kReleaseMode,
    );

    final callback = ThreatCallback(
      onAppIntegrity: () => onThreatDetected('App Integrity Compromised'),
      onObfuscationIssues: () => onThreatDetected('Obfuscation Issues'),
      onDebug: () => onThreatDetected('Debugging Detected'),
      onDeviceBinding: () => onThreatDetected('Device Binding Failed'),
      onDeviceID: () => onThreatDetected('Device ID Spoofing'),
      onHooks: () => onThreatDetected('Hooking Framework Detected'),
      onPrivilegedAccess: () => onThreatDetected('Root/Jailbreak Detected'),
      onSimulator: () => onThreatDetected('Simulator Detected'),
      onUnofficialStore: () => onThreatDetected('Unofficial Store'),
      onSecureHardwareNotAvailable: () {
        if (kDebugMode) {
          print(
            'Warning: Secure Hardware Not Available. Bypass allowed for entry-level devices.',
          );
        }
      },
    );

    Talsec.instance.attachListener(callback);

    try {
      await Talsec.instance.start(config);

      if (kDebugMode) print('freeRASP Service is running');
    } catch (e) {
      rethrow;
    }
  }
}
