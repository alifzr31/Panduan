import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/models/spm_attachment.dart';
import 'package:panduan/app/widgets/base_button.dart';
import 'package:panduan/app/widgets/base_formfield.dart';
import 'package:panduan/app/widgets/base_iconbutton.dart';
import 'package:panduan/app/widgets/show_custombottomsheet.dart';
import 'package:panduan/app/widgets/show_filesourcebottomsheet.dart';

class SecondSection extends StatelessWidget {
  const SecondSection({
    required this.spmFieldName,
    required this.formKeyAttachment,
    required this.spmAttachments,
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
                    children: List.generate(spmAttachments.length, (index) {
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
                                      style: DefaultTextStyle.of(context).style,
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
                                                result as Map<String, dynamic>;

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
                                    // Expanded(
                                    //   child: BaseFormField(
                                    //     hint:
                                    //         spmAttachments[index].key ==
                                    //             'location_coordinates'
                                    //         ? 'Tentukan tiitk koordinat lokasi'
                                    //         : 'Pilih file (jpg, jpeg, png, pdf)',
                                    //     controller: attachmentControllers[index],
                                    //     isDate: true,
                                    //     onTap: () async {
                                    //       if (spmAttachments[index].key ==
                                    //           'location_coordinates') {
                                    //         final result = await Navigator.pushNamed(
                                    //           context,
                                    //           MapCoordinatePage.routeName,
                                    //           arguments:
                                    //               latitude == null &&
                                    //                   longitude == null
                                    //               ? null
                                    //               : {
                                    //                   'latitude': latitude,
                                    //                   'longitude': longitude,
                                    //                 },
                                    //         );

                                    //         if (result != null) {
                                    //           final coordinate = result as LatLng;

                                    //           onSelectedCoordinate(coordinate, index);
                                    //         }
                                    //       } else {
                                    //         final result =
                                    //             await showFileSourceBottomSheet(
                                    //               context,
                                    //             );

                                    //         if (result != null) {
                                    //           final file =
                                    //               result as Map<String, dynamic>;

                                    //           onPickedFile(
                                    //             file['fileName'],
                                    //             file['filePath'],
                                    //             index,
                                    //           );
                                    //         }
                                    //       }
                                    //     },
                                    //   ),
                                    // ),
                                    // if (spmAttachments[index].key !=
                                    //     'location_coordinates') ...{
                                    //   const SizedBox(width: 10),
                                    //   BaseIconButton(
                                    //     icon: checkListAttachments[index]
                                    //         ? MingCute.checkbox_fill
                                    //         : MingCute.square_line,
                                    //     onPressed: () {
                                    //       onCheckedAttachment(index);
                                    //     },
                                    //   ),
                                    // },
                                  ],
                                ),
                                if (index != spmAttachments.length - 1)
                                  const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
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
        ),
      ),
    );
  }
}

class AddOnFileBottomSheet extends StatefulWidget {
  const AddOnFileBottomSheet({super.key});

  @override
  State<AddOnFileBottomSheet> createState() => _AddOnFileBottomSheetState();
}

class _AddOnFileBottomSheetState extends State<AddOnFileBottomSheet> {
  final List<GlobalKey<FormState>> _formKeys = [];
  final List<TextEditingController> _labelControllers = [];

  void _addForm() {
    setState(() {
      _formKeys.add(GlobalKey<FormState>());
      _labelControllers.add(TextEditingController());
    });
  }

  void _removeForm(int index) {
    setState(() {
      _formKeys.removeAt(index);
      _labelControllers[index].dispose();
      _labelControllers.removeAt(index);
    });
  }

  @override
  void initState() {
    _addForm();
    super.initState();
  }

  @override
  void dispose() {
    for (var i = 0; i < _formKeys.length; i++) {
      _labelControllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tambah File',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(_formKeys.length, (index) {
              return Container(
                margin: EdgeInsets.only(
                  bottom: index == (_formKeys.length - 1) ? 0 : 10,
                ),
                child: Material(
                  elevation: 1,
                  color: Colors.white,
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'File ke-${index + 1}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            if (index != 0) ...{
                              const SizedBox(width: 10),
                              BaseIconButton(
                                icon: MingCute.close_circle_fill,
                                size: 18,
                                color: Colors.red.shade600,
                                onPressed: () {
                                  _removeForm(index);
                                },
                              ),
                            },
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Divider(
                            height: 1,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        Form(
                          key: _formKeys[index],
                          child: BaseFormGroupField(
                            label: 'Nama/Judul File',
                            hint: 'Masukkan nama/judul file',
                            mandatory: true,
                            controller: _labelControllers[index],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Silahkan masukkan nama/judul file';
                              }

                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: BaseButton(label: 'Tambah', onPressed: _addForm),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: BaseButton(
                    label: 'Simpan',
                    onPressed: () {
                      final addOnAttachments = List.generate(_formKeys.length, (
                        index,
                      ) {
                        return SpmAttachment(
                          key: _labelControllers[index].text,
                          label: _labelControllers[index].text,
                        );
                      });

                      Navigator.pop(context, addOnAttachments);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
