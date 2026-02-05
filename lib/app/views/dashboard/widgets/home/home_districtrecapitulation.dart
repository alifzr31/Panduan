import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panduan/app/cubits/dashboard/dashboard_cubit.dart';
import 'package:panduan/app/views/dashboard/components/home/spmdistrictcount_card.dart';
import 'package:panduan/app/views/dashboard/components/home/spmhpcountcard_loading.dart';
import 'package:panduan/app/widgets/base_handlestate.dart';

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
                      'Daftar Kecamatan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Data SPM tingkat kecamatan di Kota Bandung',
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
                          : ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.spmDistrictCounts.length,
                              itemBuilder: (context, index) {
                                final spmDistrictCount =
                                    state.spmDistrictCounts[index];

                                return SpmDistrictCountCard(
                                  districtName: spmDistrictCount.district ?? '',
                                  total: spmDistrictCount.total ?? 0,
                                  index: index,
                                  dataLength: state.spmDistrictCounts.length,
                                );
                              },
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
