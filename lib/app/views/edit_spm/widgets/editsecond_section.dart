import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/models/attachment.dart';
import 'package:panduan/app/models/spm_attachment.dart';
import 'package:panduan/app/views/create_spm/widgets/second_section.dart';
import 'package:panduan/app/views/webview/webview_page.dart';
import 'package:panduan/app/widgets/base_button.dart';
import 'package:panduan/app/widgets/base_formfield.dart';
import 'package:panduan/app/widgets/base_iconbutton.dart';
import 'package:panduan/app/widgets/base_textbutton.dart';
import 'package:panduan/app/widgets/show_custombottomsheet.dart';
import 'package:panduan/app/widgets/show_filesourcebottomsheet.dart';

class EditSecondSection extends StatelessWidget {
  const EditSecondSection({
    required this.spmFieldName,
    required this.formKeyAttachment,
    required this.spmAttachments,
    required this.hasFileMap,
    required this.attachments,
    required this.attachmentControllers,
    required this.latitude,
    required this.longitude,
    required this.onSelectedCoordinate,
    required this.checkListAttachments,
    required this.onCheckedAttachment,
    required this.lastAttachmentIndex,
    required this.onPickedFile,
    required this.onRemoveAddOnAttachment,
    required this.onAddAttachment,
    super.key,
  });

  final String spmFieldName;
  final GlobalKey<FormState> formKeyAttachment;
  final List<SpmAttachment> spmAttachments;
  final Map<String, dynamic> hasFileMap;
  final List<Attachment> attachments;
  final List<TextEditingController> attachmentControllers;
  final double? latitude;
  final double? longitude;
  final void Function(LatLng coordinate, int index) onSelectedCoordinate;
  final List<bool> checkListAttachments;
  final void Function(int index) onCheckedAttachment;
  final int lastAttachmentIndex;
  final void Function(String fileName, String filePath, int index) onPickedFile;
  final void Function(int index) onRemoveAddOnAttachment;
  final void Function(List<SpmAttachment> addOnAttachments) onAddAttachment;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: Material(
          elevation: 1,
          clipBehavior: Clip.antiAlias,
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(MingCute.send_line, size: 20),
                          SizedBox(width: 2),
                          Text(
                            'Persyaratan SPM',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Lampiran SPM bidang ${spmFieldName.toLowerCase()}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Form(
                  key: formKeyAttachment,
                  child: Column(
                    children: [
                      ...List.generate(spmAttachments.length, (index) {
                        return Row(
                          children: [
                            if (index > lastAttachmentIndex) ...{
                              BaseIconButton(
                                icon: MingCute.close_circle_fill,
                                color: Colors.red.shade600,
                                onPressed: () {
                                  onRemoveAddOnAttachment(index);
                                },
                              ),
                              const SizedBox(width: 10),
                            },
                            Expanded(
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: RichText(
                                      text: TextSpan(
                                        style: DefaultTextStyle.of(
                                          context,
                                        ).style,
                                        children: [
                                          TextSpan(
                                            text: spmAttachments[index].label,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: BaseFormField(
                                          hint:
                                              'Pilih file (jpg, jpeg, png, pdf)',
                                          controller:
                                              attachmentControllers[index],
                                          isDate: true,
                                          onTap: () async {
                                            final result =
                                                await showFileSourceBottomSheet(
                                                  context,
                                                );

                                            if (result != null) {
                                              final file =
                                                  result
                                                      as Map<String, dynamic>;

                                              onPickedFile(
                                                file['fileName'],
                                                file['filePath'],
                                                index,
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      BaseIconButton(
                                        icon: checkListAttachments[index]
                                            ? MingCute.checkbox_fill
                                            : MingCute.square_line,
                                        onPressed: () {
                                          onCheckedAttachment(index);
                                        },
                                      ),
                                    ],
                                  ),
                                  if (hasFileMap[spmAttachments[index].key] !=
                                      null) ...{
                                    const SizedBox(height: 4),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: BaseTextButton(
                                        text: 'Lihat File',
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            WebviewPage.routeName,
                                            arguments: {
                                              'fileName':
                                                  hasFileMap[spmAttachments[index]
                                                          .key]
                                                      .toString()
                                                      .split('/')
                                                      .last,
                                              'filePath':
                                                  hasFileMap[spmAttachments[index]
                                                      .key],
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  },
                                  if (index != spmAttachments.length - 1)
                                    const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          height: 36,
                          child: BaseButtonIcon(
                            icon: MingCute.add_line,
                            label: 'Tambah File',
                            labelSize: 12,
                            iconSize: 14,
                            onPressed: () async {
                              final result = await showDynamicHeightBottomSheet(
                                context,
                                child: const AddOnFileBottomSheet(),
                              );

                              if (result != null) {
                                final addOnAttachments =
                                    result as List<SpmAttachment>;

                                onAddAttachment(addOnAttachments);
                              }
                            },
                          ),
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
    );
  }
}
