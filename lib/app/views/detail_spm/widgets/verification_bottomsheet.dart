import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:panduan/app/cubits/activity/activity_cubit.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/models/service_type.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/views/map_coordinate/mapcoordinate_page.dart';
import 'package:panduan/app/widgets/base_button.dart';
import 'package:panduan/app/widgets/base_dropdownfield.dart';
import 'package:panduan/app/widgets/base_formfield.dart';
import 'package:panduan/app/widgets/base_iconbutton.dart';
import 'package:panduan/app/widgets/show_customtoast.dart';
import 'package:panduan/app/widgets/show_filesourcebottomsheet.dart';
import 'package:toastification/toastification.dart';

class VerificationBottomSheet extends StatefulWidget {
  const VerificationBottomSheet({
    required this.spmUuid,
    required this.serviceCategoryUuid,
    required this.spmFieldType,
    required this.spmStatus,
    super.key,
  });

  final String spmUuid;
  final String serviceCategoryUuid;
  final int spmFieldType;
  final String spmStatus;

  @override
  State<VerificationBottomSheet> createState() =>
      _VerificationBottomSheetState();
}

class _VerificationBottomSheetState extends State<VerificationBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _serviceTypes = const [
    ServiceType(nameIndonesian: 'Perencanaan', nameEnglish: 'Planning'),
    ServiceType(nameIndonesian: 'Pelaksanaan', nameEnglish: 'Implementation'),
    ServiceType(nameIndonesian: 'Pengawasan', nameEnglish: 'Surveillance'),
    ServiceType(nameIndonesian: 'Layanan', nameEnglish: 'Service'),
  ];
  final _selectedServiceType = ValueNotifier<String?>(null);
  late final List<String> _verificationResults;
  final _selectedVerificationResult = ValueNotifier<String?>(null);
  final _selectedOpd = ValueNotifier<String?>(null);
  final _noteController = TextEditingController();
  double? _latitude;
  double? _longitude;
  final _coordinateController = TextEditingController();
  final List<TextEditingController> _attachmentKeyControllers = [];
  final List<TextEditingController> _attachmentControllers = [];
  final List<String> _attachmentPaths = [];
  bool _showVerificationResult = false;
  bool _showOpdDropdown = false;

  void _initFormByRole() {
    final authState = context.read<AuthCubit>().state;

    final bool isWalikota = AppHelpers.hasPermission(
      authState.userPermissions,
      permissionName: 'level-walikota',
    );

    final bool isKaderPosyandu = AppHelpers.hasPermission(
      authState.userPermissions,
      permissionName: 'level-posyandu',
    );

    final bool isReturnToTpKota =
        widget.spmStatus == 'RETURN_TO_TP_POSYANDU_KOTA';

    setState(() {
      _showVerificationResult =
          (!isWalikota || isReturnToTpKota) && !isKaderPosyandu;
      _showOpdDropdown = isWalikota && !isReturnToTpKota;
    });
  }

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
    _initFormByRole();
    if (context.read<AuthCubit>().state.userPermissions.contains('level-opd')) {
      setState(() {
        _verificationResults = const [
          'PROCESS_BY_OPD',
          'DECLINE_BY_OPD',
          'RETURN_TO_TP_POSYANDU_KOTA',
        ];
      });
    } else if (context.read<AuthCubit>().state.userPermissions.contains(
      'level-walikota',
    )) {
      if (widget.spmStatus == 'RETURN_TO_TP_POSYANDU_KOTA') {
        setState(() {
          _verificationResults = const ['FORWARD_TO_OPD', 'RETURN_TO_KADER'];
        });
      } else {
        context.read<ActivityCubit>().fetchOpd();
      }
    } else if (context.read<AuthCubit>().state.userPermissions.contains(
      'level-kecamatan',
    )) {
      setState(() {
        _verificationResults = const [
          'PROCESS_BY_DISTRICT',
          'DECLINE_BY_DISTRICT',
          'FORWARD_TO_TP_POSYANDU_KOTA',
        ];
      });
    } else if (context.read<AuthCubit>().state.userPermissions.contains(
      'level-kelurahan',
    )) {
      if (widget.spmFieldType == 2) {
        setState(() {
          _verificationResults = const [
            'PROCESS_BY_SUB_DISTRICT',
            'DECLINE_BY_SUB_DISTRICT',
            'FORWARD_TO_DISTRICT',
          ];
        });
      } else {
        setState(() {
          _verificationResults = const [
            'PROCESS_BY_SUB_DISTRICT',
            'DECLINE_BY_SUB_DISTRICT',
            'FORWARD_TO_TP_POSYANDU_KOTA',
          ];
        });
      }
    }

    _addFile();
  }

  @override
  void dispose() {
    _selectedServiceType.dispose();
    _selectedVerificationResult.dispose();
    _selectedOpd.dispose();
    _noteController.dispose();
    _coordinateController.dispose();
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
                'Verifikasi SPM',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  if (AppHelpers.hasPermission(
                    context.read<AuthCubit>().state.userPermissions,
                    permissionName: 'level-kelurahan',
                  )) ...{
                    BaseDropdownGroupField(
                      label: 'Jenis Pelayanan',
                      hint: 'Pilih jenis pelayanan',
                      mandatory: true,
                      value: _selectedServiceType,
                      items: _serviceTypes.map((e) {
                        return DropdownItem(
                          value: e.nameEnglish,
                          child: Text(e.nameIndonesian ?? ''),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Silahkan pilih jenis pelayanan';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _selectedServiceType.value = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                  },
                  if (_showVerificationResult) ...{
                    BaseDropdownGroupField(
                      label: 'Hasil Verifikasi',
                      hint: 'Pilih hasil verifikasi',
                      mandatory: true,
                      value: _selectedVerificationResult,
                      items: _verificationResults.map((e) {
                        return DropdownItem(
                          value: e,
                          child: Text(AppHelpers.statusLabel(e)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedOpd.value = null;
                          _selectedVerificationResult.value = value;
                        });

                        if (_selectedVerificationResult.value ==
                            'FORWARD_TO_OPD') {
                          context.read<ActivityCubit>().fetchOpd();
                        }
                      },
                      validator: (value) {
                        if (_selectedVerificationResult.value == null) {
                          return 'Silahkan pilih hasil verifikasi';
                        }

                        return null;
                      },
                    ),
                  },
                  if (_showOpdDropdown ||
                      _selectedVerificationResult.value ==
                          'FORWARD_TO_OPD') ...{
                    const SizedBox(height: 10),
                    BlocBuilder<ActivityCubit, ActivityState>(
                      builder: (context, state) {
                        return BaseDropdownGroupField(
                          label: 'OPD Tujuan',
                          hint: state.opdStatus == OpdStatus.success
                              ? 'Pilih OPD tujuan'
                              : 'Mohon tunggu...',
                          mandatory: true,
                          value: _selectedOpd,
                          items: state.opd.map((e) {
                            return DropdownItem(
                              value: e.uuid,
                              child: Text(e.name ?? ''),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedOpd.value = value;
                            });
                          },
                          validator: (value) {
                            if (_selectedOpd.value == null) {
                              return 'Silahkan pilih OPD tujuan';
                            }

                            return null;
                          },
                        );
                      },
                    ),
                  },
                  const SizedBox(height: 10),
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
                  if (AppHelpers.hasPermission(
                    context.read<AuthCubit>().state.userPermissions,
                    permissionName: 'level-kelurahan',
                  )) ...{
                    const SizedBox(height: 10),
                    BaseFormGroupField(
                      label: 'Titik Koordinat Lokasi',
                      hint: 'Tentukan titik koordinat lokasi',
                      mandatory: true,
                      controller: _coordinateController,
                      isDate: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Silahkan tentukan titik koordinat lokasi';
                        }

                        return null;
                      },
                      onTap: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          MapCoordinatePage.routeName,
                          arguments: _latitude == null && _longitude == null
                              ? null
                              : {
                                  'latitude': _latitude,
                                  'longitude': _longitude,
                                },
                        );

                        if (result != null) {
                          final coordinate = result as LatLng;

                          setState(() {
                            _latitude = coordinate.latitude;
                            _longitude = coordinate.longitude;
                          });
                          _coordinateController.text =
                              '${coordinate.latitude}, ${coordinate.longitude}';
                        }
                      },
                    ),
                  },
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
                        Navigator.pop(context, 'verified-spm');
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
                          label: 'Verifikasi SPM',
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              context.read<ActivityCubit>().createActivity(
                                spmUuid: widget.spmUuid,
                                serviceType: _selectedServiceType.value,
                                status: !_showVerificationResult
                                    ? AppHelpers.hasPermission(
                                            context
                                                .read<AuthCubit>()
                                                .state
                                                .userPermissions,
                                            permissionName: 'level-posyandu',
                                          )
                                          ? 'NEED_VERIFICATION_SUB_DISTRICT'
                                          : 'FORWARD_TO_OPD'
                                    : _selectedVerificationResult.value,
                                description: _noteController.text,
                                opdUuids: _selectedOpd.value == null
                                    ? null
                                    : [_selectedOpd.value ?? ''],
                                latitude: _latitude,
                                longitude: _longitude,
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
