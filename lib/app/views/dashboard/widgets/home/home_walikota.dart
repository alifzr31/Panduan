import 'package:flutter/material.dart';
import 'package:panduan/app/views/dashboard/widgets/home/home_districtrecapitulation.dart';
import 'package:panduan/app/views/dashboard/widgets/home/home_spmfieldcounter.dart';
import 'package:panduan/app/views/dashboard/widgets/home/home_subdistrictrecapitulation.dart';

class HomeWalikota extends StatelessWidget {
  const HomeWalikota({
    required this.selectedRangeDates,
    required this.onTapSpmFieldCounter,
    super.key,
  });

  final List<DateTime> selectedRangeDates;
  final void Function(String value) onTapSpmFieldCounter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeSpmFieldCounter(onTapSpmFieldCounter: onTapSpmFieldCounter),
        const SizedBox(height: 16),
        HomeDistrictRecapitulation(selectedRangeDates: selectedRangeDates),
        const SizedBox(height: 16),
        HomeSubDistrictRecapitulation(selectedRangeDates: selectedRangeDates),
      ],
    );
  }
}
