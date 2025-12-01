import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/string_extension.dart';

class HealthPostCard extends StatelessWidget {
  const HealthPostCard({
    required this.healthPostName,
    required this.districtName,
    required this.subDistrictName,
    required this.index,
    required this.dataLength,
    this.onTap,
    super.key,
  });

  final String healthPostName;
  final String districtName;
  final String subDistrictName;
  final int index;
  final int dataLength;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(bottom: index == (dataLength - 1) ? 0 : 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Ink(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.softBlueColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    MingCute.building_1_line,
                    size: 26,
                    color: AppColors.blueColor,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Posyandu ${healthPostName.capitalize()}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Kecamatan ${districtName.capitalize()}, Kelurahan ${subDistrictName.capitalize()}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
