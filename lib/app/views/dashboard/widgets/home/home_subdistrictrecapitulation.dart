import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/cubits/dashboard/dashboard_cubit.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/utils/string_extension.dart';
import 'package:panduan/app/views/dashboard/components/home/spmhpcountcard_loading.dart';
import 'package:panduan/app/views/dashboard/components/home/spmsubdistrictcount_card.dart';
import 'package:panduan/app/views/recapitulation/recapitulation_page.dart';
import 'package:panduan/app/widgets/base_handlestate.dart';
import 'package:panduan/app/widgets/base_textbutton.dart';

class HomeSubDistrictRecapitulation extends StatelessWidget {
  const HomeSubDistrictRecapitulation({
    required this.selectedRangeDates,
    super.key,
  });

  final List<DateTime> selectedRangeDates;

  Widget _buildTitle(BuildContext context) {
    final isWalikota = AppHelpers.hasPermission(
      context.read<AuthCubit>().state.userPermissions,
      permissionName: 'level-walikota',
    );

    if (isWalikota) {
      return Text(
        'Rekapitulasi SPM tingkat kelurahan di Kota Bandung.',
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      );
    }

    return Text(
      'Rekapitulasi SPM tingkat kelurahan di Kecamatan ${context.read<AuthCubit>().state.profile?.district?.name?.capitalize()}.',
      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
    );
  }

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
                      'Rekapitulasi SPM Kelurahan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    BlocSelector<DashboardCubit, DashboardState, bool>(
                      selector: (state) {
                        return state.spmSubDistrictCountStatus ==
                            SpmSubDistrictCountStatus.success;
                      },
                      builder: (context, state) {
                        return _buildTitle(context);
                      },
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
                          : Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: state.spmSubDistrictCounts
                                      .take(5)
                                      .toList()
                                      .length,
                                  itemBuilder: (context, index) {
                                    final spmSubDistrictCount = state
                                        .spmSubDistrictCounts
                                        .take(5)
                                        .toList()[index];

                                    return SpmSubDistrictCountCard(
                                      subDistrictName:
                                          spmSubDistrictCount.subDistrict ?? '',
                                      total: spmSubDistrictCount.total ?? 0,
                                      educationCount:
                                          spmSubDistrictCount.pendidikan ?? 0,
                                      healthCount:
                                          spmSubDistrictCount.kesehatan ?? 0,
                                      puCount:
                                          spmSubDistrictCount.pekerjaanUmum ??
                                          0,
                                      prCount:
                                          spmSubDistrictCount.perumahanRakyat ??
                                          0,
                                      socialCount:
                                          spmSubDistrictCount.sosial ?? 0,
                                      trantibumCount:
                                          spmSubDistrictCount.trantibumLinmas ??
                                          0,
                                      lainnya: spmSubDistrictCount.lainnya ?? 0,
                                      index: index,
                                      dataLength:
                                          state.spmSubDistrictCounts.length,
                                    );
                                  },
                                ),
                                if (state.spmSubDistrictCounts.length > 5) ...{
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
                                          'recapitulationLevel': 'subdistrict',
                                          'recapitulationData':
                                              state.spmSubDistrictCounts,
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
