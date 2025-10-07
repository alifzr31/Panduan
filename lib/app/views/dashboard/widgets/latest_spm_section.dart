import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panduan/app/cubits/dashboard/dashboard_cubit.dart';
import 'package:panduan/app/views/dashboard/components/spmcard_dashboard.dart';
import 'package:panduan/app/views/dashboard/components/spmcard_dashboardloading.dart';
import 'package:panduan/app/views/detail_spm/detailspm_page.dart';
import 'package:panduan/app/views/spm/spm_page.dart';
import 'package:panduan/app/widgets/base_handlestate.dart';
import 'package:panduan/app/widgets/base_textbutton.dart';

class LatestSpmSection extends StatelessWidget {
  const LatestSpmSection({super.key});

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
                      'SPM Terkini',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Data SPM terkini',
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
                  switch (state.spmStatus) {
                    case SpmStatus.error:
                      return SizedBox(
                        height: 380,
                        child: BaseHandleState(
                          handleType: HandleType.error,
                          errorMessage: state.spmError ?? '',
                          onRefetch: () {
                            context.read<DashboardCubit>().refetchSpm();
                          },
                        ),
                      );
                    case SpmStatus.success:
                      return state.spm.isEmpty
                          ? SizedBox(
                              height: 380,
                              child: BaseHandleState(
                                handleType: HandleType.empty,
                                errorMessage: 'Data SPM Kosong',
                                onRefetch: () {
                                  context.read<DashboardCubit>().refetchSpm();
                                },
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.spm.length,
                              itemBuilder: (context, index) {
                                final spm = state.spm[index];

                                return SpmCardDashbaord(
                                  receiptNumber: spm.receiptNumber ?? '',
                                  reportedAt: spm.date ?? DateTime(0000),
                                  fieldName: spm.spmField?.name ?? '',
                                  healthPostName: spm.healthPost?.name ?? '',
                                  subDistrictName: spm.subDistrict?.name ?? '',
                                  districtName: spm.district?.name ?? '',
                                  status: spm.status ?? '',
                                  index: index,
                                  dataLength: state.spm.length,
                                  onTap: () async {
                                    final result = await Navigator.pushNamed(
                                      context,
                                      DetailSpmPage.routeName,
                                      arguments: spm.uuid,
                                    );

                                    if (result != null) {
                                      if (result == 'spm-deleted') {
                                        if (context.mounted) {
                                          context
                                              .read<DashboardCubit>()
                                              .refetchSpm();
                                        }
                                      }
                                    }
                                  },
                                );
                              },
                            );
                    default:
                      return spmCardDashboardLoading();
                  }
                },
              ),
              if (context.watch<DashboardCubit>().state.spm.isNotEmpty) ...{
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1, color: Colors.grey.shade300),
                ),
                BaseTextButton(
                  text: 'Lihat Semua',
                  size: 12,
                  onPressed: () {
                    Navigator.pushNamed(context, SpmPage.routeName);
                  },
                ),
              },
            ],
          ),
        ),
      ),
    );
  }
}
