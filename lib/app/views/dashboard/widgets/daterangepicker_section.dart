import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/app_helpers.dart';

class DateRangePickerSection extends StatelessWidget {
  const DateRangePickerSection({
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
    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        controller: rangeDateController,
        readOnly: true,
        style: const TextStyle(fontSize: 14, color: Colors.black),
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
            dialogSize: Size(AppHelpers.getWidthDevice(context), 400),
            borderRadius: BorderRadius.circular(12),
            value: selectedRangeDates,
          );

          if (values != null) {
            final selectedValues = values as List<DateTime>;

            onSelectedRangeDate(selectedValues);
          }
        },
        decoration: InputDecoration(
          hintText: 'Pilih rentang bulan',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
          isDense: true,
          contentPadding: const EdgeInsets.all(10),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 10, right: 2),
            child: Icon(MingCute.calendar_2_line, size: 18),
          ),
          prefixIconConstraints: const BoxConstraints(
            minHeight: 38,
            minWidth: 30,
          ),
          suffixIconConstraints: const BoxConstraints(
            minHeight: 38,
            minWidth: 30,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade600),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
