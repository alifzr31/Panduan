import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/cubits/dashboard/dashboard_cubit.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/views/dashboard/components/counter_card.dart';
import 'package:panduan/app/views/dashboard/components/countercard_loading.dart';

class SpmCounterSection extends StatelessWidget {
  const SpmCounterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        switch (state.spmCountStatus) {
          case SpmCountStatus.success:
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CounterCard(
                        icon: MingCute.menu_line,
                        iconColor: AppColors.blueColor,
                        bgIconColor: AppColors.softBlueColor,
                        title: 'Total SPM',
                        count: state.spmCount?.total?.toString() ?? '',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CounterCard(
                        icon: MingCute.user_add_2_line,
                        iconColor: AppColors.amberColor,
                        bgIconColor: AppColors.softAmberColor,
                        title: 'Diterima',
                        count:
                            AppHelpers.hasPermission(
                              context.read<AuthCubit>().state.userPermissions,
                              permissionName: 'level-opd',
                            )
                            ? state.spmCount?.needVerificationOpd?.toString() ??
                                  ''
                            : AppHelpers.hasPermission(
                                context.read<AuthCubit>().state.userPermissions,
                                permissionName: 'level-kecamatan',
                              )
                            ? state.spmCount?.needApprovalDistrict
                                      ?.toString() ??
                                  ''
                            : state.spmCount?.needVerificationSubDistrict
                                      ?.toString() ??
                                  '',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: CounterCard(
                        icon: MingCute.mail_send_line,
                        iconColor: AppColors.greenColor,
                        bgIconColor: AppColors.softGreenColor,
                        title: 'Diteruskan',
                        count:
                            state.spmCount?.needVerificationOpd?.toString() ??
                            '',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CounterCard(
                        icon: MingCute.user_x_line,
                        iconColor: AppColors.redColor,
                        bgIconColor: AppColors.softRedColor,
                        title: 'Ditolak',
                        count:
                            AppHelpers.hasPermission(
                              context.read<AuthCubit>().state.userPermissions,
                              permissionName: 'level-opd',
                            )
                            ? state.spmCount?.declineByOpd?.toString() ?? ''
                            : AppHelpers.hasPermission(
                                context.read<AuthCubit>().state.userPermissions,
                                permissionName: 'level-kecamatan',
                              )
                            ? state.spmCount?.declineByDistrict?.toString() ??
                                  ''
                            : state.spmCount?.declineBySubDistrict
                                      ?.toString() ??
                                  '',
                      ),
                    ),
                  ],
                ),
              ],
            );
          default:
            return counterCardLoading();
        }
      },
    );
  }
}
