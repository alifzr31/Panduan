import 'package:flutter/material.dart';
import 'package:panduan/app/widgets/base_skeletonizer.dart';

class SpmFieldCountCardLoading extends StatelessWidget {
  const SpmFieldCountCardLoading({super.key});

  List<String> spmFields() {
    return const [
      'Pendidikan',
      'Kesehatan',
      'Pekerjaan Umum',
      'Perumahan Rakyat',
      'Trantibum Linmas',
      'Sosial',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 0,
          color: Colors.grey.shade100,
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Total SPM',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 10),
                BaseSkeletonizer(
                  child: Material(
                    clipBehavior: Clip.antiAlias,
                    shape: const StadiumBorder(),
                    color: Colors.grey.shade300,
                    child: Container(height: 25, width: 62, color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...List.generate(spmFields().length, (index) {
          return Card(
            elevation: 0,
            color: Colors.grey.shade100,
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.only(
              bottom: index == spmFields().length - 1 ? 0 : 4,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      spmFields()[index],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  BaseSkeletonizer(
                    child: Material(
                      clipBehavior: Clip.antiAlias,
                      shape: const StadiumBorder(),
                      color: Colors.grey.shade300,
                      child: Container(
                        height: 25,
                        width: 62,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
