import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:panduan/app/models/attachment.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/views/detail_spm/components/attachment_card.dart';
import 'package:panduan/app/views/map_coordinate/mapcoordinate_page.dart';
import 'package:panduan/app/views/webview/webview_page.dart';
import 'package:panduan/app/widgets/base_textbutton.dart';
import 'package:panduan/app/widgets/show_custombottomsheet.dart';

class ActivityTracking extends StatelessWidget {
  const ActivityTracking({
    required this.title,
    required this.createdAt,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.attachments,
    this.index,
    this.dataLength,
    super.key,
  });

  final String title;
  final DateTime createdAt;
  final String? description;
  final String? latitude;
  final String? longitude;
  final List<Attachment>? attachments;
  final int? index;
  final int? dataLength;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat('dd-MMM').format(createdAt),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              Text(
                DateFormat('HH:mm').format(createdAt),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(width: 6),
          Column(
            children: [
              Container(
                height: 10,
                width: 10,
                decoration: const BoxDecoration(
                  color: AppColors.blueColor,
                  shape: BoxShape.circle,
                ),
              ),
              if (index != ((dataLength ?? 0) - 1))
                Expanded(
                  child: Container(width: 1, color: AppColors.blueColor),
                ),
            ],
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                bottom: index == ((dataLength ?? 0) - 1) ? 0 : 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  if (description != null)
                    Text(
                      description ?? '',
                      style: const TextStyle(fontSize: 12),
                    ),
                  if ((latitude != null && longitude != null) ||
                      (attachments?.isNotEmpty ?? false)) ...{
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        if (latitude != null && longitude != null) ...{
                          Flexible(
                            child: BaseTextButton(
                              text: 'Lihat lokasi',
                              color: AppColors.pinkColor,
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  MapCoordinatePage.routeName,
                                  arguments: {
                                    'latitude': double.parse(latitude ?? '0'),
                                    'longitude': double.parse(longitude ?? '0'),
                                    'viewOnly': true,
                                  },
                                );
                              },
                            ),
                          ),
                        },
                        if (attachments?.isNotEmpty ?? false) ...{
                          const SizedBox(width: 10),
                          Flexible(
                            child: BaseTextButton(
                              text: 'Lihat lampiran',
                              onPressed: () {
                                showCustomBottomSheet(
                                  context,
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Lampiran Aktivitas',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                title,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: attachments?.length,
                                          itemBuilder:
                                              (context, attachmentIndex) {
                                                final attachment =
                                                    attachments?[attachmentIndex];

                                                return ActivityAttachmentCard(
                                                  fileName:
                                                      attachment?.nameFile ??
                                                      '',
                                                  index: attachmentIndex,
                                                  dataLength:
                                                      attachments?.length,
                                                  onPressedShow: () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      WebviewPage.routeName,
                                                      arguments: {
                                                        'fileName': attachment
                                                            ?.nameFile,
                                                        'filePath':
                                                            attachment?.path,
                                                      },
                                                    );
                                                  },
                                                );
                                              },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        },
                      ],
                    ),
                  },
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
