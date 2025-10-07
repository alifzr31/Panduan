import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/cubits/dashboard/dashboard_cubit.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/app_strings.dart';
import 'package:panduan/app/views/notification/notification_page.dart';
import 'package:panduan/app/widgets/base_iconbutton.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({required this.dashboardKey, super.key});

  final GlobalKey<ScaffoldState> dashboardKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.white,
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        '${AppStrings.assetsImages}/panduan-logo.svg',
                        width: 34,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'PANDUAN',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                CupertinoButton(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.pushNamed(context, NotificationPage.routeName);
                  },
                  child: BlocBuilder<DashboardCubit, DashboardState>(
                    builder: (context, state) {
                      return Badge(
                        label: Text(
                          state.unreadNotificationCount < 99
                              ? state.unreadNotificationCount.toString()
                              : '99+',
                          style: const TextStyle(fontSize: 10),
                        ),
                        isLabelVisible: state.unreadNotificationCount > 0,
                        child: const Icon(
                          MingCute.notification_line,
                          size: 22,
                          color: AppColors.amberColor,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                BaseIconButton(
                  icon: MingCute.menu_line,
                  size: 22,
                  onPressed: () {
                    dashboardKey.currentState?.openEndDrawer();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
