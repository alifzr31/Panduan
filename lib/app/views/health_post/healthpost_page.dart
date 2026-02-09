import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/cubits/health_post/health_post_cubit.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/views/health_post/components/healthpost_card.dart';
import 'package:panduan/app/views/health_post/components/healthpostcard_loading.dart';
import 'package:panduan/app/views/health_post/widgets/healthpost_header.dart';
import 'package:panduan/app/views/hp_registration/hpregistration_page.dart';
import 'package:panduan/app/widgets/base_handlestate.dart';
import 'package:panduan/app/widgets/base_loadscroll.dart';

class HealthPostPage extends StatefulWidget {
  const HealthPostPage({super.key});

  static const String routeName = '/healthPost';

  @override
  State<HealthPostPage> createState() => _HealthPostPageState();
}

class _HealthPostPageState extends State<HealthPostPage> {
  final _scrollController = ScrollController();
  final _searchHealthPostController = TextEditingController();
  String? _healthPostKeyword;
  Timer? _healthPostDebounce;
  String? _selectedDistrictCodeFilter;
  String? _selectedDistrictNameFilter;
  String? _selectedSubDistrictCodeFilter;
  String? _selectedSubDistrictNameFilter;
  List<String> _userPermissions = [];
  String? _districtCode;
  String? _subDistrictCode;

  void _onScroll() {
    if (_scrollController.hasClients) {
      final currentScroll = _scrollController.position.pixels;
      final maxScroll = _scrollController.position.maxScrollExtent;

      if (currentScroll == maxScroll &&
          context.read<HealthPostCubit>().state.hasMoreHealthPost) {
        context.read<HealthPostCubit>().fetchHealthPosts(
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
      context.read<HealthPostCubit>().refetchHealthPosts(
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
  void initState() {
    super.initState();
    setState(() {
      _userPermissions = context.read<AuthCubit>().state.userPermissions;
      _districtCode = context.read<AuthCubit>().state.profile?.districtCode;
      _subDistrictCode = context
          .read<AuthCubit>()
          .state
          .profile
          ?.subDistrictCode;
    });

    context
        .read<HealthPostCubit>()
        .fetchHealthPosts(
          keyword: _healthPostKeyword,
          districtCode:
              AppHelpers.hasPermission(
                _userPermissions,
                permissionName: 'level-kecamatan',
              )
              ? _districtCode
              : null,
          subDistrictCode:
              AppHelpers.hasPermission(
                _userPermissions,
                permissionName: 'level-kelurahan',
              )
              ? _subDistrictCode
              : null,
        )
        .then((_) {
          _scrollController.addListener(_onScroll);
        });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Posyandu Binaan',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
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
                context.read<HealthPostCubit>().refetchHealthPosts(
                  keyword: _healthPostKeyword,
                  districtCode: _selectedDistrictCodeFilter,
                  subDistrictCode: _selectedSubDistrictCodeFilter,
                );
              }
            },
          ),
          Expanded(
            child: BlocBuilder<HealthPostCubit, HealthPostState>(
              builder: (context, state) {
                switch (state.listStatus) {
                  case ListStatus.error:
                    return BaseHandleState(
                      handleType: HandleType.error,
                      errorMessage: state.listError ?? '',
                      onRefetch: () {
                        context.read<HealthPostCubit>().refetchHealthPosts(
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
                    );
                  case ListStatus.success:
                    return state.healthPosts.isEmpty
                        ? BaseHandleState(
                            handleType: HandleType.empty,
                            errorMessage: 'Data Posyandu Binaan Kosong',
                            onRefetch: () {
                              context
                                  .read<HealthPostCubit>()
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
                                        .read<HealthPostCubit>()
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
                              controller: _scrollController,
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
