import 'package:envied/envied.dart';

part 'app_env.g.dart';

@Envied(path: '.env')
abstract class AppEnv {
  @EnviedField(varName: 'BASE_URL', obfuscate: true)
  static final String baseUrl = _AppEnv.baseUrl;

  @EnviedField(varName: 'BASE_OWNER_URL', obfuscate: true)
  static final String baseOwnerUrl = _AppEnv.baseOwnerUrl;

  @EnviedField(varName: 'BASE_PUBLIC_URL', obfuscate: true)
  static final String basePublicUrl = _AppEnv.basePublicUrl;

  @EnviedField(varName: 'PANDUAN_SIGNATURE', obfuscate: true)
  static final String panduanSignature = _AppEnv.panduanSignature;

  @EnviedField(varName: 'PLAY_CONSOLE_SHA256', obfuscate: true)
  static final String playConsoleSha256 = _AppEnv.playConsoleSha256;

  @EnviedField(varName: 'KEYSTORE_SHA256', obfuscate: true)
  static final String keystoreSha256 = _AppEnv.keystoreSha256;

  @EnviedField(varName: 'WATCHER_MAIL', obfuscate: true)
  static final String watcherMail = _AppEnv.watcherMail;
}
