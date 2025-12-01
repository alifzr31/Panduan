import 'package:flutter/material.dart';
import 'package:panduan/app/widgets/base_skeletonizer.dart';

class DetailSpmLoading extends StatelessWidget {
  const DetailSpmLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseSkeletonizer(
      child: ListView(
        padding: const EdgeInsets.all(16),
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(3, (index) {
          return Container(
            height: 360,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            child: Material(
              elevation: 1,
              color: Colors.white,
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(10),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'xxxxxxxxxxxxxxxxx',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
