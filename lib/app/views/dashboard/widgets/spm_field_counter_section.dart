import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panduan/app/cubits/dashboard/dashboard_cubit.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/views/dashboard/components/spm_field_counter_card.dart';
import 'package:panduan/app/views/dashboard/components/spm_field_counter_card_loading.dart';

class SpmFieldCounterSection extends StatelessWidget {
  const SpmFieldCounterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        switch (state.spmFieldCountStatus) {
          case SpmFieldCountStatus.success:
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SpmFieldCounterCard(
                        count: state.spmFieldCount?.pendidikan ?? 0,
                        name: 'Pendidikan',
                        barColor: AppColors.amberColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SpmFieldCounterCard(
                        count: state.spmFieldCount?.kesehatan ?? 0,
                        name: 'Kesehatan',
                        barColor: AppColors.pinkColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: SpmFieldCounterCard(
                        count: state.spmFieldCount?.pekerjaanUmum ?? 0,
                        name: 'Pekerjaan Umum',
                        barColor: AppColors.blueColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SpmFieldCounterCard(
                        count: state.spmFieldCount?.perumahanRakyat ?? 0,
                        name: 'Perumahan Rakyat',
                        barColor: AppColors.greenColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: SpmFieldCounterCard(
                        count: state.spmFieldCount?.sosial ?? 0,
                        name: 'Sosial',
                        barColor: AppColors.purpleColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SpmFieldCounterCard(
                        count: state.spmFieldCount?.trantibumLinmas ?? 0,
                        name: 'Trantibum Linmas',
                        barColor: AppColors.trantibumLinmasColor,
                      ),
                    ),
                  ],
                ),
              ],
            );
          default:
            return const SpmFieldCounterCardLoading();
        }
      },
    );
  }
}
