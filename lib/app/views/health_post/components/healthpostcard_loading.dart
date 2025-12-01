import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/widgets/base_skeletonizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

Widget healthPostCardLoading() {
  return BaseSkeletonizer(
    child: ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 25,
      itemBuilder: (context, index) {
        return Card(
          elevation: 1,
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
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
                  child: const Skeleton.keep(
                    child: Center(
                      child: Icon(
                        MingCute.building_1_line,
                        size: 24,
                        color: AppColors.blueColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'XXXXXXXXXXXXXXXXXX',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
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
        );
      },
    ),
  );
}
