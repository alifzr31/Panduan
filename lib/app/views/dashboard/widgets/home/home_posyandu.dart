import 'package:flutter/material.dart';
import 'package:panduan/app/views/dashboard/widgets/home/home_spmfieldrecapitulation.dart';

class HomePosyandu extends StatelessWidget {
  const HomePosyandu({required this.selectedRangeDates, super.key});

  final List<DateTime> selectedRangeDates;

  @override
  Widget build(BuildContext context) {
    return HomeSpmFieldRecapitulation(selectedRangeDates: selectedRangeDates);
  }
}
