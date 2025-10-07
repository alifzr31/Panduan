import 'package:flutter/material.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/utils/string_extension.dart';

class SpmCard extends StatelessWidget {
  const SpmCard({
    required this.receiptNumber,
    required this.reportedAt,
    required this.fieldName,
    required this.healthPostName,
    required this.subDistrictName,
    required this.districtName,
    required this.status,
    this.index,
    this.dataLength,
    this.onTap,
    super.key,
  });

  final String receiptNumber;
  final DateTime reportedAt;
  final String fieldName;
  final String healthPostName;
  final String subDistrictName;
  final String districtName;
  final String status;
  final int? index;
  final int? dataLength;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(bottom: index == (dataLength ?? 0) - 1 ? 0 : 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      receiptNumber,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    AppHelpers.dmyhmDateFormat(reportedAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'Bidang ${fieldName.capitalize()}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Posyandu ${healthPostName.capitalize()}, Kelurahan ${subDistrictName.capitalize()}, Kecamatan ${districtName.capitalize()}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              Ink(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: AppHelpers.statusColor(status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    AppHelpers.statusLabel(status),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
