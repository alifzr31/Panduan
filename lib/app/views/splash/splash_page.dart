import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:local_auth/local_auth.dart';
import 'package:open_settings_plus/core/open_settings_plus.dart';
import 'package:open_settings_plus/open_settings_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:panduan/app/configs/firebase/remoteconfig_service.dart';
import 'package:panduan/app/configs/storage/biom_storage/biom_storage.dart';
import 'package:panduan/app/configs/storage/storage_service.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/app_env.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/utils/app_strings.dart';
import 'package:panduan/app/views/dashboard/dashboard_page.dart';
import 'package:panduan/app/views/login/login_page.dart';
import 'package:panduan/app/views/update/update_page.dart';
import 'package:panduan/app/widgets/base_button.dart';
import 'package:panduan/app/widgets/base_textbutton.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const String routeName = '/';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool? _hasAuth;
  String? _appName;
  String? _appVersion;

  Future<void> _initSplash() async {
    try {
      final packageInfo = await _getPackageInfo();
      await RemoteConfigService.instance.init();

      if (!mounted) return;

      if (_shouldUpdate(packageInfo)) {
        final isLoggedIn = await _handleAuthFlow();

        if (!mounted) return;

        _goToUpdatePage(packageInfo, isLoggedIn);
        return;
      }

      final isLoggedIn = await _handleAuthFlow();

      if (!mounted) return;

      if (_hasAuth == false) return;

      _navigatePage(isLoggedIn: isLoggedIn);
    } catch (e) {
      if (kDebugMode) print(e);
      _navigatePage(isLoggedIn: false);
    }
  }

  Future<PackageInfo> _getPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();

    if (mounted) {
      setState(() {
        _appName = packageInfo.appName;
        _appVersion = packageInfo.version;
      });
    }

    return packageInfo;
  }

  bool _shouldUpdate(PackageInfo packageInfo) {
    final currentBuild = int.tryParse(packageInfo.buildNumber) ?? 0;
    final latestBuild = RemoteConfigService.instance.latestBuildNumber;

    return currentBuild < latestBuild;
  }

  Future<bool> _handleAuthFlow() async {
    final prefs = await SharedPreferences.getInstance();
    final biometricsEnabled = prefs.getBool('biometrics_enabled') ?? false;

    if (biometricsEnabled) {
      final canAuthenticate = await _checkBiometrics();

      if (!canAuthenticate) {
        return await _handleBiometricFailure();
      }

      final success = await _refreshToken();

      if (!mounted) return false;

      setState(() => _hasAuth = success);

      return success;
    } else {
      return await _refreshToken();
    }
  }

  Future<bool> _handleBiometricFailure() async {
    final isLoggedIn = await _refreshToken();

    if (!mounted) return false;

    _showBiometricsAlert(isLoggedIn: isLoggedIn);

    return isLoggedIn;
  }

  Future<bool> _refreshToken() async {
    final appTokenString = await StorageService.readAppToken();

    if (appTokenString == null) return false;

    final appToken = jsonDecode(appTokenString);

    final accessToken = appToken[AppStrings.accessToken];
    final refreshToken = appToken[AppStrings.refreshToken];

    if (accessToken == null || refreshToken == null) return false;

    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: AppEnv.baseOwnerUrl,
          headers: AppHelpers.addOnHeaders(),
        ),
      );

      if (kDebugMode) {
        dio.interceptors.add(
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseBody: false,
            error: true,
          ),
        );
      }

      final response = await dio.post(
        '/refresh-token',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        data: {'refresh_token': refreshToken},
      );

      if (response.data['status']) {
        final newAccessToken = response.data['data']['access_token'];
        final newRefreshToken = response.data['data']['refresh_token'];

        final rawToken = {
          AppStrings.accessToken: newAccessToken,
          AppStrings.refreshToken: newRefreshToken,
        };
        final token = jsonEncode(rawToken);

        final isSaved = await StorageService.writeAppToken(newAppToken: token);

        if (!isSaved) return false;

        if (mounted) {
          context.read<AuthCubit>().setTokens(
            newAccessToken: newAccessToken,
            newRefreshToken: newRefreshToken,
          );
        }

        return true;
      }

      return false;
    } catch (_) {
      if (mounted) {
        context.read<AuthCubit>().logoutSession();
      }

      return false;
    }
  }

  Future<bool> _checkBiometrics() async {
    try {
      final canCheck = await BiomStorage().checkBiometricHardware();
      final supported = await _localAuthentication.isDeviceSupported();
      final available = await BiomStorage().checkAvailableBiometrics();

      return available.isNotEmpty && (canCheck || supported);
    } catch (_) {
      return false;
    }
  }

  void _navigatePage({required bool isLoggedIn}) {
    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      isLoggedIn ? DashboardPage.routeName : LoginPage.routeName,
      (_) => false,
    );
  }

  void _goToUpdatePage(PackageInfo packageInfo, bool isLoggedIn) {
    Navigator.pushReplacementNamed(
      context,
      UpdatePage.routeName,
      arguments: {
        'isLoggedIn': isLoggedIn,
        'packageName': packageInfo.packageName,
        'currentVersion': packageInfo.version,
        'currentBuildNumber': int.tryParse(packageInfo.buildNumber) ?? 0,
        'latestVersion': RemoteConfigService.instance.latestVersion,
        'latestBuildNumber': RemoteConfigService.instance.latestBuildNumber,
        'mandatoryUpdate': RemoteConfigService.instance.mandatoryUpdate,
        'updateDescription': RemoteConfigService.instance.updateDescription,
      },
    );
  }

  void _showBiometricsAlert({required bool isLoggedIn}) {
    if (!mounted) return;

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
            'Perangkat anda mendukung keamanan biometrik tetapi anda belum mengaturnya. '
            'Silahkan atur keamanan biometrik dengan cara menambahkan sidik jari atau deteksi wajah '
            'di pengaturan perangkat anda sebagai keamanan tambahan. Terima kasih!',
          ),
          actions: [
            BaseTextButton(
              size: 14,
              text: 'Atur Sekarang',
              color: AppColors.blueColor,
              onPressed: () {
                switch (OpenSettingsPlus.shared) {
                  case OpenSettingsPlusAndroid android:
                    android.biometricEnroll();
                    break;
                  case OpenSettingsPlusIOS ios:
                    ios.faceIDAndPasscode();
                    break;
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
                Navigator.of(context).pop(); // tutup dialog
                _navigatePage(isLoggedIn: isLoggedIn);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _retryBiometric() async {
    final success = await _refreshToken();

    if (!mounted) return;

    setState(() => _hasAuth = success);

    _navigatePage(isLoggedIn: success);
  }

  @override
  void initState() {
    super.initState();
    _initSplash();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _hasAuth == null || _hasAuth == false,
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
                            onPressed: _retryBiometric,
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
