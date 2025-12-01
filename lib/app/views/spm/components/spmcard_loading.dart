import 'package:flutter/material.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/widgets/base_skeletonizer.dart';

class SpmCardLoading extends StatelessWidget {
  const SpmCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseSkeletonizer(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'xxxxxxxxxxxxxxx',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        AppHelpers.dmyhmDateFormat(DateTime(0000)),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'xxxxxxxxxxxxxxxxxxxxxxx',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const Text(
                    'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 30,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 10,
                    ),
                    foregroundDecoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
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
}
