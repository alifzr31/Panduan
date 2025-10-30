import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/cubits/dashboard/dashboard_cubit.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/utils/string_extension.dart';
import 'package:panduan/app/views/dashboard/components/spmfieldcount_card.dart';
import 'package:panduan/app/views/dashboard/components/spmfieldcountcard_loading.dart';
import 'package:panduan/app/widgets/base_handlestate.dart';

class RecapitulationSection extends StatelessWidget {
  const RecapitulationSection({required this.selectedRangeDates, super.key});

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
                      'Rekapitulasi SPM',
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
                          ? 'Data SPM berdasarkan bidang di Kota Bandung'
                          : AppHelpers.hasPermission(
                              context.read<AuthCubit>().state.userPermissions,
                              permissionName: 'level-opd',
                            )
                          ? 'Data SPM berdasarkan bidang di ${context.read<AuthCubit>().state.profile?.opd?.name}'
                          : AppHelpers.hasPermission(
                              context.read<AuthCubit>().state.userPermissions,
                              permissionName: 'level-kecamatan',
                            )
                          ? 'Data SPM berdasarkan bidang di Kecamatan ${context.read<AuthCubit>().state.profile?.district?.name?.capitalize()}'
                          : AppHelpers.hasPermission(
                              context.read<AuthCubit>().state.userPermissions,
                              permissionName: 'level-kelurahan',
                            )
                          ? 'Data SPM berdasarkan bidang di Kelurahan ${context.read<AuthCubit>().state.profile?.subDistrict?.name?.capitalize()}'
                          : 'Data SPM berdasarkan bidang di Posyandu ${context.read<AuthCubit>().state.profile?.healthPost?.name?.capitalize()}',
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
                  switch (state.spmFieldCountStatus) {
                    case SpmFieldCountStatus.error:
                      return SizedBox(
                        height: 340,
                        child: BaseHandleState(
                          handleType: HandleType.error,
                          errorMessage: state.spmFieldCountError ?? '',
                          onRefetch: () {
                            context.read<DashboardCubit>().refetchSpmFieldCount(
                              startDate: selectedRangeDates.first,
                              endDate: selectedRangeDates.last,
                            );
                          },
                        ),
                      );
                    case SpmFieldCountStatus.success:
                      return Column(
                        children: [
                          SpmFieldCountCard(
                            title: 'Total SPM',
                            count: state.spmFieldCount?.total ?? 0,
                          ),
                          const SizedBox(height: 8),
                          SpmFieldCountCard(
                            title: 'Pendidikan',
                            count: state.spmFieldCount?.pendidikan ?? 0,
                          ),
                          const SizedBox(height: 4),
                          SpmFieldCountCard(
                            title: 'Kesehatan',
                            count: state.spmFieldCount?.kesehatan ?? 0,
                          ),
                          const SizedBox(height: 4),
                          SpmFieldCountCard(
                            title: 'Pekerjaan Umum',
                            count: state.spmFieldCount?.pekerjaanUmum ?? 0,
                          ),
                          const SizedBox(height: 4),
                          SpmFieldCountCard(
                            title: 'Perumahan Rakyat',
                            count: state.spmFieldCount?.perumahanRakyat ?? 0,
                          ),
                          const SizedBox(height: 4),
                          SpmFieldCountCard(
                            title: 'Trantibum Linmas',
                            count: state.spmFieldCount?.trantibumLinmas ?? 0,
                          ),
                          const SizedBox(height: 4),
                          SpmFieldCountCard(
                            title: 'Sosial',
                            count: state.spmFieldCount?.sosial ?? 0,
                          ),
                        ],
                      );
                    default:
                      return spmFieldCountCardLoading();
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
