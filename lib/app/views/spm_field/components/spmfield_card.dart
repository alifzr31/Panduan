import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:panduan/app/utils/app_strings.dart';

class SpmFieldCard extends StatelessWidget {
  const SpmFieldCard({
    required this.name,
    required this.description,
    this.index,
    this.dataLength,
    this.onTap,
    super.key,
  });

  final String name;
  final String description;
  final int? index;
  final int? dataLength;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: Colors.grey.shade100,
      margin: EdgeInsets.only(
        bottom: index == ((dataLength ?? 0) - 1) ? 0 : 10,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Ink(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: Border.all(width: 0.2, color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    '${AppStrings.assetsIcons}/${name.replaceAll(' ', '_').toLowerCase()}.svg',
                    width: 32,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
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
