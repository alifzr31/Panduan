import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panduan/app/cubits/dashboard/dashboard_cubit.dart';
import 'package:panduan/app/views/dashboard/components/alert_spm_card.dart';
import 'package:panduan/app/views/dashboard/widgets/daterangepicker_section.dart';
import 'package:panduan/app/views/dashboard/widgets/healthpost_section.dart';
import 'package:panduan/app/views/dashboard/widgets/latest_spm_section.dart';
import 'package:panduan/app/views/dashboard/widgets/recapitulation_section.dart';
import 'package:panduan/app/views/dashboard/widgets/spm_counter_section.dart';

class DashboardBodyKelurahan extends StatelessWidget {
  const DashboardBodyKelurahan({
    required this.rangeDateController,
    required this.selectedRangeDates,
    required this.onSelectedRangeDate,
    super.key,
  });

  final TextEditingController rangeDateController;
  final List<DateTime> selectedRangeDates;
  final void Function(List<DateTime>) onSelectedRangeDate;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        DateRangePickerSection(
          rangeDateController: rangeDateController,
          selectedRangeDates: selectedRangeDates,
          onSelectedRangeDate: onSelectedRangeDate,
        ),
        if ((context
                    .watch<DashboardCubit>()
                    .state
                    .spmCount
                    ?.needVerificationSubDistrict ??
                0) >
            0) ...{
          const SizedBox(height: 16),
          const AlertSpmCard(),
        },
        const SizedBox(height: 16),
        const SpmCounterSection(),
        const SizedBox(height: 16),
        const LatestSpmSection(),
        const SizedBox(height: 16),
        RecapitulationSection(selectedRangeDates: selectedRangeDates),
        const SizedBox(height: 16),
        SafeArea(
          top: false,
          child: HealthPostSection(selectedRangeDates: selectedRangeDates),
        ),
      ],
    );
  }
}
