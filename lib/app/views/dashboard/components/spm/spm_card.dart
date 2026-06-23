import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
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
    required this.isExpired,
    required this.respondTime,
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
  final bool isExpired;
  final String? respondTime;
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
              Align(
                alignment: .centerLeft,
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(height: 1, color: Colors.grey.shade300),
              ),
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
              if (isExpired) ...{
                if (AppHelpers.showExpiredSpmWarning(
                  status: status,
                  userPermissions: context
                      .read<AuthCubit>()
                      .state
                      .userPermissions,
                )) ...{
                  const SizedBox(height: 6),
                  Ink(
                    padding: const .symmetric(vertical: 4, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.red.shade600,
                      borderRadius: .circular(20),
                    ),
                    child: const Row(
                      crossAxisAlignment: .center,
                      children: [
                        Icon(
                          MingCute.warning_line,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Center(
                            child: Text(
                              'SPM telah melebihi batas waktu (3 hari)',
                              textAlign: .center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          MingCute.warning_line,
                          size: 16,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                },
              },
              if (respondTime != null) ...{
                const SizedBox(height: 6),
                Align(
                  alignment: .centerLeft,
                  child: Text(
                    'Waktu Respon: $respondTime',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              },
            ],
          ),
        ),
      ),
    );
  }
}
