import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/cubits/dashboard/dashboard_cubit.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/views/dashboard/components/health_post/healthpost_card.dart';
import 'package:panduan/app/views/dashboard/components/health_post/healthpostcard_loading.dart';
import 'package:panduan/app/views/dashboard/widgets/health_post/healthpost_header.dart';
import 'package:panduan/app/views/hp_registration/hpregistration_page.dart';
import 'package:panduan/app/widgets/base_handlestate.dart';
import 'package:panduan/app/widgets/base_loadscroll.dart';

class DashboardHealthPost extends StatefulWidget {
  const DashboardHealthPost({super.key});

  @override
  State<DashboardHealthPost> createState() => _DashboardHealthPostState();
}

class _DashboardHealthPostState extends State<DashboardHealthPost> {
  List<String> _userPermissions = [];
  final _healthPostScrollController = ScrollController();
  final _searchHealthPostController = TextEditingController();
  String? _healthPostKeyword;
  Timer? _healthPostDebounce;
  String? _selectedDistrictCodeFilter;
  String? _selectedDistrictNameFilter;
  String? _selectedSubDistrictCodeFilter;
  String? _selectedSubDistrictNameFilter;
  String? _districtCode;
  String? _subDistrictCode;

  void _onScrollHealthPost() {
    if (_healthPostScrollController.hasClients) {
      final currentScroll = _healthPostScrollController.position.pixels;
      final maxScroll = _healthPostScrollController.position.maxScrollExtent;

      if (currentScroll == maxScroll &&
          context.read<DashboardCubit>().state.hasMoreHealthPost) {
        context.read<DashboardCubit>().fetchHealthPosts(
          keyword: _healthPostKeyword,
          districtCode:
              AppHelpers.hasPermission(
                _userPermissions,
                permissionName: 'level-kecamatan',
              )
              ? _districtCode
              : _selectedDistrictCodeFilter,
          subDistrictCode:
              AppHelpers.hasPermission(
                _userPermissions,
                permissionName: 'level-kelurahan',
              )
              ? _subDistrictCode
              : _selectedSubDistrictCodeFilter,
        );
      }
    }
  }

  void _onSearchHealthPost(String? keyword) {
    setState(() {
      _healthPostKeyword = keyword ?? '';
    });

    if (_healthPostDebounce?.isActive ?? false) _healthPostDebounce!.cancel();
    _healthPostDebounce = Timer(const Duration(milliseconds: 500), () {
      context.read<DashboardCubit>().refetchHealthPosts(
        keyword: _healthPostKeyword,
        districtCode:
            AppHelpers.hasPermission(
              _userPermissions,
              permissionName: 'level-kecamatan',
            )
            ? _districtCode
            : _selectedDistrictCodeFilter,
        subDistrictCode:
            AppHelpers.hasPermission(
              _userPermissions,
              permissionName: 'level-kelurahan',
            )
            ? _subDistrictCode
            : _selectedSubDistrictCodeFilter,
      );
    });
  }

  @override
  void dispose() {
    _healthPostScrollController
      ..removeListener(_onScrollHealthPost)
      ..dispose();
    _searchHealthPostController.dispose();
    _healthPostDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.authStatus != current.authStatus,
      listener: (context, state) {
        if (state.authStatus == AuthStatus.authorized) {
          setState(() {
            _userPermissions = state.userPermissions;
            _districtCode = state.profile?.districtCode;
            _subDistrictCode = state.profile?.subDistrictCode;
          });

          context
              .read<DashboardCubit>()
              .fetchHealthPosts(
                districtCode:
                    AppHelpers.hasPermission(
                      _userPermissions,
                      permissionName: 'level-kecamatan',
                    )
                    ? _districtCode
                    : _selectedDistrictCodeFilter,
                subDistrictCode:
                    AppHelpers.hasPermission(
                      _userPermissions,
                      permissionName: 'level-kelurahan',
                    )
                    ? _subDistrictCode
                    : _selectedSubDistrictCodeFilter,
              )
              .then((_) {
                _healthPostScrollController.addListener(_onScrollHealthPost);
              });
        }
      },
      child: Column(
        children: [
          HealthPostHeader(
            userPermissions: _userPermissions,
            searchHealthPostController: _searchHealthPostController,
            onSearchHealthPost: _onSearchHealthPost,
            selectedDistrictCodeFilter: _selectedDistrictCodeFilter,
            selectedDistrictNameFilter: _selectedDistrictNameFilter,
            selectedSubDistrictCodeFilter: _selectedSubDistrictCodeFilter,
            selectedSubDistrictNameFilter: _selectedSubDistrictNameFilter,
            onSelectedFilter: (resultMap) {
              final selectedDistrictCode = resultMap['selectedDistrictCode'];
              final selectedDistrictName = resultMap['selectedDistrictName'];
              final selectedSubDistrictCode =
                  resultMap['selectedSubDistrictCode'];
              final selectedSubDistrictName =
                  resultMap['selectedSubDistrictName'];

              setState(() {
                _selectedDistrictCodeFilter = selectedDistrictCode;
                _selectedDistrictNameFilter = selectedDistrictName;
                _selectedSubDistrictCodeFilter = selectedSubDistrictCode;
                _selectedSubDistrictNameFilter = selectedSubDistrictName;
              });

              if (context.mounted) {
                context.read<DashboardCubit>().refetchHealthPosts(
                  keyword: _healthPostKeyword,
                  districtCode:
                      AppHelpers.hasPermission(
                        _userPermissions,
                        permissionName: 'level-kecamatan',
                      )
                      ? _districtCode
                      : _selectedDistrictCodeFilter,
                  subDistrictCode:
                      AppHelpers.hasPermission(
                        _userPermissions,
                        permissionName: 'level-kelurahan',
                      )
                      ? _subDistrictCode
                      : _selectedSubDistrictCodeFilter,
                );
              }
            },
          ),
          Expanded(
            child: BlocBuilder<DashboardCubit, DashboardState>(
              builder: (context, state) {
                switch (state.healthPostStatus) {
                  case HealthPostStatus.error:
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: BaseHandleState(
                        handleType: HandleType.error,
                        errorMessage: state.healthPostError ?? '',
                        onRefetch: () {
                          context.read<DashboardCubit>().refetchHealthPosts(
                            keyword: _healthPostKeyword,
                            districtCode:
                                AppHelpers.hasPermission(
                                  _userPermissions,
                                  permissionName: 'level-kecamatan',
                                )
                                ? _districtCode
                                : _selectedDistrictCodeFilter,
                            subDistrictCode:
                                AppHelpers.hasPermission(
                                  _userPermissions,
                                  permissionName: 'level-kelurahan',
                                )
                                ? _subDistrictCode
                                : _selectedSubDistrictCodeFilter,
                          );
                        },
                      ),
                    );
                  case HealthPostStatus.success:
                    return state.healthPosts.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(16),
                            child: BaseHandleState(
                              handleType: HandleType.empty,
                              errorMessage: 'Data Posyandu Binaan Kosong',
                              onRefetch: () {
                                context
                                    .read<DashboardCubit>()
                                    .refetchHealthPosts(
                                      keyword: _healthPostKeyword,
                                      districtCode:
                                          AppHelpers.hasPermission(
                                            _userPermissions,
                                            permissionName: 'level-kecamatan',
                                          )
                                          ? _districtCode
                                          : _selectedDistrictCodeFilter,
                                      subDistrictCode:
                                          AppHelpers.hasPermission(
                                            _userPermissions,
                                            permissionName: 'level-kelurahan',
                                          )
                                          ? _subDistrictCode
                                          : _selectedSubDistrictCodeFilter,
                                    );
                              },
                            ),
                          )
                        : RefreshIndicator(
                            backgroundColor: Colors.white,
                            onRefresh: () async {
                              await Future.delayed(
                                const Duration(milliseconds: 2500),
                                () {
                                  _searchHealthPostController.clear();
                                  setState(() {
                                    _healthPostKeyword = null;
                                  });

                                  if (context.mounted) {
                                    context
                                        .read<DashboardCubit>()
                                        .refetchHealthPosts(
                                          keyword: _healthPostKeyword,
                                          districtCode:
                                              AppHelpers.hasPermission(
                                                _userPermissions,
                                                permissionName:
                                                    'level-kecamatan',
                                              )
                                              ? _districtCode
                                              : _selectedDistrictCodeFilter,
                                          subDistrictCode:
                                              AppHelpers.hasPermission(
                                                _userPermissions,
                                                permissionName:
                                                    'level-kelurahan',
                                              )
                                              ? _subDistrictCode
                                              : _selectedSubDistrictCodeFilter,
                                        );
                                  }
                                },
                              );
                            },
                            child: ListView.builder(
                              controller: _healthPostScrollController,
                              padding: const EdgeInsets.all(16),
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: state.hasMoreHealthPost
                                  ? state.healthPosts.length + 1
                                  : state.healthPosts.length,
                              itemBuilder: (context, index) {
                                return SafeArea(
                                  top: false,
                                  bottom: state.hasMoreHealthPost
                                      ? index == state.healthPosts.length
                                            ? true
                                            : false
                                      : index == state.healthPosts.length - 1
                                      ? true
                                      : false,
                                  child: index >= state.healthPosts.length
                                      ? const BaseLoadScroll()
                                      : HealthPostCard(
                                          healthPostName:
                                              state.healthPosts[index].name ??
                                              '',
                                          districtName:
                                              state
                                                  .healthPosts[index]
                                                  .districtName ??
                                              '',
                                          subDistrictName:
                                              state
                                                  .healthPosts[index]
                                                  .subDistrictName ??
                                              '',
                                          index: index,
                                          dataLength: state.healthPosts.length,
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              HpRegistrationPage.routeName,
                                              arguments: {
                                                'healthPostId':
                                                    state.healthPosts[index].id,
                                                'healthPostCode':
                                                    state
                                                        .healthPosts[index]
                                                        .code ??
                                                    '-',
                                              },
                                            );
                                          },
                                        ),
                                );
                              },
                            ),
                          );
                  default:
                    return const HealthPostCardLoading();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
