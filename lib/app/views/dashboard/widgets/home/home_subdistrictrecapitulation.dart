import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/cubits/dashboard/dashboard_cubit.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/utils/string_extension.dart';
import 'package:panduan/app/views/dashboard/components/home/spmhpcountcard_loading.dart';
import 'package:panduan/app/views/dashboard/components/home/spmsubdistrictcount_card.dart';
import 'package:panduan/app/widgets/base_handlestate.dart';

class HomeSubDistrictRecapitulation extends StatelessWidget {
  const HomeSubDistrictRecapitulation({
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
                      'Daftar Kelurahan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      AppHelpers.hasPermission(
                            context.read<AuthCubit>().state.userPermissions,
                            permissionName: 'level-walikota',
                          )
                          ? 'Data SPM tingkat kelurahan di Kota Bandung'
                          : 'Data SPM tingkat kelurahan di Kecamatan ${context.read<AuthCubit>().state.profile?.district?.name?.capitalize()}',
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
                  switch (state.spmSubDistrictCountStatus) {
                    case SpmSubDistrictCountStatus.error:
                      return SizedBox(
                        height: 300,
                        child: BaseHandleState(
                          handleType: HandleType.error,
                          errorMessage: state.spmSubDistrictCountError ?? '',
                          onRefetch: () {
                            context
                                .read<DashboardCubit>()
                                .refetchSpmSubDistrictCount(
                                  startDate: selectedRangeDates.first,
                                  endDate: selectedRangeDates.last,
                                );
                          },
                        ),
                      );
                    case SpmSubDistrictCountStatus.success:
                      return state.spmSubDistrictCounts.isEmpty
                          ? SizedBox(
                              height: 300,
                              child: BaseHandleState(
                                handleType: HandleType.empty,
                                errorMessage: 'Data Kelurahan Kosong',
                                onRefetch: () {
                                  context
                                      .read<DashboardCubit>()
                                      .refetchSpmSubDistrictCount(
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
                              itemCount: state.spmSubDistrictCounts.length,
                              itemBuilder: (context, index) {
                                final spmSubDistrictCount =
                                    state.spmSubDistrictCounts[index];

                                return SpmSubDistrictCountCard(
                                  subDistrictName:
                                      spmSubDistrictCount.subDistrict ?? '',
                                  total: spmSubDistrictCount.total ?? 0,
                                  index: index,
                                  dataLength: state.spmSubDistrictCounts.length,
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
