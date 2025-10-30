import 'package:flutter/material.dart';
import 'package:panduan/app/models/spm.dart';
import 'package:panduan/app/views/detail_spm/components/activity_tracking.dart';

class ActivitySection extends StatelessWidget {
  const ActivitySection({
    required this.activities,
    required this.canSubmitOrVerify,
    super.key,
  });

  final List<Activity> activities;
  final bool canSubmitOrVerify;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: !canSubmitOrVerify,
      child: Material(
        elevation: 1,
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Riwayat Aktivitas',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Divider(height: 1, color: Colors.grey.shade300),
                    ),
                  ],
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];

                return ActivityTracking(
                  title: activity.title ?? '',
                  createdAt: activity.createdAt ?? DateTime(0000),
                  description: activity.description,
                  latitude: activity.latitude,
                  longitude: activity.longitude,
                  attachments: activity.attachments,
                  index: index,
                  dataLength: activities.length,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
