import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/app_helpers.dart';

class AttachmentCard extends StatelessWidget {
  const AttachmentCard({
    required this.title,
    required this.fileName,
    required this.filePath,
    required this.checklist,
    this.onPressedShowFile,
    this.index,
    this.dataLength,
    super.key,
  });

  final String title;
  final String fileName;
  final String? filePath;
  final bool checklist;
  final void Function()? onPressedShowFile;
  final int? index;
  final int? dataLength;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(bottom: index == ((dataLength ?? 0) - 1) ? 0 : 6),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadiusGeometry.circular(8),
      ),
      child: InkWell(
        onTap: filePath == null ? null : onPressedShowFile,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              const Icon(MingCute.attachment_2_line, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppHelpers.showSpmAttachmentLabel(key: title),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (checklist)
                      Text(
                        filePath == null ? 'File tidak tersedia' : fileName,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Ink(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: checklist
                      ? AppColors.softGreenColor
                      : AppColors.softRedColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  checklist
                      ? MingCute.checkbox_fill
                      : MingCute.close_circle_fill,
                  size: 18,
                  color: checklist ? AppColors.greenColor : AppColors.redColor,
                ),
              ),
              // if (checklist) ...{
              //   Container(
              //     padding: const EdgeInsets.all(6),
              //     decoration: const BoxDecoration(
              //       color: AppColors.softGreenColor,
              //       shape: BoxShape.circle,
              //     ),
              //     child: const Icon(
              //       MingCute.checkbox_fill,
              //       size: 18,
              //       color: AppColors.greenColor,
              //     ),
              //   ),
              // } else ...{
              //   CupertinoButton(
              //     alignment: Alignment.center,
              //     minimumSize: Size.zero,
              //     padding: EdgeInsets.zero,
              //     onPressed: onPressedShowFile,
              //     child: Container(
              //       padding: const EdgeInsets.all(6),
              //       decoration: const BoxDecoration(
              //         color: AppColors.softBlueColor,
              //         shape: BoxShape.circle,
              //       ),
              //       child: const Icon(
              //         MingCute.eye_2_fill,
              //         size: 18,
              //         color: AppColors.blueColor,
              //       ),
              //     ),
              //   ),
              // },
            ],
          ),
        ),
      ),
    );
  }
}

class ActivityAttachmentCard extends StatelessWidget {
  const ActivityAttachmentCard({
    required this.fileName,
    this.onPressedShow,
    this.index,
    this.dataLength,
    super.key,
  });

  final String fileName;
  final void Function()? onPressedShow;
  final int? index;
  final int? dataLength;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(bottom: index == ((dataLength ?? 0) - 1) ? 0 : 6),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadiusGeometry.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            const Icon(MingCute.attachment_2_line, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  fileName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CupertinoButton(
              alignment: Alignment.center,
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              onPressed: onPressedShow,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.softBlueColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  MingCute.eye_2_fill,
                  size: 18,
                  color: AppColors.blueColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
