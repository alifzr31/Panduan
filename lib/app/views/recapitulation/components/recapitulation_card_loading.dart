import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/widgets/base_skeletonizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RecapitulationCardLoading extends StatelessWidget {
  const RecapitulationCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
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
              borderRadius: BorderRadiusGeometry.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Skeleton.keep(
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.softBlueColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Icon(
                              MingCute.building_5_line,
                              size: 24,
                              color: AppColors.blueColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'xxxxxxxxxx',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              'xxxxxxxxxxxxxxxxxx',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Material(
                        clipBehavior: Clip.antiAlias,
                        shape: const StadiumBorder(),
                        color: Colors.grey.shade300,
                        child: Container(
                          height: 25,
                          width: 62,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(height: 1),
                  ),
                  ...List.generate(7, (index) {
                    return Column(
                      children: [
                        const Row(
                          children: [
                            Expanded(
                              child: Text(
                                'xxxxxxxxxxxxx',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '99 SPM',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        if (index != 6) ...{const SizedBox(height: 2)},
                      ],
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
