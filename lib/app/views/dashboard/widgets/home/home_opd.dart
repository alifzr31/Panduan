import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panduan/app/cubits/dashboard/dashboard_cubit.dart';
import 'package:panduan/app/views/dashboard/components/home/alert_spm_card.dart';
import 'package:panduan/app/views/dashboard/widgets/home/home_spmfieldrecapitulation.dart';
import 'package:panduan/app/views/dashboard/widgets/home/home_spmcounter.dart';

class HomeOpd extends StatelessWidget {
  const HomeOpd({
    required this.selectedRangeDates,
    required this.onSeeAllSpmNeedVerify,
    super.key,
  });

  final List<DateTime> selectedRangeDates;
  final void Function()? onSeeAllSpmNeedVerify;

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
          AlertSpmCard(onSeeAllSpmNeedVerify: onSeeAllSpmNeedVerify),
          const SizedBox(height: 16),
        },
        const HomeSpmCounter(),
        const SizedBox(height: 16),
        HomeSpmFieldRecapitulation(selectedRangeDates: selectedRangeDates),
      ],
    );
  }
}
