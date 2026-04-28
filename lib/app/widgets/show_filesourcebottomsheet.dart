import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/views/camera/camera_page.dart';
import 'package:panduan/app/widgets/show_custombottomsheet.dart';

Future<Object?> showFileSourceBottomSheet(BuildContext context) {
  return showDynamicHeightBottomSheet(
    context,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Pilih Sumber File/Gambar',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: CupertinoButton(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.all(2),
                    onPressed: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        CameraPage.routeName,
                      );

                      if (result != null) {
                        final resultMap = result as Map<String, dynamic>;

                        if (context.mounted) {
                          Navigator.pop(context, resultMap);
                        }
                      }
                      // final ImagePicker picker = ImagePicker();

                      // final pickedFile = await picker.pickImage(
                      //   source: ImageSource.camera,
                      //   imageQuality: 60,
                      // );

                      // if (pickedFile != null) {
                      //   if (context.mounted) {
                      //     Navigator.pop(context, {
                      //       'fileName': pickedFile.name,
                      //       'filePath': pickedFile.path,
                      //     });
                      //   }
                      // }
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: AppColors.softBlueColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              MingCute.camera_2_fill,
                              size: 34,
                              color: AppColors.blueColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Kamera',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CupertinoButton(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.all(2),
                    onPressed: () async {
                      final pickedFile = await FilePicker.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
                      );

                      if (pickedFile != null) {
                        if (context.mounted) {
                          Navigator.pop(context, {
                            'fileName': pickedFile.files.single.name,
                            'filePath': pickedFile.files.single.path,
                          });
                        }
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: AppColors.softBlueColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              MingCute.folder_2_fill,
                              size: 34,
                              color: AppColors.blueColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'File Saya',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
