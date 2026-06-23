import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/build_context_extension.dart';
import 'package:panduan/app/widgets/base_formfield.dart';

class RecapitulationHeader extends StatelessWidget {
  const RecapitulationHeader({
    required this.rangeDateController,
    required this.selectedRangeDates,
    required this.onSelectedRangeDate,
    super.key,
  });

  final TextEditingController rangeDateController;
  final List<DateTime> selectedRangeDates;
  final void Function(List<DateTime> selectedRangeDates) onSelectedRangeDate;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        elevation: 1,
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BaseFormField(
            hint: 'Pilih rentang tanggal',
            controller: rangeDateController,
            isDate: true,
            onTap: () async {
              final values = await showCalendarDatePicker2Dialog(
                dialogBackgroundColor: Colors.white,
                context: context,
                config: CalendarDatePicker2WithActionButtonsConfig(
                  calendarType: CalendarDatePicker2Type.range,
                  selectedDayHighlightColor: AppColors.blueColor,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  currentDate: DateTime.now(),
                  allowSameValueSelection: false,
                  okButton: const Text(
                    'Pilih',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blueColor,
                    ),
                  ),
                  cancelButton: Text(
                    'Batal',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                dialogSize: Size(context.deviceWidth, 400),
                borderRadius: BorderRadius.circular(12),
                value: selectedRangeDates,
              );

              if (values == null) return;

              final selectedValues = values as List<DateTime>;

              onSelectedRangeDate(selectedValues);
            },
          ),
        ),
      ),
    );
  }
}
