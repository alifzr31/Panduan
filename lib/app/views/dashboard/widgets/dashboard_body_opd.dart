import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panduan/app/cubits/dashboard/dashboard_cubit.dart';
import 'package:panduan/app/views/dashboard/components/alert_spm_card.dart';
import 'package:panduan/app/views/dashboard/widgets/latest_spm_section.dart';
import 'package:panduan/app/views/dashboard/widgets/recapitulation_section.dart';
import 'package:panduan/app/views/dashboard/widgets/spm_counter_section.dart';

class DashboardBodyOpd extends StatelessWidget {
  const DashboardBodyOpd({required this.selectedRangeDates, super.key});

  final List<DateTime> selectedRangeDates;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if ((context
                    .watch<DashboardCubit>()
                    .state
                    .spmCount
                    ?.needVerificationOpd ??
                0) >
            0) ...{
          const AlertSpmCard(),
          const SizedBox(height: 16),
        },
        const SpmCounterSection(),
        const SizedBox(height: 16),
        const LatestSpmSection(),
        const SizedBox(height: 16),
        SafeArea(
          top: false,
          child: RecapitulationSection(selectedRangeDates: selectedRangeDates),
        ),
      ],
    );
  }
}
