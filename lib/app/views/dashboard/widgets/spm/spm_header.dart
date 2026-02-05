import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/configs/get_it/service_locator.dart';
import 'package:panduan/app/cubits/health_post/health_post_cubit.dart';
import 'package:panduan/app/cubits/region/region_cubit.dart';
import 'package:panduan/app/cubits/spm/spm_cubit.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/views/dashboard/widgets/spm/spm_filterbottomsheet.dart';
import 'package:panduan/app/widgets/base_dropdownfield.dart';
import 'package:panduan/app/widgets/base_formfield.dart';
import 'package:panduan/app/widgets/base_iconbutton.dart';
import 'package:panduan/app/widgets/show_custombottomsheet.dart';

class SpmHeader extends StatelessWidget {
  const SpmHeader({
    required this.searchSpmController,
    required this.onSearchSpm,
    required this.selectedDistrictCode,
    required this.selectedSubDistrictCode,
    required this.selectedHealthPostUuid,
    required this.selectedSpmField,
    required this.selectedStatus,
    required this.onAppliedFilter,
    required this.months,
    required this.selectedMonth,
    required this.onSelectedMonth,
    required this.onRemoveMonth,
    required this.years,
    required this.selectedYear,
    required this.onSelectedYear,
    super.key,
  });

  final TextEditingController searchSpmController;
  final void Function(String? value) onSearchSpm;
  final String? selectedDistrictCode;
  final String? selectedSubDistrictCode;
  final String? selectedHealthPostUuid;
  final String? selectedSpmField;
  final Set<String> selectedStatus;
  final void Function(Map<String, dynamic> value) onAppliedFilter;
  final List<String> months;
  final int? selectedMonth;
  final void Function(Object? value) onSelectedMonth;
  final void Function() onRemoveMonth;
  final List<int> years;
  final int selectedYear;
  final void Function(Object? value) onSelectedYear;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Data SPM',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: BaseFormField(
                      hint: 'Cari berdasarkan no. resi (Cth: SPM0123456789)',
                      controller: searchSpmController,
                      prefixIcon: const Icon(MingCute.search_3_line, size: 18),
                      onChanged: onSearchSpm,
                    ),
                  ),
                  const SizedBox(width: 10),
                  CupertinoButton(
                    alignment: Alignment.center,
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      final result = await showDynamicHeightBottomSheet(
                        context,
                        child: MultiBlocProvider(
                          providers: [
                            BlocProvider(create: (context) => sl<SpmCubit>()),
                            BlocProvider(
                              create: (context) => sl<RegionCubit>(),
                            ),
                            BlocProvider(
                              create: (context) => sl<HealthPostCubit>(),
                            ),
                          ],
                          child: SpmFilterBottomsheet(
                            selectedDistrictCode: selectedDistrictCode,
                            selectedSubDistrictCode: selectedSubDistrictCode,
                            selectedHealthPostUuid: selectedHealthPostUuid,
                            selectedSpmField: selectedSpmField,
                            selectedStatus: selectedStatus,
                          ),
                        ),
                      );

                      if (result != null) {
                        final filter = result as Map<String, dynamic>;

                        onAppliedFilter(filter);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.softAmberColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        selectedDistrictCode == null &&
                                selectedSubDistrictCode == null &&
                                selectedSpmField == null &&
                                selectedStatus.isEmpty
                            ? MingCute.filter_line
                            : MingCute.filter_fill,
                        size: 22,
                        color: AppColors.amberColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: BaseDropdownField(
                      hint: 'Pilih bulan',
                      value: selectedMonth,
                      prefixIcon: selectedMonth == null
                          ? null
                          : BaseIconButton(
                              icon: MingCute.close_circle_line,
                              size: 18,
                              color: Colors.red,
                              onPressed: onRemoveMonth,
                            ),
                      items: List.generate(months.length, (index) {
                        return DropdownMenuItem(
                          value: index + 1,
                          child: Text(months[index]),
                        );
                      }),
                      onChanged: onSelectedMonth,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: BaseDropdownField(
                      hint: 'Pilih tahun',
                      value: selectedYear,
                      items: List.generate(years.length, (index) {
                        return DropdownMenuItem(
                          value: years[index],
                          child: Text(years[index].toString()),
                        );
                      }),
                      onChanged: onSelectedYear,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
