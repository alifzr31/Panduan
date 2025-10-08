import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/models/attachment.dart';
import 'package:panduan/app/models/spm_attachment.dart';
import 'package:panduan/app/views/map_coordinate/mapcoordinate_page.dart';
import 'package:panduan/app/views/webview/webview_page.dart';
import 'package:panduan/app/widgets/base_formfield.dart';
import 'package:panduan/app/widgets/base_iconbutton.dart';
import 'package:panduan/app/widgets/base_textbutton.dart';

class EditSecondSection extends StatelessWidget {
  const EditSecondSection({
    required this.spmFieldName,
    required this.formKeyAttachment,
    required this.spmAttachments,
    required this.attachments,
    required this.attachmentControllers,
    required this.latitude,
    required this.longitude,
    required this.onSelectedCoordinate,
    required this.checkListAttachments,
    required this.onCheckedAttachment,
    required this.onPickedFile,
    super.key,
  });

  final String spmFieldName;
  final GlobalKey<FormState> formKeyAttachment;
  final List<SpmAttachment> spmAttachments;
  final List<Attachment> attachments;
  final List<TextEditingController> attachmentControllers;
  final double? latitude;
  final double? longitude;
  final void Function(LatLng coordinate, int index) onSelectedCoordinate;
  final List<bool> checkListAttachments;
  final void Function(int index) onCheckedAttachment;
  final void Function(PlatformFile file, int index) onPickedFile;

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
                      ...List.generate(
                        spmAttachments
                            .where((element) {
                              return element.key != 'location_coordinates';
                            })
                            .toList()
                            .length,
                        (index) {
                          return Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: [
                                      TextSpan(
                                        text: spmAttachments
                                            .where((element) {
                                              return element.key !=
                                                  'location_coordinates';
                                            })
                                            .toList()[index]
                                            .label,
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
                                          spmAttachments
                                                  .where((element) {
                                                    return element.key !=
                                                        'location_coordinates';
                                                  })
                                                  .toList()[index]
                                                  .key ==
                                              'location_coordinates'
                                          ? 'Tentukan tiitk koordinat lokasi'
                                          : 'Pilih file (jpg, jpeg, png, pdf)',
                                      controller: attachmentControllers[index],
                                      isDate: true,
                                      onTap: () async {
                                        if (spmAttachments
                                                .where((element) {
                                                  return element.key !=
                                                      'location_coordinates';
                                                })
                                                .toList()[index]
                                                .key ==
                                            'location_coordinates') {
                                          final result =
                                              await Navigator.pushNamed(
                                                context,
                                                MapCoordinatePage.routeName,
                                                arguments:
                                                    latitude == null &&
                                                        longitude == null
                                                    ? null
                                                    : {
                                                        'latitude': latitude,
                                                        'longitude': longitude,
                                                      },
                                              );

                                          if (result != null) {
                                            final coordinate = result as LatLng;

                                            onSelectedCoordinate(
                                              coordinate,
                                              index,
                                            );
                                          }
                                        } else {
                                          final pickedFile = await FilePicker
                                              .platform
                                              .pickFiles(
                                                type: FileType.custom,
                                                allowedExtensions: [
                                                  'jpg',
                                                  'jpeg',
                                                  'png',
                                                  'pdf',
                                                ],
                                              );

                                          if (pickedFile != null) {
                                            onPickedFile(
                                              pickedFile.files.single,
                                              index,
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                  if (spmAttachments
                                          .where((element) {
                                            return element.key !=
                                                'location_coordinates';
                                          })
                                          .toList()[index]
                                          .key !=
                                      'location_coordinates') ...{
                                    const SizedBox(width: 10),
                                    BaseIconButton(
                                      icon: checkListAttachments[index]
                                          ? MingCute.checkbox_fill
                                          : MingCute.square_line,
                                      onPressed: () {
                                        onCheckedAttachment(index);
                                      },
                                    ),
                                  },
                                ],
                              ),
                              if (attachments[index].path != null) ...{
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
                                              attachments[index].nameFile,
                                          'filePath': attachments[index].path,
                                        },
                                      );
                                    },
                                  ),
                                ),
                              },
                              if (index !=
                                  spmAttachments
                                          .where((element) {
                                            return element.key !=
                                                'location_coordinates';
                                          })
                                          .toList()
                                          .length -
                                      1)
                                const SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                      if (spmAttachments
                          .map((e) {
                            return e.key;
                          })
                          .toList()
                          .contains('location_coordinates')) ...{
                        const SizedBox(height: 10),
                        BaseFormGroupField(
                          label: 'Titik Koordinat Lokasi',
                          hint: 'Tentukan tiitk koordinat lokasi',
                          controller: attachmentControllers.last,
                          isDate: true,
                          onTap: () async {
                            final result = await Navigator.pushNamed(
                              context,
                              MapCoordinatePage.routeName,
                              arguments: latitude == null && longitude == null
                                  ? null
                                  : {
                                      'latitude': latitude,
                                      'longitude': longitude,
                                    },
                            );

                            if (result != null) {
                              final coordinate = result as LatLng;

                              onSelectedCoordinate(
                                coordinate,
                                attachmentControllers.length - 1,
                              );
                            }
                          },
                        ),
                      },
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
