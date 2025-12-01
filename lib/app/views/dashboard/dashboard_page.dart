import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/cubits/dashboard/dashboard_cubit.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/utils/app_strings.dart';
import 'package:panduan/app/views/dashboard/widgets/dashboard_body_kecamatan.dart';
import 'package:panduan/app/views/dashboard/widgets/dashboard_body_kelurahan.dart';
import 'package:panduan/app/views/dashboard/widgets/dashboard_body_opd.dart';
import 'package:panduan/app/views/dashboard/widgets/dashboard_body_posyandu.dart';
import 'package:panduan/app/views/dashboard/widgets/dashboard_body_walikota.dart';
import 'package:panduan/app/views/dashboard/widgets/dashboard_enddrawer.dart';
import 'package:panduan/app/views/dashboard/widgets/dashboard_header.dart';
import 'package:panduan/app/views/dashboard/widgets/daterangepicker_section.dart';
import 'package:panduan/app/views/login/login_page.dart';
import 'package:panduan/app/widgets/base_handlestate.dart';
import 'package:panduan/app/widgets/base_skeletonizer.dart';
import 'package:panduan/app/widgets/show_customtoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

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
  List<DateTime> _selectedRangeDates = [
    DateTime(DateTime.now().year, 1, 1),
    DateTime.now(),
  ];
  final _rangeDateController = TextEditingController();

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
        localizedReason:
            'Silahkan pindai sidik jari/deteksi wajah anda untuk melanjutkan',
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'Panduan',
            signInHint: 'Masuk dengan biometrik',
            cancelButton: 'Batal',
          ),
        ],
        biometricOnly: true,
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

  Future<void> _setBiometrics(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('biometrics_enabled', value);
    await sharedPreferences.reload();

    setState(() {
      _biometricsEnabled = value;
    });
  }

  void _initDashboardData() async {
    await _getPackageInfo();
    await _checkBiometricsHardware();
    await _checkBiometricsEnabled();

    final isFirstYear =
        _selectedRangeDates.first.day == _selectedRangeDates.last.day &&
        _selectedRangeDates.first.month == _selectedRangeDates.last.month &&
        _selectedRangeDates.first.year == _selectedRangeDates.last.year;

    if (isFirstYear) {
      _rangeDateController.text = AppHelpers.rangeDateFormat(
        _selectedRangeDates.first,
      );
    } else {
      _rangeDateController.text =
          '${AppHelpers.rangeDateFormat(_selectedRangeDates.first)} - ${AppHelpers.rangeDateFormat(_selectedRangeDates.last)}';
    }
  }

  @override
  void initState() {
    _initDashboardData();
    context.read<AuthCubit>().fetchProfile();
    super.initState();
  }

  @override
  void dispose() {
    _rangeDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.authStatus != current.authStatus,
      listener: (context, state) {
        if (state.authStatus == AuthStatus.loading) {
          context.loaderOverlay.show();
        }

        if (state.authStatus == AuthStatus.authorized) {
          context.loaderOverlay.hide();
          context.read<DashboardCubit>().initDataByLevel(
            userPermissions: context.read<AuthCubit>().state.userPermissions,
            startDate: _selectedRangeDates.first,
            endDate: _selectedRangeDates.last,
          );
        }

        if (state.authStatus == AuthStatus.unauthorized) {
          context.loaderOverlay.hide();
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginPage.routeName,
            (route) => false,
          );
          showCustomToast(
            context,
            type: ToastificationType.info,
            title: 'Sesi Habis',
            description: 'Silahkan masuk ulang karena sesi sudah habis!',
          );
        }
      },
      child: PopScope(
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
          body: Column(
            children: [
              DashboardHeader(dashboardKey: _dashboardKey),
              Expanded(
                child: RefreshIndicator(
                  backgroundColor: Colors.white,
                  onRefresh: () async {
                    await Future.delayed(
                      const Duration(milliseconds: 2500),
                      () {
                        if (context.mounted) {
                          context.read<AuthCubit>().fetchProfile().then((_) {
                            if (context.mounted) {
                              context.read<DashboardCubit>().refetchDataByLevel(
                                userPermissions: context
                                    .read<AuthCubit>()
                                    .state
                                    .userPermissions,
                                startDate: _selectedRangeDates.first,
                                endDate: _selectedRangeDates.last,
                              );
                            }
                          });
                        }
                      },
                    );
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (context.watch<AuthCubit>().state.profileStatus ==
                          ProfileStatus.success) ...{
                        DateRangePickerSection(
                          rangeDateController: _rangeDateController,
                          selectedRangeDates: _selectedRangeDates,
                          onSelectedRangeDate: (dates) {
                            setState(() {
                              _selectedRangeDates = dates;
                            });

                            _rangeDateController.text =
                                dates.first.isAtSameMomentAs(dates.last)
                                ? AppHelpers.rangeDateFormat(
                                    _selectedRangeDates.first,
                                  )
                                : '${AppHelpers.rangeDateFormat(_selectedRangeDates.first)} - ${AppHelpers.rangeDateFormat(_selectedRangeDates.last)}';

                            context.read<DashboardCubit>().refetchDataByLevel(
                              userPermissions: context
                                  .read<AuthCubit>()
                                  .state
                                  .userPermissions,
                              startDate: _selectedRangeDates.first,
                              endDate: _selectedRangeDates.last,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                      },
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          switch (state.profileStatus) {
                            case ProfileStatus.error:
                              return SizedBox(
                                height:
                                    AppHelpers.getHeightDevice(context) -
                                    (200 +
                                        AppHelpers.getBottomViewPaddingDevice(
                                          context,
                                        )),
                                width: double.infinity,
                                child: BaseHandleState(
                                  handleType: HandleType.error,
                                  errorMessage:
                                      state.profileError ??
                                      AppStrings.errorApiMessage,
                                  onRefetch: () {
                                    context.read<AuthCubit>().refetchProfile();
                                  },
                                ),
                              );
                            case ProfileStatus.success:
                              if (AppHelpers.hasPermission(
                                state.userPermissions,
                                permissionName: 'level-superadmin',
                              )) {
                                return const Center(child: Text('Superadmin'));
                              } else if (AppHelpers.hasPermission(
                                state.userPermissions,
                                permissionName: 'level-walikota',
                              )) {
                                return DashboardBodyWalikota(
                                  selectedRangeDates: _selectedRangeDates,
                                );
                              } else if (AppHelpers.hasPermission(
                                state.userPermissions,
                                permissionName: 'level-opd',
                              )) {
                                return DashboardBodyOpd(
                                  selectedRangeDates: _selectedRangeDates,
                                );
                              } else if (AppHelpers.hasPermission(
                                state.userPermissions,
                                permissionName: 'level-kecamatan',
                              )) {
                                return DashboardBodyKecamatan(
                                  selectedRangeDates: _selectedRangeDates,
                                );
                              } else if (AppHelpers.hasPermission(
                                state.userPermissions,
                                permissionName: 'level-kelurahan',
                              )) {
                                return DashboardBodyKelurahan(
                                  selectedRangeDates: _selectedRangeDates,
                                );
                              } else if (AppHelpers.hasPermission(
                                state.userPermissions,
                                permissionName: 'level-puskesmas',
                              )) {
                                return const Center(child: Text('Puskesmas'));
                              } else if (AppHelpers.hasPermission(
                                state.userPermissions,
                                permissionName: 'level-posyandu',
                              )) {
                                return DashboardBodyPosyandu(
                                  selectedRangeDates: _selectedRangeDates,
                                );
                              } else {
                                return const Center(
                                  child: Text(
                                    'Level Tidak Ditemukan',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              }
                            default:
                              return BaseSkeletonizer(
                                child: Column(
                                  children: List.generate(10, (index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                      ),
                                      child: Material(
                                        elevation: 1,
                                        borderRadius: BorderRadius.circular(10),
                                        clipBehavior: Clip.antiAlias,
                                        child: Container(
                                          height: 220,
                                          width: double.infinity,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
