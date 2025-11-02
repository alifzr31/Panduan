import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:open_settings_plus/core/open_settings_plus.dart';
import 'package:open_settings_plus/open_settings_plus.dart';
import 'package:panduan/app/configs/local_notification/local_notif.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/views/change_password/changepassword_page.dart';
import 'package:panduan/app/views/login/login_page.dart';
import 'package:panduan/app/widgets/base_listtile.dart';
import 'package:panduan/app/widgets/base_skeletonizer.dart';
import 'package:panduan/app/widgets/show_customtoast.dart';
import 'package:toastification/toastification.dart';

class DashboardEndDrawer extends StatelessWidget {
  const DashboardEndDrawer({
    required this.appName,
    required this.appVersion,
    required this.hasBiometricsHardware,
    required this.biometricsEnabled,
    required this.availableBiometrics,
    this.onChangedBiometrics,
    super.key,
  });

  final String? appName;
  final String? appVersion;
  final bool hasBiometricsHardware;
  final bool biometricsEnabled;
  final List<BiometricType> availableBiometrics;
  final void Function(bool)? onChangedBiometrics;

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
                      return BaseListTile(
                        leading: const Icon(
                          MingCute.lock_line,
                          size: 22,
                          color: AppColors.blueColor,
                        ),
                        title: 'Ubah Kata Sandi',
                        subtitle: state.profile?.isNeedResetPassword ?? false
                            ? state.profile?.descriptionResetPassword
                            : null,
                        subtitleColor: Colors.red.shade600,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ChangePasswordPage.routeName,
                          );
                        },
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(height: 1, color: Colors.grey.shade300),
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
                  if (hasBiometricsHardware) ...{
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
                      title: Platform.isAndroid
                          ? 'Sidik Jari'
                          : 'Deteksi Wajah',
                      subtitle: availableBiometrics.isNotEmpty
                          ? null
                          : Platform.isAndroid
                          ? 'Tidak ada sidik jari terdaftar diperangkat anda'
                          : 'Tidak ada deteksi wajah terdaftar diperangkat anda',
                      subtitleColor: Colors.red.shade600,
                      trailing: availableBiometrics.isEmpty
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
                                value: biometricsEnabled,
                                onChanged: onChangedBiometrics,
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
                '$appName $appVersion',
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
