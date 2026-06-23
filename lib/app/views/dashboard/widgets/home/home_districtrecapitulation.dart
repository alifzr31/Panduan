import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panduan/app/cubits/dashboard/dashboard_cubit.dart';
import 'package:panduan/app/views/dashboard/components/home/spmdistrictcount_card.dart';
import 'package:panduan/app/views/dashboard/components/home/spmhpcountcard_loading.dart';
import 'package:panduan/app/views/recapitulation/recapitulation_page.dart';
import 'package:panduan/app/widgets/base_handlestate.dart';
import 'package:panduan/app/widgets/base_textbutton.dart';

class HomeDistrictRecapitulation extends StatelessWidget {
  const HomeDistrictRecapitulation({
    required this.selectedRangeDates,
    super.key,
  });

  final List<DateTime> selectedRangeDates;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.white,
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rekapitulasi SPM Kecamatan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Rekapitulasi SPM tingkat kecamatan di Kota Bandung.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(height: 1, color: Colors.grey.shade300),
              ),
              BlocBuilder<DashboardCubit, DashboardState>(
                builder: (context, state) {
                  switch (state.spmDistrictCountStatus) {
                    case SpmDistrictCountStatus.error:
                      return SizedBox(
                        height: 300,
                        child: BaseHandleState(
                          handleType: HandleType.error,
                          errorMessage: state.spmDistrictCountError ?? '',
                          onRefetch: () {
                            context
                                .read<DashboardCubit>()
                                .refetchSpmDistrictCount(
                                  startDate: selectedRangeDates.first,
                                  endDate: selectedRangeDates.last,
                                );
                          },
                        ),
                      );
                    case SpmDistrictCountStatus.success:
                      return state.spmDistrictCounts.isEmpty
                          ? SizedBox(
                              height: 300,
                              child: BaseHandleState(
                                handleType: HandleType.empty,
                                errorMessage: 'Data Kecamatan Kosong',
                                onRefetch: () {
                                  context
                                      .read<DashboardCubit>()
                                      .refetchSpmDistrictCount(
                                        startDate: selectedRangeDates.first,
                                        endDate: selectedRangeDates.last,
                                      );
                                },
                              ),
                            )
                          : Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: state.spmDistrictCounts
                                      .take(5)
                                      .length,
                                  itemBuilder: (context, index) {
                                    final spmDistrictCount = state
                                        .spmDistrictCounts
                                        .take(5)
                                        .toList()[index];

                                    return SpmDistrictCountCard(
                                      districtName:
                                          spmDistrictCount.district ?? '',
                                      total: spmDistrictCount.total ?? 0,
                                      educationCount:
                                          spmDistrictCount.pendidikan ?? 0,
                                      healthCount:
                                          spmDistrictCount.kesehatan ?? 0,
                                      puCount:
                                          spmDistrictCount.pekerjaanUmum ?? 0,
                                      prCount:
                                          spmDistrictCount.perumahanRakyat ?? 0,
                                      socialCount: spmDistrictCount.sosial ?? 0,
                                      trantibumCount:
                                          spmDistrictCount.trantibumLinmas ?? 0,
                                      lainnya: spmDistrictCount.lainnya ?? 0,
                                      index: index,
                                      dataLength:
                                          state.spmDistrictCounts.length,
                                    );
                                  },
                                ),
                                if (state.spmDistrictCounts.length > 5) ...{
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    child: Divider(
                                      height: 1,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  BaseTextButton(
                                    text: 'Lihat Semua',
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        RecapitulationPage.routeName,
                                        arguments: {
                                          'recapitulationLevel': 'district',
                                          'recapitulationData':
                                              state.spmDistrictCounts,
                                        },
                                      );
                                    },
                                  ),
                                },
                              ],
                            );
                    default:
                      return const SpmHpCountCardLoading();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
