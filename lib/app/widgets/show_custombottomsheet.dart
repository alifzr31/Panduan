import 'package:flutter/material.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/app_helpers.dart';

void showCustomBottomSheet(
  BuildContext context, {
  double? height,
  Widget? child,
}) {
  showModalBottomSheet(
    clipBehavior: Clip.antiAlias,
    elevation: 2,
    isDismissible: false,
    isScrollControlled: true,
    backgroundColor: AppColors.backgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    context: context,
    builder: (context) {
      return SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            height: height,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      height: 8,
                      width: AppHelpers.getHeightDevice(context) * 0.13,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                Padding(padding: const EdgeInsets.only(top: 16), child: child),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void showDynamicHeightBottomSheet(
  BuildContext context, {
  bool enableDrag = true,
  Widget? child,
}) {
  showModalBottomSheet(
    clipBehavior: Clip.antiAlias,
    elevation: 2,
    isDismissible: false,
    isScrollControlled: true,
    enableDrag: enableDrag,
    backgroundColor: AppColors.backgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    context: context,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double maxHeight = AppHelpers.getHeightDevice(context) * 0.6;

            return Stack(
              children: [
                Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      height: 8,
                      width: AppHelpers.getWidthDevice(context) * 0.13,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: maxHeight),
                    child: child,
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
