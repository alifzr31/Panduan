import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:open_settings_plus/core/open_settings_plus.dart';
import 'package:open_settings_plus/open_settings_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:panduan/app/configs/firebase/remoteconfig_service.dart';
import 'package:panduan/app/configs/secure_storage/secure_storage.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/utils/app_strings.dart';
import 'package:panduan/app/views/dashboard/dashboard_page.dart';
import 'package:panduan/app/views/login/login_page.dart';
import 'package:panduan/app/views/update/update_page.dart';
import 'package:panduan/app/widgets/base_button.dart';
import 'package:panduan/app/widgets/base_textbutton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const String routeName = '/';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;
  bool _isLoggedIn = false;
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool? _hasAuth;
  String? _appName;
  String? _appVersion;

  void _initTimer() async {
    final packageInfo = await _getPackageInfo();
    final isLoggedIn = await _checkLoggedIn();

    setState(() {
      _isLoggedIn = isLoggedIn;
    });

    _timer = Timer(const Duration(milliseconds: 1500), () async {
      try {
        await _initRemoteConfig(isLoggedIn, packageInfo);
      } catch (e) {
        if (kDebugMode) print(e);
      }
    });
  }

  Future<PackageInfo> _getPackageInfo() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();

      setState(() {
        _appName = packageInfo.appName;
        _appVersion = packageInfo.version;
      });

      return packageInfo;
    } catch (e) {
      if (kDebugMode) print(e);
      rethrow;
    }
  }

  Future<bool> _checkLoggedIn() async {
    try {
      final accessToken = await SecureStorage.readStorage(
        key: AppStrings.accessToken,
      );

      if (accessToken != null) {
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> _initRemoteConfig(
    bool isLoggedIn,
    PackageInfo packageInfo,
  ) async {
    try {
      await RemoteConfigService.instance.init();

      final packageName = packageInfo.packageName;
      final currentVersion = packageInfo.version;
      final currentBuildNumber = int.tryParse(packageInfo.buildNumber) ?? 0;
      final latestVersion = RemoteConfigService.instance.latestVersion;
      final latestBuildNumber = RemoteConfigService.instance.latestBuildNumber;
      final mandatoryUpdate = RemoteConfigService.instance.mandatoryUpdate;
      final updateDescription = RemoteConfigService.instance.updateDescription;
      final shouldUpdate = currentBuildNumber < latestBuildNumber;

      if (shouldUpdate) {
        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            UpdatePage.routeName,
            arguments: {
              'isLoggedIn': isLoggedIn,
              'packageName': packageName,
              'currentVersion': currentVersion,
              'currentBuildNumber': currentBuildNumber,
              'latestVersion': latestVersion,
              'latestBuildNumber': latestBuildNumber,
              'mandatoryUpdate': mandatoryUpdate,
              'updateDescription': updateDescription,
            },
          );
        }
      } else {
        _didBiometricsAuth(isLoggedIn: isLoggedIn);
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<bool> _checkBiometricsHardware() async {
    try {
      return await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      if (kDebugMode) print(e.message);
      return false;
    }
  }

  Future<bool> _checkBiometrics() async {
    try {
      final canAuthenticateWithBiometrics = await _checkBiometricsHardware();
      final canAuthenticate =
          canAuthenticateWithBiometrics ||
          await _localAuthentication.isDeviceSupported();
      final availableBiometrics = await _localAuthentication
          .getAvailableBiometrics();

      return availableBiometrics.isEmpty ? false : canAuthenticate;
    } on PlatformException catch (e) {
      if (kDebugMode) print(e.message);
      return false;
    }
  }

  Future<bool> _authBiometrics() async {
    try {
      final didAuthFingerprint = await _localAuthentication.authenticate(
        localizedReason:
            'Silahkan pindai sidik jari/deteksi wajah anda untuk melanjutkan',
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'Panduan',
            signInHint: 'Masuk dengan biometrik',
            cancelButton: 'Batal',
          ),
        ],
        biometricOnly: false,
        sensitiveTransaction: true,
      );

      return didAuthFingerprint;
    } on LocalAuthException catch (e) {
      switch (e.code) {
        case LocalAuthExceptionCode.userCanceled:
          return false;
        default:
          if (kDebugMode) print(e.code);
          if (kDebugMode) print(e.description);
          if (kDebugMode) print(e.details);
          rethrow;
      }
    }
  }

  void _didBiometricsAuth({bool isLoggedIn = false}) async {
    final canAuthenticate = await _checkBiometrics();
    final hasBiometricsHardware = await _checkBiometricsHardware();
    final sharedPreferences = await SharedPreferences.getInstance();
    final biometricsEnabled =
        sharedPreferences.getBool('biometrics_enabled') ?? false;

    if (isLoggedIn) {
      if (hasBiometricsHardware) {
        if (canAuthenticate) {
          if (biometricsEnabled) {
            final didAuthFingerprint = await _authBiometrics();

            print(didAuthFingerprint);

            setState(() {
              _hasAuth = didAuthFingerprint;
            });

            if (_hasAuth ?? false) {
              _navigatePage(isLoggedIn: isLoggedIn);
            }
          } else {
            _navigatePage(isLoggedIn: isLoggedIn);
          }
        } else {
          _showBiometricsAlert(isLoggedIn: isLoggedIn);
        }
      } else {
        _navigatePage(isLoggedIn: isLoggedIn);
      }
    } else {
      _navigatePage(isLoggedIn: isLoggedIn);
    }
  }

  void _navigatePage({bool isLoggedIn = false}) {
    if (mounted) {
      if (isLoggedIn) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          DashboardPage.routeName,
          (route) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          LoginPage.routeName,
          (route) => false,
        );
      }
    }
  }

  void _showBiometricsAlert({bool isLoggedIn = false}) {
    if (mounted) {
      showAdaptiveDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            clipBehavior: Clip.antiAlias,
            elevation: 1,
            surfaceTintColor: Colors.white,
            titleTextStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Jost',
              color: Colors.black,
            ),
            contentTextStyle: const TextStyle(
              fontSize: 14,
              fontFamily: 'Jost',
              color: Colors.black,
            ),
            title: const Text('Informasi Keamanan'),
            content: const Text(
              'Perangkat anda mendukung keamanan biometrik tetapi anda belum mengaturnya. Silahkan atur keamanan biometrik dengan cara menambahkan sidik jari atau deteksi wajah di pengaturan perangkat anda sebagai keamanan tambahan. Terima kasih!',
            ),
            actions: [
              BaseTextButton(
                size: 14,
                text: 'Atur Sekarang',
                color: AppColors.blueColor,
                onPressed: () {
                  switch (OpenSettingsPlus.shared) {
                    case OpenSettingsPlusAndroid openSettingsPlusAndroid:
                      openSettingsPlusAndroid.biometricEnroll();
                    case OpenSettingsPlusIOS openSettingsPlusIOS:
                      openSettingsPlusIOS.faceIDAndPasscode();
                    default:
                      if (kDebugMode) print('Platform not supported');
                  }
                },
              ),
              const SizedBox(width: 6),
              BaseTextButton(
                size: 14,
                text: 'Nanti Saja',
                onPressed: () {
                  _navigatePage(isLoggedIn: isLoggedIn);
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    _initTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: SizedBox(
            height: AppHelpers.getHeightDevice(context),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          '${AppStrings.assetsImages}/panduan-logo.svg',
                        ),
                        if (_hasAuth != null && _hasAuth == false) ...{
                          const SizedBox(height: 16),
                          BaseButtonIcon(
                            label: 'Masuk',
                            icon: MingCute.fingerprint_line,
                            onPressed: () {
                              _didBiometricsAuth(isLoggedIn: _isLoggedIn);
                            },
                          ),
                        },
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Text(
                          '$_appName Versi $_appVersion',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Pemerintah Kota Bandung',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
