import 'package:panduan/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showCustomToast(
  BuildContext context, {
  ToastificationType? type,
  String? title,
  String? description,
}) {
  toastification.show(
    context: context,
    type: type,
    style: ToastificationStyle.flat,
    title: Text(
      title ?? '',
      maxLines: description == null ? 99 : 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
    description: description == null
        ? null
        : Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
    alignment: Alignment.bottomCenter,
    autoCloseDuration: const Duration(seconds: 5),
    borderRadius: BorderRadius.circular(10),
    boxShadow: lowModeShadow,
    progressBarTheme: ProgressIndicatorThemeData(
      color: AppColors.blueColor,
      linearTrackColor: const Color(0xFFE2E6FC),
      borderRadius: BorderRadius.circular(4),
    ),
    dragToClose: true,
    closeButton: const ToastCloseButton(showType: CloseButtonShowType.none),
    margin: const EdgeInsets.fromLTRB(12, 12, 12, 6),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
  );
}
