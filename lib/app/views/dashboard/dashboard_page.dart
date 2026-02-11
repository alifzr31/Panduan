import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/cubits/dashboard/dashboard_cubit.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/views/dashboard/widgets/dashboard_enddrawer.dart';
import 'package:panduan/app/views/dashboard/widgets/dashboard_home.dart';
import 'package:panduan/app/views/dashboard/widgets/dashboard_spm.dart';
import 'package:panduan/app/views/login/login_page.dart';
import 'package:panduan/app/views/spm_field/spmfield_page.dart';
import 'package:panduan/app/widgets/show_customtoast.dart';
import 'package:toastification/toastification.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  static const String routeName = '/dashboard';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _dashboardKey = GlobalKey<ScaffoldState>();
  int _currentTab = 0;
  List<String> _userPermissions = [];

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().fetchProfile();
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
          setState(() {
            _userPermissions = state.userPermissions;
          });
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
          resizeToAvoidBottomInset: _currentTab != 0 ? false : null,
          floatingActionButton:
              _currentTab == 1 &&
                  AppHelpers.hasPermission(
                    _userPermissions,
                    permissionName: 'user-submission-create',
                  )
              ? FloatingActionButton(
                  elevation: 2,
                  backgroundColor: AppColors.softBlueColor,
                  foregroundColor: AppColors.blueColor,
                  onPressed: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      SpmFieldPage.routeName,
                    );

                    if (!context.mounted) return;

                    if (result != null && result == 'created-spm') {
                      context.read<DashboardCubit>().refetchSpm();
                    }
                  },
                  child: const Icon(MingCute.add_fill),
                )
              : null,
          endDrawer: const DashboardEndDrawer(),
          endDrawerEnableOpenDragGesture: _currentTab == 0,
          body: IndexedStack(
            index: _currentTab,
            children: [
              DashboardHome(
                dashboardKey: _dashboardKey,
                onSeeAllSpmNeedVerify: () {
                  setState(() {
                    _currentTab = 1;
                  });
                  context.read<DashboardCubit>().onSelectedSpmStatus(
                    AppHelpers.hasPermission(
                          _userPermissions,
                          permissionName: 'level-opd',
                        )
                        ? 'NEED_VERIFICATION_OPD'
                        : AppHelpers.hasPermission(
                            _userPermissions,
                            permissionName: 'level-kecamatan',
                          )
                        ? 'NEED_APPROVAL_DISTRICT'
                        : 'NEED_VERIFICATION_SUB_DISTRICT',
                  );
                },
                onTapSpmFieldCounter: (value) {
                  setState(() {
                    _currentTab = 1;
                  });
                  context.read<DashboardCubit>().onSelectedSpmField(value);
                },
              ),
              const DashboardSpm(),
            ],
          ),
          bottomNavigationBar: FlashyTabBar(
            selectedIndex: _currentTab,
            iconSize: 24,
            showElevation: true,
            backgroundColor: Colors.white,
            height: kBottomNavigationBarHeight,
            animationCurve: Curves.easeInOutCubic,
            animationDuration: const Duration(milliseconds: 300),
            onItemSelected: (index) {
              setState(() {
                _currentTab = index;
              });
            },
            items: [
              FlashyTabBarItem(
                activeColor: AppColors.blueColor,
                inactiveColor: Colors.grey.shade600,
                icon: const Icon(MingCute.home_3_line),
                title: const Text('Beranda'),
              ),
              FlashyTabBarItem(
                activeColor: AppColors.blueColor,
                inactiveColor: Colors.grey.shade600,
                icon: const Icon(MingCute.paper_line),
                title: const Text('SPM'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
