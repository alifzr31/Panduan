import 'package:flutter/material.dart';
import 'package:panduan/app/views/dashboard/widgets/district_section.dart';
import 'package:panduan/app/views/dashboard/widgets/latest_spm_section.dart';
import 'package:panduan/app/views/dashboard/widgets/spm_field_counter_section.dart';
import 'package:panduan/app/views/dashboard/widgets/subdistrict_section.dart';

class DashboardBodyWalikota extends StatelessWidget {
  const DashboardBodyWalikota({required this.selectedRangeDates, super.key});

  final List<DateTime> selectedRangeDates;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
