import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:local_auth/local_auth.dart';
import 'package:open_settings_plus/core/open_settings_plus.dart';
import 'package:open_settings_plus/open_settings_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:panduan/app/configs/local_notification/local_notif.dart';
import 'package:panduan/app/configs/storage/biom_storage/biom_storage.dart';
import 'package:panduan/app/configs/storage/storage_service.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/views/change_password/changepassword_page.dart';
import 'package:panduan/app/views/health_post/healthpost_page.dart';
import 'package:panduan/app/views/login/login_page.dart';
import 'package:panduan/app/widgets/base_listtile.dart';
import 'package:panduan/app/widgets/base_skeletonizer.dart';
import 'package:panduan/app/widgets/show_customtoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

class DashboardEndDrawer extends StatefulWidget {
  const DashboardEndDrawer({super.key});

  @override
  State<DashboardEndDrawer> createState() => _DashboardEndDrawerState();
}

class _DashboardEndDrawerState extends State<DashboardEndDrawer> {
  bool _hasBiometricsHardware = false;
  List<BiometricType> _availableBiometrics = const [];
  bool _biometricsEnabled = false;
  String? _appName;
  String? _appVersion;

  Future<void> _getPackageInfo() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();

      _appName = packageInfo.appName;
      _appVersion = packageInfo.version;
      setState(() {});
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<void> _checkBiometricsHardware() async {
    try {
      final canAuthenticateWithBiometrics = await BiomStorage()
          .checkBiometricHardware();
      final availableBiometrics = await BiomStorage()
          .checkAvailableBiometrics();

      _hasBiometricsHardware = canAuthenticateWithBiometrics;
      _availableBiometrics = availableBiometrics;
      setState(() {});
    } on PlatformException catch (e) {
      if (kDebugMode) print(e.message);
    }
  }

  Future<void> _checkBiometricsEnabled() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    _biometricsEnabled =
        sharedPreferences.getBool('biometrics_enabled') ?? false;
    setState(() {});
  }

  void _initEndDrawer() async {
    await _getPackageInfo();
    await _checkBiometricsHardware();
    await _checkBiometricsEnabled();
  }

  @override
  void initState() {
    super.initState();
    _initEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            DrawerHeader(
              padding: const EdgeInsets.all(16),
              margin: EdgeInsets.zero,
              decoration: const BoxDecoration(color: AppColors.blueColor),
              child: SizedBox(
                width: double.infinity,
                child: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    switch (state.profileStatus) {
                      case ProfileStatus.success:
                        return Row(
                          children: [
                            const Icon(
                              MingCute.user_4_fill,
                              size: 66,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Selamat Datang!',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    state.profile?.name ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    state.profile?.email ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      default:
                        return Row(
                          children: [
                            const Icon(
                              MingCute.user_4_fill,
                              size: 66,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Selamat Datang!',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const BaseSkeletonizer(
                                    child: Text(
                                      'xxxxxxxxxxxxxx',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  BaseSkeletonizer(
                                    child: Text(
                                      'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          if (!AppHelpers.hasPermission(
                                state.userPermissions,
                                permissionName: 'level-posyandu',
                              ) &&
                              !AppHelpers.hasPermission(
                                state.userPermissions,
                                permissionName: 'level-opd',
                              )) ...{
                            BaseListTile(
                              leading: const Icon(
                                MingCute.building_5_line,
                                size: 22,
                                color: AppColors.blueColor,
                              ),
                              title: 'Posyandu Binaan',
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  HealthPostPage.routeName,
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Divider(
                                height: 1,
                                color: Colors.grey.shade300,
                              ),
                            ),
                          },
                          BaseListTile(
                            leading: const Icon(
                              MingCute.lock_line,
                              size: 22,
                              color: AppColors.blueColor,
                            ),
                            title: 'Ubah Kata Sandi',
                            subtitle:
                                state.profile?.isNeedResetPassword ?? false
                                ? state.profile?.descriptionResetPassword
                                : null,
                            subtitleColor: Colors.red.shade600,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                ChangePasswordPage.routeName,
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(
                              height: 1,
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  BaseListTile(
                    leading: const Icon(
                      MingCute.information_line,
                      size: 22,
                      color: AppColors.blueColor,
                    ),
                    title: 'Info Aplikasi',
                    onTap: () {
                      switch (OpenSettingsPlus.shared) {
                        case OpenSettingsPlusAndroid openSettingsPlusAndroid:
                          openSettingsPlusAndroid.applicationDetails();
                        case OpenSettingsPlusIOS openSettingsPlusIOS:
                          openSettingsPlusIOS.appSettings();
                        default:
                          if (kDebugMode) print('Platform not supported');
                      }
                    },
                  ),
                  if (kDebugMode) ...{
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(height: 1, color: Colors.grey.shade300),
                    ),
                    BaseListTile(
                      leading: const Icon(
                        MingCute.notification_line,
                        size: 22,
                        color: AppColors.blueColor,
                      ),
                      title: 'Tes Notifikasi',
                      onTap: () async {
                        await LocalNotif().showNotifications(
                          id: 1,
                          title: 'Tes Notifikasi',
                          body: 'Deskripsi tes notifikasi',
                        );
                      },
                    ),
                  },
                  if (_hasBiometricsHardware) ...{
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(height: 1, color: Colors.grey.shade300),
                    ),
                    BaseListTile(
                      leading: Icon(
                        Platform.isAndroid
                            ? MingCute.fingerprint_line
                            : MingCute.faceid_line,
                        size: 22,
                        color: AppColors.blueColor,
                      ),
                      title: 'Biometrik',
                      subtitle: _availableBiometrics.isNotEmpty
                          ? 'Aktifkan keamanan biometrik (sidik jari/deteksi wajah)'
                          : 'Tidak ada sidik jari/deteksi wajah terdaftar diperangkat anda',
                      subtitleColor: _availableBiometrics.isNotEmpty
                          ? Colors.grey.shade600
                          : Colors.red.shade600,
                      trailing: _availableBiometrics.isEmpty
                          ? null
                          : Transform.scale(
                              scale: 0.6,
                              child: Switch(
                                activeThumbColor: AppColors.softPinkColor,
                                activeTrackColor: AppColors.pinkColor,
                                inactiveThumbColor: AppColors.pinkColor,
                                inactiveTrackColor: AppColors.softPinkColor,
                                trackOutlineColor: const WidgetStatePropertyAll(
                                  AppColors.pinkColor,
                                ),
                                value: _biometricsEnabled,
                                onChanged: (value) async {
                                  final isSuccess =
                                      await StorageService.setupBiometric(
                                        value,
                                      );

                                  if (!context.mounted) return;

                                  if (isSuccess) {
                                    _biometricsEnabled = value;
                                    setState(() {});
                                  }
                                },
                                padding: EdgeInsets.zero,
                              ),
                            ),
                    ),
                  },
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(height: 1, color: Colors.grey.shade300),
                  ),
                  BlocListener<AuthCubit, AuthState>(
                    listenWhen: (previous, current) =>
                        previous.logoutStatus != current.logoutStatus,
                    listener: (context, state) {
                      if (state.logoutStatus == LogoutStatus.loading) {
                        context.loaderOverlay.show();
                      }

                      if (state.logoutStatus == LogoutStatus.success) {
                        context.loaderOverlay.hide();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          LoginPage.routeName,
                          (route) => false,
                        );
                        showCustomToast(
                          context,
                          type: state.logoutReason == 'password-updated'
                              ? ToastificationType.info
                              : ToastificationType.success,
                          title: state.logoutReason == 'password-updated'
                              ? 'Ubah Kata Sandi Berhasil'
                              : 'Keluar Berhasil',
                          description: state.logoutReason == 'password-updated'
                              ? 'Silahkan masuk kembali menggunakan kata sandi baru anda'
                              : 'Sampai jumpa kembali!',
                        );

                        context.read<AuthCubit>().resetState();
                      }

                      if (state.logoutStatus == LogoutStatus.error) {
                        context.loaderOverlay.hide();
                        showCustomToast(
                          context,
                          type: ToastificationType.error,
                          title: 'Keluar Gagal',
                          description: state.logoutError,
                        );
                      }
                    },
                    child: BaseListTile(
                      leading: const Icon(
                        MingCute.exit_line,
                        size: 22,
                        color: AppColors.blueColor,
                      ),
                      title: 'Keluar',
                      onTap: () {
                        context.read<AuthCubit>().logout();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '$_appName $_appVersion',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
