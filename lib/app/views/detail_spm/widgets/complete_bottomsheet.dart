import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:panduan/app/cubits/activity/activity_cubit.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/widgets/base_button.dart';
import 'package:panduan/app/widgets/base_formfield.dart';
import 'package:panduan/app/widgets/base_iconbutton.dart';
import 'package:panduan/app/widgets/show_customtoast.dart';
import 'package:panduan/app/widgets/show_filesourcebottomsheet.dart';
import 'package:toastification/toastification.dart';

class CompleteBottomSheet extends StatefulWidget {
  const CompleteBottomSheet({
    required this.spmUuid,
    required this.serviceCategoryUuid,
    super.key,
  });

  final String spmUuid;
  final String serviceCategoryUuid;

  @override
  State<CompleteBottomSheet> createState() => _CompleteBottomSheetState();
}

class _CompleteBottomSheetState extends State<CompleteBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  final List<TextEditingController> _attachmentKeyControllers = [];
  final List<TextEditingController> _attachmentControllers = [];
  final List<String> _attachmentPaths = [];

  void _addFile() {
    setState(() {
      _attachmentKeyControllers.add(TextEditingController());
      _attachmentControllers.add(TextEditingController());
      _attachmentPaths.add('');
    });
  }

  void _removeFile(int index) {
    setState(() {
      _attachmentKeyControllers[index].dispose();
      _attachmentKeyControllers.removeAt(index);
      _attachmentControllers[index].dispose();
      _attachmentControllers.removeAt(index);
      _attachmentPaths.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _addFile();
  }

  @override
  void dispose() {
    _noteController.dispose();
    for (var i = 0; i < _attachmentKeyControllers.length; i++) {
      _attachmentKeyControllers[i].dispose();
      _attachmentControllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Selesaikan SPM',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  BaseFormGroupField(
                    label: 'Catatan',
                    hint: 'Masukkan catatan',
                    mandatory: true,
                    controller: _noteController,
                    maxLines: 4,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Silahkan masukkan catatan';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 2),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Berikan catatan atau alasan terkait hasil verifikasi',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: const [
                          TextSpan(
                            text: 'Unggah Berkas',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Card(
                    elevation: 1,
                    color: Colors.white,
                    margin: EdgeInsets.zero,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          ...List.generate(_attachmentKeyControllers.length, (
                            index,
                          ) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: BaseFormField(
                                        hint: 'Kata kunci',
                                        controller:
                                            _attachmentKeyControllers[index],
                                        validator: index < 1
                                            ? null
                                            : (value) {
                                                if (value!.isEmpty) {
                                                  return 'Silahkan masukkan kata kunci';
                                                }

                                                return null;
                                              },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 2,
                                      child: BaseFormField(
                                        hint:
                                            'Pilih file (jpg, jpeg, png, pdf). Max 2MB',
                                        controller:
                                            _attachmentControllers[index],
                                        isDate: true,
                                        onTap: () async {
                                          final result =
                                              await showFileSourceBottomSheet(
                                                context,
                                              );

                                          if (result != null) {
                                            final file =
                                                result as Map<String, dynamic>;

                                            setState(() {
                                              _attachmentPaths[index] =
                                                  file['filePath'];
                                            });
                                            _attachmentControllers[index].text =
                                                file['fileName'];
                                          }
                                        },
                                        validator: index < 1
                                            ? null
                                            : (value) {
                                                if (value!.isEmpty) {
                                                  return 'Silahkan pilih file terlebih dahulu';
                                                }

                                                return null;
                                              },
                                      ),
                                    ),
                                    if (index > 0) ...{
                                      const SizedBox(width: 10),
                                      BaseIconButton(
                                        icon: MingCute.close_circle_line,
                                        color: AppColors.redColor,
                                        onPressed: () {
                                          _removeFile(index);
                                        },
                                      ),
                                    },
                                  ],
                                ),
                                if (index !=
                                    _attachmentKeyControllers.length - 1)
                                  const SizedBox(height: 10),
                              ],
                            );
                          }),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Divider(color: Colors.grey.shade300),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              height: 38,
                              child: BaseOutlineButtonIcon(
                                fgColor: AppColors.blueColor,
                                icon: MingCute.add_line,
                                iconSize: 16,
                                label: 'Tambah File',
                                labelSize: 12,
                                onPressed: _addFile,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocListener<ActivityCubit, ActivityState>(
                    listenWhen: (previous, current) =>
                        previous.formStatus != current.formStatus,
                    listener: (context, state) {
                      if (state.formStatus == FormStatus.loading) {
                        context.loaderOverlay.show();
                      }

                      if (state.formStatus == FormStatus.success) {
                        context.loaderOverlay.hide();
                        Navigator.pop(context, 'submitted-spm');
                        showCustomToast(
                          context,
                          type: ToastificationType.success,
                          title: 'Verifikasi SPM Berhasil',
                          description:
                              state.formResponse?.data['message'] ?? '',
                        );
                      }

                      if (state.formStatus == FormStatus.error) {
                        context.loaderOverlay.hide();
                        showCustomToast(
                          context,
                          type: ToastificationType.error,
                          title: 'Verifikasi SPM Gagal',
                          description: state.formError,
                        );
                      }
                    },
                    child: SafeArea(
                      top: false,
                      child: SizedBox(
                        width: double.infinity,
                        child: BaseButtonIcon(
                          icon: MingCute.file_check_line,
                          label: 'Selesaikan SPM',
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              context.read<ActivityCubit>().createActivity(
                                spmUuid: widget.spmUuid,
                                status:
                                    context
                                        .read<AuthCubit>()
                                        .state
                                        .userPermissions
                                        .contains('level-opd')
                                    ? 'FINISH_BY_OPD'
                                    : context
                                          .read<AuthCubit>()
                                          .state
                                          .userPermissions
                                          .contains('level-kelurahan')
                                    ? 'FINISH_BY_SUB_DISTRICT'
                                    : null,
                                description: _noteController.text,
                                attachmentKeys: _attachmentKeyControllers.map((
                                  e,
                                ) {
                                  return e.text;
                                }).toList(),
                                attachmentPaths: _attachmentPaths,
                              );
                            }
                          },
                        ),
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
}
