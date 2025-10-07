import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/widgets/base_dropdownfield.dart';
import 'package:panduan/app/widgets/base_formfield.dart';
import 'package:panduan/app/widgets/base_iconbutton.dart';

class SpmHeader extends StatelessWidget {
  const SpmHeader({
    required this.searchSpmController,
    required this.onSearchSpm,
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BaseFormField(
              hint: 'Cari berdasarkan no. resi (Cth: SPM0123456789)',
              controller: searchSpmController,
              prefixIcon: const Icon(MingCute.search_3_line, size: 18),
              onChanged: onSearchSpm,
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
    );
  }
}
