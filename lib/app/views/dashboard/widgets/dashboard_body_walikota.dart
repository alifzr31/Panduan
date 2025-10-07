import 'package:flutter/material.dart';
import 'package:panduan/app/views/dashboard/widgets/daterangepicker_section.dart';
import 'package:panduan/app/views/dashboard/widgets/district_section.dart';
import 'package:panduan/app/views/dashboard/widgets/latest_spm_section.dart';
import 'package:panduan/app/views/dashboard/widgets/spm_field_counter_section.dart';
import 'package:panduan/app/views/dashboard/widgets/subdistrict_section.dart';

class DashboardBodyWalikota extends StatelessWidget {
  const DashboardBodyWalikota({
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
        const SizedBox(height: 16),
        const SpmFieldCounterSection(),
        const SizedBox(height: 16),
        const LatestSpmSection(),
        const SizedBox(height: 16),
        DistrictSection(selectedRangeDates: selectedRangeDates),
        const SizedBox(height: 16),
        SafeArea(
          top: false,
          child: SubDistrictSection(selectedRangeDates: selectedRangeDates),
        ),
      ],
    );
  }
}
