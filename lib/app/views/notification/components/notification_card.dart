import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/app_helpers.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    required this.title,
    required this.description,
    required this.readAt,
    required this.createdAt,
    required this.numbering,
    this.index,
    this.dataLength,
    this.onTap,
    super.key,
  });

  final String title;
  final String description;
  final DateTime? readAt;
  final DateTime createdAt;
  final int numbering;
  final int? index;
  final int? dataLength;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: index == ((dataLength ?? 0) - 1) ? true : false,
      child: Card(
        elevation: 1,
        color: readAt == null ? const Color(0xFFEFF6FF) : Colors.white,
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.only(
          bottom: index == ((dataLength ?? 0) - 1) ? 0 : 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Ink(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.softBlueColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          MingCute.notification_line,
                          size: 20,
                          color: AppColors.blueColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  MingCute.clock_2_fill,
                                  size: 14,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 2),
                                Flexible(
                                  child: Text(
                                    AppHelpers.dmyhmDateFormat(createdAt),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  numbering.toString(),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
