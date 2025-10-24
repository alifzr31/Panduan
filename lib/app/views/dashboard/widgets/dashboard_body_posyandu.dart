import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/views/dashboard/components/action_card.dart';
import 'package:panduan/app/views/dashboard/widgets/recapitulation_section.dart';
import 'package:panduan/app/views/spm/spm_page.dart';
import 'package:panduan/app/views/spm_field/spmfield_page.dart';

class DashboardBodyPosyandu extends StatelessWidget {
  const DashboardBodyPosyandu({required this.selectedRangeDates, super.key});

  final List<DateTime> selectedRangeDates;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(
              child: ActionCard(
                icon: MingCute.add_circle_line,
                title: 'Input SPM',
                description: 'Buat pengajuan SPM\nbaru',
                routeName: SpmFieldPage.routeName,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ActionCard(
                icon: MingCute.eye_2_fill,
                title: 'Lihat SPM',
                description: 'Daftar SPM yang telah\ndiinput',
                routeName: SpmPage.routeName,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SafeArea(
          top: false,
          child: RecapitulationSection(selectedRangeDates: selectedRangeDates),
        ),
      ],
    );
  }
}
