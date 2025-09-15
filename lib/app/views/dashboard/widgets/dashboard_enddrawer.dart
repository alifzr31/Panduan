import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/views/login/login_page.dart';
import 'package:panduan/app/widgets/base_listtile.dart';
import 'package:panduan/app/widgets/show_customtoast.dart';
import 'package:permission_handler/permission_handler.dart';
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
              decoration: const BoxDecoration(color: AppColors.greenColor),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hai,',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade100,
                      ),
                    ),
                    const Text(
                      'Pengguna Panduan',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  BaseListTile(
                    leading: const Icon(
                      MingCute.information_line,
                      size: 22,
                      color: AppColors.blueColor,
                    ),
                    title: 'Info Aplikasi',
                    onTap: () async {
                      await openAppSettings();
                    },
                  ),
                  if (hasBiometricsHardware) ...{
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(height: 1, color: Colors.grey.shade300),
                    ),
                    BaseListTile(
                      leading: const Icon(
                        MingCute.fingerprint_line,
                        size: 22,
                        color: AppColors.blueColor,
                      ),
                      title: 'Sidik Jari',
                      subtitle: availableBiometrics.isNotEmpty
                          ? null
                          : 'Tidak ada sidik jari terdaftar diperangkat anda',
                      subtitleColor: Colors.red.shade600,
                      trailing: availableBiometrics.isEmpty
                          ? null
                          : Transform.scale(
                              scale: 0.6,
                              child: Switch(
                                activeThumbColor: const Color(0xFFE2E6FC),
                                activeTrackColor: AppColors.blueColor,
                                inactiveThumbColor: AppColors.blueColor,
                                inactiveTrackColor: const Color(0xFFE2E6FC),
                                trackOutlineColor: const WidgetStatePropertyAll(
                                  AppColors.blueColor,
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
                          type: ToastificationType.warning,
                          title: 'Berhasil',
                          description: 'Blablabla telah berhasil',
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
