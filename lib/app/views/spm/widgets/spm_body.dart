import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panduan/app/cubits/spm/spm_cubit.dart';
import 'package:panduan/app/views/detail_spm/detailspm_page.dart';
import 'package:panduan/app/views/spm/components/spm_card.dart';
import 'package:panduan/app/views/spm/components/spmcard_loading.dart';
import 'package:panduan/app/widgets/base_handlestate.dart';
import 'package:panduan/app/widgets/base_loadscroll.dart';

class SpmBody extends StatelessWidget {
  const SpmBody({
    required this.selectedYear,
    required this.selectedMonth,
    required this.spmKeyword,
    required this.spmStatuses,
    required this.spmScrollController,
    required this.onRefreshSpm,
    super.key,
  });

  final int? selectedYear;
  final int? selectedMonth;
  final String? spmKeyword;
  final Set<String>? spmStatuses;
  final ScrollController spmScrollController;
  final void Function() onRefreshSpm;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<SpmCubit, SpmState>(
        builder: (context, state) {
          switch (state.spmStatus) {
            case SpmStatus.error:
              return BaseHandleState(
                handleType: HandleType.error,
                errorMessage: state.spmError ?? '',
                onRefetch: () {
                  context.read<SpmCubit>().refetchSpm(
                    year: selectedYear,
                    month: selectedMonth,
                    keyword: spmKeyword,
                    statuses: spmStatuses,
                  );
                },
              );
            case SpmStatus.success:
              return state.spm.isEmpty
                  ? BaseHandleState(
                      handleType: HandleType.empty,
                      errorMessage: 'Data SPM Kosong',
                      onRefetch: () {
                        context.read<SpmCubit>().refetchSpm(
                          year: selectedYear,
                          month: selectedMonth,
                          keyword: spmKeyword,
                          statuses: spmStatuses,
                        );
                      },
                    )
                  : RefreshIndicator(
                      backgroundColor: Colors.white,
                      onRefresh: () async {
                        await Future.delayed(
                          const Duration(milliseconds: 2500),
                          onRefreshSpm,
                        );
                      },
                      child: ListView.builder(
                        controller: spmScrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        itemCount: state.hasMoreSpm
                            ? state.spm.length + 1
                            : state.spm.length,
                        itemBuilder: (context, index) {
                          return SafeArea(
                            top: false,
                            bottom: state.hasMoreSpm
                                ? index == state.spm.length
                                      ? true
                                      : false
                                : index == state.spm.length - 1
                                ? true
                                : false,
                            child: index >= state.spm.length
                                ? const BaseLoadScroll()
                                : SpmCard(
                                    receiptNumber:
                                        state.spm[index].receiptNumber ?? '',
                                    reportedAt:
                                        state.spm[index].date ?? DateTime(0000),
                                    fieldName:
                                        state.spm[index].spmField?.name ?? '',
                                    healthPostName:
                                        state.spm[index].healthPost?.name ?? '',
                                    subDistrictName:
                                        state.spm[index].subDistrict?.name ??
                                        '',
                                    districtName:
                                        state.spm[index].district?.name ?? '',
                                    status: state.spm[index].status ?? '',
                                    index: index,
                                    dataLength: state.spm.length,
                                    onTap: () async {
                                      final result = await Navigator.pushNamed(
                                        context,
                                        DetailSpmPage.routeName,
                                        arguments: state.spm[index].uuid,
                                      );

                                      if (result != null) {
                                        if (result == 'spm-deleted') {
                                          if (context.mounted) {
                                            context.read<SpmCubit>().refetchSpm(
                                              year: selectedYear,
                                              month: selectedMonth,
                                              keyword: spmKeyword,
                                              statuses: spmStatuses,
                                            );
                                          }
                                        }
                                      }
                                    },
                                  ),
                          );
                        },
                      ),
                    );
            default:
              return const SpmCardLoading();
          }
        },
      ),
    );
  }
}
