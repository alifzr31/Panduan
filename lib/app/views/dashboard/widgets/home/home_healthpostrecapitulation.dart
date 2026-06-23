import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/cubits/dashboard/dashboard_cubit.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/utils/string_extension.dart';
import 'package:panduan/app/views/dashboard/components/home/spmhpcount_card.dart';
import 'package:panduan/app/views/dashboard/components/home/spmhpcountcard_loading.dart';
import 'package:panduan/app/views/recapitulation/recapitulation_page.dart';
import 'package:panduan/app/widgets/base_handlestate.dart';
import 'package:panduan/app/widgets/base_textbutton.dart';

class HomeHealthPostRecapitulation extends StatelessWidget {
  const HomeHealthPostRecapitulation({
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
        'Rekapitulasi SPM tingkat posyandu di Kota Bandung.',
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      );
    }

    return Text(
      'Rekapitulasi SPM tingkat posyandu di Kelurahan ${context.read<AuthCubit>().state.profile?.subDistrict?.name?.capitalize()}.',
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
                      'Rekapitulasi SPM Posyandu',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    BlocSelector<DashboardCubit, DashboardState, bool>(
                      selector: (state) {
                        return state.spmHpCountStatus ==
                            SpmHpCountStatus.success;
                      },
                      builder: (context, state) {
                        return _buildTitle(context);
                      },
                    ),
                    // Text(
                    //   AppHelpers.hasPermission(
                    //         context.read<AuthCubit>().state.userPermissions,
                    //         permissionName: 'level-walikota',
                    //       )
                    //       ? '5 Posyandu di Kota Bandung dengan jumlah SPM terbanyak'
                    //       : '5 Posyandu di Kelurahan ${context.read<AuthCubit>().state.profile?.subDistrict?.name?.capitalize()} dengan jumlah SPM terbanyak',
                    //   style: TextStyle(
                    //     fontSize: 12,
                    //     color: Colors.grey.shade600,
                    //   ),
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(height: 1, color: Colors.grey.shade300),
              ),
              BlocBuilder<DashboardCubit, DashboardState>(
                builder: (context, state) {
                  switch (state.spmHpCountStatus) {
                    case SpmHpCountStatus.error:
                      return SizedBox(
                        height: 300,
                        child: BaseHandleState(
                          handleType: HandleType.error,
                          errorMessage: state.spmHpCountError ?? '',
                          onRefetch: () {
                            context.read<DashboardCubit>().refetchSpmHpCount(
                              startDate: selectedRangeDates.first,
                              endDate: selectedRangeDates.last,
                            );
                          },
                        ),
                      );
                    case SpmHpCountStatus.success:
                      return state.spmHpCounts.isEmpty
                          ? SizedBox(
                              height: 300,
                              child: BaseHandleState(
                                handleType: HandleType.empty,
                                errorMessage: 'Data Posyandu Kosong',
                                onRefetch: () {
                                  context
                                      .read<DashboardCubit>()
                                      .refetchSpmHpCount(
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
                                  itemCount: state.spmHpCounts
                                      .take(5)
                                      .toList()
                                      .length,
                                  itemBuilder: (context, index) {
                                    final spmHpCount = state.spmHpCounts
                                        .take(5)
                                        .toList()[index];

                                    return SpmHpCountCard(
                                      healthPostName:
                                          spmHpCount.healthPost ?? '',
                                      total: spmHpCount.total ?? 0,
                                      educationCount:
                                          spmHpCount.pendidikan ?? 0,
                                      healthCount: spmHpCount.kesehatan ?? 0,
                                      puCount: spmHpCount.pekerjaanUmum ?? 0,
                                      prCount: spmHpCount.perumahanRakyat ?? 0,
                                      socialCount: spmHpCount.sosial ?? 0,
                                      trantibumCount:
                                          spmHpCount.trantibumLinmas ?? 0,
                                      lainnya: spmHpCount.lainnya ?? 0,
                                      index: index,
                                      dataLength: state.spmHpCounts.length,
                                    );
                                  },
                                ),
                                if (state.spmHpCounts.length > 5) ...{
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
                                          'recapitulationLevel': 'healthpost',
                                          'recapitulationData':
                                              state.spmHpCounts,
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
