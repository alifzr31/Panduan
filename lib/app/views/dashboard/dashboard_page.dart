import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:panduan/app/views/dashboard/widgets/dashboard_enddrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  static const String routeName = '/dashboard';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _dashboardKey = GlobalKey<ScaffoldState>();
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool _hasBiometricsHardware = false;
  List<BiometricType> _availableBiometrics = const [];
  bool _biometricsEnabled = false;
  String? _appName;
  String? _appVersion;

  Future<void> _getPackageInfo() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();

      setState(() {
        _appName = packageInfo.appName;
        _appVersion = packageInfo.version;
      });
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<void> _checkBiometricsHardware() async {
    try {
      final canAuthenticateWithBiometrics =
          await _localAuthentication.canCheckBiometrics;
      final availableBiometrics = await _localAuthentication
          .getAvailableBiometrics();

      setState(() {
        _hasBiometricsHardware = canAuthenticateWithBiometrics;
        _availableBiometrics = availableBiometrics;
      });
    } on PlatformException catch (e) {
      if (kDebugMode) print(e.message);
    }
  }

  Future<void> _checkBiometricsEnabled() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      _biometricsEnabled =
          sharedPreferences.getBool('biometrics_enabled') ?? false;
    });
  }

  Future<bool> _authBiometrics() async {
    try {
      final didAuthFingerprint = await _localAuthentication.authenticate(
        localizedReason: 'Silahkan pindai sidik jari anda untuk melanjutkan',
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'Panduan',
            biometricHint: 'Aktifkan keamanan sidik jari',
            cancelButton: 'Batal',
            biometricNotRecognized: 'Sidik jari tidak dikenali, coba lagi',
            biometricSuccess: 'Autentikasi berhasil',
          ),
        ],
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          sensitiveTransaction: true,
          useErrorDialogs: true,
        ),
      );

      return didAuthFingerprint;
    } on PlatformException catch (e) {
      if (kDebugMode) print(e.message);
      return false;
    }
  }

  Future<void> _setBiometrics(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('biometrics_enabled', value);
    await sharedPreferences.reload();

    setState(() {
      _biometricsEnabled = value;
    });
  }

  @override
  void initState() {
    _getPackageInfo();
    _checkBiometricsHardware();
    _checkBiometricsEnabled();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (_dashboardKey.currentState?.isEndDrawerOpen ?? false) {
            _dashboardKey.currentState?.closeEndDrawer();
          } else {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          }
        }
      },
      child: Scaffold(
        key: _dashboardKey,
        appBar: AppBar(
          title: const Text(
            'Dashboard',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
        ),
        endDrawer: DashboardEndDrawer(
          appName: _appName,
          appVersion: _appVersion,
          hasBiometricsHardware: _hasBiometricsHardware,
          biometricsEnabled: _biometricsEnabled,
          availableBiometrics: _availableBiometrics,
          onChangedBiometrics: (value) {
            if (_biometricsEnabled) {
              _setBiometrics(value);
            } else {
              _authBiometrics().then((didAuth) {
                if (didAuth) {
                  _setBiometrics(value);
                }
              });
            }
          },
        ),
      ),
    );
  }
}
