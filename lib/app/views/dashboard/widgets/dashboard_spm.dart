import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/cubits/dashboard/dashboard_cubit.dart';
import 'package:panduan/app/views/dashboard/components/spm/spm_card.dart';
import 'package:panduan/app/views/dashboard/components/spm/spmcard_loading.dart';
import 'package:panduan/app/views/dashboard/widgets/spm/spm_header.dart';
import 'package:panduan/app/views/detail_spm/detailspm_page.dart';
import 'package:panduan/app/widgets/base_handlestate.dart';
import 'package:panduan/app/widgets/base_loadscroll.dart';

class DashboardSpm extends StatefulWidget {
  const DashboardSpm({super.key});

  @override
  State<DashboardSpm> createState() => _DashboardSpmState();
}

class _DashboardSpmState extends State<DashboardSpm> {
  final _spmScrollController = ScrollController();

  final _searchSpmController = TextEditingController();
  String? _spmKeyword;
  Timer? _spmDebounce;
  String? _selectedDistrictCode;
  String? _selectedSubDistrictCode;
  String? _selectedHealthPostUuid;
  final Set<String> _selectedStatus = {};
  String? _selectedSpmField;
  final _years = List.generate(3, (index) {
    return DateTime.now().year - index;
  });
  final _selectedYear = ValueNotifier<int>(DateTime.now().year);
  final _months = const [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  final _selectedMonth = ValueNotifier<int?>(null);

  void _onScrollSpm() {
    if (_spmScrollController.hasClients) {
      final currentScroll = _spmScrollController.position.pixels;
      final maxScroll = _spmScrollController.position.maxScrollExtent;

      if (currentScroll == maxScroll &&
          context.read<DashboardCubit>().state.hasMoreSpm) {
        context.read<DashboardCubit>().fetchSpm(
          keyword: _spmKeyword,
          year: _selectedYear.value,
          month: _selectedMonth.value,
          districtCode: _selectedDistrictCode,
          subDistrictCode: _selectedSubDistrictCode,
          healthPostUuid: _selectedHealthPostUuid,
          spmFieldName: _selectedSpmField,
          statuses: _selectedStatus,
        );
      }
    }
  }

  void _onSearchSpm(String? keyword) {
    setState(() {
      _spmKeyword = keyword ?? '';
    });

    if (_spmDebounce?.isActive ?? false) _spmDebounce!.cancel();
    _spmDebounce = Timer(const Duration(milliseconds: 500), () {
      context.read<DashboardCubit>().refetchSpm(
        keyword: _spmKeyword,
        month: _selectedMonth.value,
        year: _selectedYear.value,
        districtCode: _selectedDistrictCode,
        subDistrictCode: _selectedSubDistrictCode,
        healthPostUuid: _selectedHealthPostUuid,
        spmFieldName: _selectedSpmField,
        statuses: _selectedStatus,
      );
    });
  }

  @override
  void dispose() {
    _spmScrollController
      ..removeListener(_onScrollSpm)
      ..dispose();
    _searchSpmController.dispose();
    _spmDebounce?.cancel();
    _selectedYear.dispose();
    _selectedMonth.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              previous.authStatus != current.authStatus,
          listener: (context, state) {
            if (state.authStatus == AuthStatus.authorized) {
              context
                  .read<DashboardCubit>()
                  .fetchSpm(
                    keyword: _spmKeyword,
                    year: _selectedYear.value,
                    month: _selectedMonth.value,
                    districtCode: _selectedDistrictCode,
                    subDistrictCode: _selectedSubDistrictCode,
                    healthPostUuid: _selectedHealthPostUuid,
                    spmFieldName: _selectedSpmField,
                    statuses: _selectedStatus,
                  )
                  .then((value) {
                    _spmScrollController.addListener(_onScrollSpm);
                  });
            }
          },
        ),
        BlocListener<DashboardCubit, DashboardState>(
          listenWhen: (previous, current) {
            return (previous.selectedSpmStatus != current.selectedSpmStatus &&
                    current.selectedSpmStatus != null) ||
                (previous.selectedSpmField != current.selectedSpmField &&
                    current.selectedSpmField != null);
          },
          listener: (context, state) {
            setState(() {
              if (state.selectedSpmStatus != null) {
                _selectedStatus.add(state.selectedSpmStatus ?? '');
              }
              if (state.selectedSpmField != null) {
                _selectedSpmField = state.selectedSpmField;
              }
            });
            if (state.selectedSpmStatus != null) {
              context.read<DashboardCubit>().clearSelectedSpmStatus();
            }
            if (state.selectedSpmField != null) {
              context.read<DashboardCubit>().clearSelectedSpmField();
            }
            context.read<DashboardCubit>().refetchSpm(
              keyword: _spmKeyword,
              year: _selectedYear.value,
              month: _selectedMonth.value,
              districtCode: _selectedDistrictCode,
              subDistrictCode: _selectedSubDistrictCode,
              healthPostUuid: _selectedHealthPostUuid,
              spmFieldName: _selectedSpmField,
              statuses: _selectedStatus,
            );
          },
        ),
      ],
      child: Column(
        children: [
          SpmHeader(
            searchSpmController: _searchSpmController,
            onSearchSpm: _onSearchSpm,
            spmKeyword: _spmKeyword,
            selectedDistrictCode: _selectedDistrictCode,
            selectedSubDistrictCode: _selectedSubDistrictCode,
            selectedHealthPostUuid: _selectedHealthPostUuid,
            selectedSpmField: _selectedSpmField,
            selectedStatus: _selectedStatus,
            onAppliedFilter: (value) {
              final selectedDistrictCode =
                  value['selectedDistrictCode'] as String?;
              final selectedSubDistrictCode =
                  value['selectedSubDistrictCode'] as String?;
              final selectedHealthPostUuid =
                  value['selectedHealthPostUuid'] as String?;
              final selectedSpmField = value['selectedSpmField'] as String?;
              final selectedStatus = value['selectedStatus'] as Set<String>?;

              setState(() {
                _selectedDistrictCode = selectedDistrictCode;
                _selectedSubDistrictCode = selectedSubDistrictCode;
                _selectedHealthPostUuid = selectedHealthPostUuid;
                _selectedSpmField = selectedSpmField;
                _selectedStatus
                  ..removeWhere((element) {
                    return !(selectedStatus?.contains(element) ?? false);
                  })
                  ..addAll(selectedStatus ?? {});
              });

              context.read<DashboardCubit>().refetchSpm(
                keyword: _spmKeyword,
                month: _selectedMonth.value,
                year: _selectedYear.value,
                districtCode: _selectedDistrictCode,
                subDistrictCode: _selectedSubDistrictCode,
                healthPostUuid: _selectedHealthPostUuid,
                spmFieldName: _selectedSpmField,
                statuses: _selectedStatus,
              );
            },
            months: _months,
            selectedMonth: _selectedMonth,
            onSelectedMonth: (value) {
              _selectedMonth.value = value;
              setState(() {});

              context.read<DashboardCubit>().refetchSpm(
                keyword: _spmKeyword,
                month: _selectedMonth.value,
                year: _selectedYear.value,
                districtCode: _selectedDistrictCode,
                subDistrictCode: _selectedSubDistrictCode,
                healthPostUuid: _selectedHealthPostUuid,
                spmFieldName: _selectedSpmField,
                statuses: _selectedStatus,
              );
            },
            onRemoveMonth: () {
              _selectedMonth.value = null;
              setState(() {});

              context.read<DashboardCubit>().refetchSpm(
                keyword: _spmKeyword,
                month: _selectedMonth.value,
                year: _selectedYear.value,
                districtCode: _selectedDistrictCode,
                subDistrictCode: _selectedSubDistrictCode,
                healthPostUuid: _selectedHealthPostUuid,
                spmFieldName: _selectedSpmField,
                statuses: _selectedStatus,
              );
            },
            years: _years,
            selectedYear: _selectedYear,
            onSelectedYear: (value) {
              _selectedYear.value = value as int;

              context.read<DashboardCubit>().refetchSpm(
                keyword: _spmKeyword,
                month: _selectedMonth.value,
                year: _selectedYear.value,
                districtCode: _selectedDistrictCode,
                subDistrictCode: _selectedSubDistrictCode,
                healthPostUuid: _selectedHealthPostUuid,
                spmFieldName: _selectedSpmField,
                statuses: _selectedStatus,
              );
            },
          ),
          Expanded(
            child: BlocBuilder<DashboardCubit, DashboardState>(
              builder: (context, state) {
                switch (state.spmStatus) {
                  case SpmStatus.error:
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: BaseHandleState(
                        handleType: HandleType.error,
                        errorMessage: state.spmError ?? '',
                        onRefetch: () {
                          context.read<DashboardCubit>().refetchSpm(
                            keyword: _spmKeyword,
                            month: _selectedMonth.value,
                            year: _selectedYear.value,
                            districtCode: _selectedDistrictCode,
                            subDistrictCode: _selectedSubDistrictCode,
                            healthPostUuid: _selectedHealthPostUuid,
                            spmFieldName: _selectedSpmField,
                            statuses: _selectedStatus,
                          );
                        },
                      ),
                    );
                  case SpmStatus.success:
                    return state.spm.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(16),
                            child: BaseHandleState(
                              handleType: HandleType.empty,
                              errorMessage: 'Data SPM Kosong',
                              onRefetch: () {
                                context.read<DashboardCubit>().refetchSpm(
                                  keyword: _spmKeyword,
                                  month: _selectedMonth.value,
                                  year: _selectedYear.value,
                                  districtCode: _selectedDistrictCode,
                                  subDistrictCode: _selectedSubDistrictCode,
                                  healthPostUuid: _selectedHealthPostUuid,
                                  spmFieldName: _selectedSpmField,
                                  statuses: _selectedStatus,
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
                                  if (context.mounted) {
                                    context.read<DashboardCubit>().refetchSpm(
                                      keyword: _spmKeyword,
                                      month: _selectedMonth.value,
                                      year: _selectedYear.value,
                                      districtCode: _selectedDistrictCode,
                                      subDistrictCode: _selectedSubDistrictCode,
                                      healthPostUuid: _selectedHealthPostUuid,
                                      spmFieldName: _selectedSpmField,
                                      statuses: _selectedStatus,
                                    );
                                  }
                                },
                              );
                            },
                            child: ListView.builder(
                              controller: _spmScrollController,
                              padding: const EdgeInsets.all(16),
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: state.hasMoreSpm
                                  ? state.spm.length + 1
                                  : state.spm.length,
                              itemBuilder: (context, index) {
                                return index >= state.spm.length
                                    ? const BaseLoadScroll()
                                    : SpmCard(
                                        receiptNumber:
                                            state.spm[index].receiptNumber ??
                                            '',
                                        reportedAt:
                                            state.spm[index].date ??
                                            DateTime(0000),
                                        fieldName:
                                            state.spm[index].spmField?.name ??
                                            '',
                                        healthPostName:
                                            state.spm[index].healthPost?.name ??
                                            '',
                                        subDistrictName:
                                            state
                                                .spm[index]
                                                .subDistrict
                                                ?.name ??
                                            '',
                                        districtName:
                                            state.spm[index].district?.name ??
                                            '',
                                        status: state.spm[index].status ?? '',
                                        index: index,
                                        dataLength: state.spm.length,
                                        onTap: () async {
                                          final result =
                                              await Navigator.pushNamed(
                                                context,
                                                DetailSpmPage.routeName,
                                                arguments:
                                                    state.spm[index].uuid,
                                              );

                                          if (result != null) {
                                            if (result == 'spm-deleted') {
                                              if (context.mounted) {
                                                context
                                                    .read<DashboardCubit>()
                                                    .refetchSpm(
                                                      keyword: _spmKeyword,
                                                      month:
                                                          _selectedMonth.value,
                                                      year: _selectedYear.value,
                                                      districtCode:
                                                          _selectedDistrictCode,
                                                      subDistrictCode:
                                                          _selectedSubDistrictCode,
                                                      healthPostUuid:
                                                          _selectedHealthPostUuid,
                                                      spmFieldName:
                                                          _selectedSpmField,
                                                      statuses: _selectedStatus,
                                                    );
                                              }
                                            }
                                          }
                                        },
                                      );
                              },
                            ),
                          );
                  default:
                    return const SpmCardLoading();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
