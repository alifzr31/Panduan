import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/widgets/show_customtoast.dart';
import 'package:toastification/toastification.dart';

class BaseFilePickerGroupField extends StatelessWidget {
  const BaseFilePickerGroupField({
    required this.label,
    required this.value,
    this.mandatory = false,
    this.fileType = FileType.any,
    this.multipleFiles = false,
    this.allowedExtensions,
    this.onPickFile,
    super.key,
  });

  final String label;
  final File? value;
  final bool mandatory;
  final FileType fileType;
  final bool multipleFiles;
  final List<String>? allowedExtensions;
  final void Function(File?)? onPickFile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (mandatory)
                  TextSpan(
                    text: '*',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.red.shade700,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 180,
          width: double.infinity,
          child: Material(
            color: AppColors.greyFormField,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () async {
                try {
                  final pickedFile = await FilePicker.platform.pickFiles(
                    type: fileType,
                    allowMultiple: multipleFiles,
                    allowedExtensions: allowedExtensions,
                    compressionQuality: 80,
                  );

                  if (pickedFile != null ||
                      (pickedFile?.files.isNotEmpty ?? false)) {
                    final compressedFile = await AppHelpers.compressImage(
                      path: pickedFile?.files.single.path ?? '',
                    );

                    if (compressedFile != null) {
                      double fileSize = AppHelpers.convertFileSizeByteToMb(
                        await compressedFile.length(),
                      );

                      if (fileSize > 3) {
                        if (context.mounted) {
                          showCustomToast(
                            context,
                            type: ToastificationType.error,
                            title: 'Unggah File Gagal',
                            description:
                                'Ukuran file terlalu besar, maksimal 2MB.',
                          );
                        }

                        await compressedFile.delete();
                      } else {
                        if (onPickFile != null) {
                          onPickFile!(compressedFile);
                        }
                      }
                    }
                  }
                } catch (e) {
                  if (kDebugMode) print(e);
                }
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (value != null)
                    Ink(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(value!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  Container(
                    color: value == null
                        ? null
                        : Colors.black.withValues(alpha: 0.4),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MingCute.documents_line,
                          size: 30,
                          color: value == null ? null : Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Pilif Foto/Dokumen',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: value == null ? null : Colors.white,
                          ),
                        ),
                        Text(
                          'Ekstensi yang diizinkan ${allowedExtensions?.map((e) {
                            return '.$e';
                          })}.\nUkuran foto/dokumen maksimal 2MB',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: value == null
                                ? Colors.grey.shade600
                                : Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
