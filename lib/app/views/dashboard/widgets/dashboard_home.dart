import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/cubits/dashboard/dashboard_cubit.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/views/dashboard/widgets/home/home_daterangepicker.dart';
import 'package:panduan/app/views/dashboard/widgets/home/home_header.dart';
import 'package:panduan/app/views/dashboard/widgets/home/home_kecamatan.dart';
import 'package:panduan/app/views/dashboard/widgets/home/home_kelurahan.dart';
import 'package:panduan/app/views/dashboard/widgets/home/home_opd.dart';
import 'package:panduan/app/views/dashboard/widgets/home/home_posyandu.dart';
import 'package:panduan/app/views/dashboard/widgets/home/home_walikota.dart';
import 'package:panduan/app/widgets/base_handlestate.dart';
import 'package:panduan/app/widgets/base_skeletonizer.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({
    required this.dashboardKey,
    required this.onSeeAllSpmNeedVerify,
    required this.onTapSpmFieldCounter,
    super.key,
  });

  final GlobalKey<ScaffoldState> dashboardKey;
  final void Function()? onSeeAllSpmNeedVerify;
  final void Function(String value) onTapSpmFieldCounter;

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  List<DateTime> _selectedRangeDates = [
    DateTime(DateTime.now().year, 1, 1),
    DateTime.now(),
  ];
  final _rangeDateController = TextEditingController();

  void _initRangeDate() async {
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
    _initRangeDate();
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
        if (state.authStatus == AuthStatus.authorized) {
          context.read<DashboardCubit>().initHomeDataByLevel(
            userPermissions: state.userPermissions,
            startDate: _selectedRangeDates.first,
            endDate: _selectedRangeDates.last,
          );
        }
      },
      child: Column(
        children: [
          HomeHeader(dashboardKey: widget.dashboardKey),
          Expanded(
            child: RefreshIndicator(
              backgroundColor: Colors.white,
              onRefresh: () async {
                await Future.delayed(const Duration(milliseconds: 2500), () {
                  if (context.mounted) {
                    context.read<AuthCubit>().fetchProfile().then((_) {
                      if (context.mounted) {
                        context.read<DashboardCubit>().refetchHomeDataByLevel(
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
                });
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  if (context.watch<AuthCubit>().state.profileStatus ==
                      ProfileStatus.success) ...{
                    HomeDateRangepicker(
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

                        context.read<DashboardCubit>().refetchHomeDataByLevel(
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
                              errorMessage: state.profileError ?? '',
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
                            return HomeWalikota(
                              selectedRangeDates: _selectedRangeDates,
                              onTapSpmFieldCounter: widget.onTapSpmFieldCounter,
                            );
                          } else if (AppHelpers.hasPermission(
                            state.userPermissions,
                            permissionName: 'level-opd',
                          )) {
                            return HomeOpd(
                              selectedRangeDates: _selectedRangeDates,
                              onSeeAllSpmNeedVerify:
                                  widget.onSeeAllSpmNeedVerify,
                            );
                          } else if (AppHelpers.hasPermission(
                            state.userPermissions,
                            permissionName: 'level-kecamatan',
                          )) {
                            return HomeKecamatan(
                              selectedRangeDates: _selectedRangeDates,
                              onSeeAllSpmNeedVerify:
                                  widget.onSeeAllSpmNeedVerify,
                            );
                          } else if (AppHelpers.hasPermission(
                            state.userPermissions,
                            permissionName: 'level-kelurahan',
                          )) {
                            return HomeKelurahan(
                              selectedRangeDates: _selectedRangeDates,
                              onSeeAllSpmNeedVerify:
                                  widget.onSeeAllSpmNeedVerify,
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
                            return HomePosyandu(
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
                                  padding: const EdgeInsets.only(bottom: 16),
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
    );
  }
}
