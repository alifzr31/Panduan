import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/cubits/dashboard/dashboard_cubit.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/views/spm/spm_page.dart';
import 'package:panduan/app/widgets/base_button.dart';

class AlertSpmCard extends StatelessWidget {
  const AlertSpmCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: AppColors.amberColor),
        borderRadius: BorderRadiusGeometry.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(
                  MingCute.alert_line,
                  size: 20,
                  color: AppColors.amberColor,
                ),
                SizedBox(width: 4),
                Text(
                  'Perhatian!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.amberColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            BlocBuilder<DashboardCubit, DashboardState>(
              builder: (context, state) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize: 14,
                        color: AppColors.amberColor,
                      ),
                      children: [
                        TextSpan(
                          text:
                              AppHelpers.hasPermission(
                                context.read<AuthCubit>().state.userPermissions,
                                permissionName: 'level-opd',
                              )
                              ? '${state.spmCount?.needVerificationOpd} SPM '
                              : AppHelpers.hasPermission(
                                  context
                                      .read<AuthCubit>()
                                      .state
                                      .userPermissions,
                                  permissionName: 'level-kecamatan',
                                )
                              ? '${state.spmCount?.needApprovalDistrict} SPM '
                              : '${state.spmCount?.needVerificationSubDistrict} SPM ',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const TextSpan(
                          text: 'memerlukan tindak lanjut segera.',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 36,
              width: double.infinity,
              child: BaseButtonIcon(
                bgColor: AppColors.amberColor,
                icon: MingCute.bill_line,
                iconSize: 16,
                label: 'Lihat SPM',
                labelSize: 12,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    SpmPage.routeName,
                    arguments:
                        AppHelpers.hasPermission(
                          context.read<AuthCubit>().state.userPermissions,
                          permissionName: 'level-opd',
                        )
                        ? 'NEED_VERIFICATION_OPD'
                        : AppHelpers.hasPermission(
                            context.read<AuthCubit>().state.userPermissions,
                            permissionName: 'level-kecamatan',
                          )
                        ? 'NEED_APPROVAL_DISTRICT'
                        : 'NEED_VERIFICATION_SUB_DISTRICT',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
