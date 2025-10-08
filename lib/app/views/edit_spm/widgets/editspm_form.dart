import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:panduan/app/cubits/edit_spm/editspm_cubit.dart';
import 'package:panduan/app/cubits/location/location_cubit.dart';
import 'package:panduan/app/models/attachment.dart';
import 'package:panduan/app/models/district.dart';
import 'package:panduan/app/models/service_type.dart';
import 'package:panduan/app/models/spm.dart';
import 'package:panduan/app/models/spm_attachment.dart';
import 'package:panduan/app/models/subdistrict.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/utils/string_extension.dart';
import 'package:panduan/app/views/edit_spm/widgets/editfirst_section.dart';
import 'package:panduan/app/views/edit_spm/widgets/editsecond_section.dart';
import 'package:panduan/app/widgets/base_button.dart';
import 'package:panduan/app/widgets/show_customtoast.dart';
import 'package:toastification/toastification.dart';

class EditSpmForm extends StatefulWidget {
  const EditSpmForm({
    required this.spmFieldUuid,
    required this.spmFieldName,
    required this.detailSpm,
    super.key,
  });

  final String spmFieldUuid;
  final String spmFieldName;
  final Spm? detailSpm;

  @override
  State<EditSpmForm> createState() => _EditSpmFormState();
}

class _EditSpmFormState extends State<EditSpmForm> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _formKey = GlobalKey<FormState>();
  DateTime _selectedSubmissionDate = DateTime.now();
  final _submissionDateController = TextEditingController(
    text: AppHelpers.dmyhmDateFormat(DateTime.now()),
  );
  final _nikController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _addressController = TextEditingController();
  final rt = List.generate(
    50,
    (index) => (index + 1).toString().padLeft(3, '0'),
  );
  String? _selectedRt;
  final rw = List.generate(
    50,
    (index) => (index + 1).toString().padLeft(3, '0'),
  );
  String? _selectedRw;
  final _districtController = TextEditingController();
  District? _selectedDistrict;
  final _subDistrictController = TextEditingController();
  SubDistrict? _selectedSubDistrict;
  final _phoneController = TextEditingController();
  String? _selectedServiceCategory;
  final _serviceTypes = const [
    ServiceType(nameIndonesian: 'Perencanaan', nameEnglish: 'Planning'),
    ServiceType(nameIndonesian: 'Pelaksanaan', nameEnglish: 'Implementation'),
    ServiceType(nameIndonesian: 'Pengawasan', nameEnglish: 'Surveillance'),
    ServiceType(nameIndonesian: 'Layanan', nameEnglish: 'Service'),
  ];
  String? _selectedServiceType;
  final _reportDescriptionController = TextEditingController();

  final _formKeyAttachment = GlobalKey<FormState>();
  List<SpmAttachment> _spmAttachments = [];
  double? _latitude;
  double? _longitude;
  final Map<String, String> _attachmentPaths = {};
  final List<TextEditingController> _attachmentControllers = [];
  final List<bool> _checkListAttachments = [];

  void _initEditSpmData() {
    final detailSpm = widget.detailSpm;

    setState(() {
      _selectedSubmissionDate = detailSpm?.date ?? DateTime(0000);
      _selectedRt = detailSpm?.user?.rt;
      _selectedRw = detailSpm?.user?.rw;
    });

    _submissionDateController.text = AppHelpers.dmyhmDateFormat(
      _selectedSubmissionDate,
    );
    _nikController.text = detailSpm?.user?.nik ?? '';
    _fullNameController.text = detailSpm?.user?.fullName ?? '';
    _addressController.text = detailSpm?.user?.address ?? '';
    context.read<LocationCubit>().fetchDistricts().then((_) {
      setState(() {
        _selectedDistrict = context
            .read<LocationCubit>()
            .state
            .districts
            .firstWhere((element) {
              return element.code == detailSpm?.user?.district?.code;
            });
      });

      if (mounted) {
        context
            .read<LocationCubit>()
            .fetchSubDistricts(
              districtCode: _selectedDistrict?.code?.split('.').last,
            )
            .then((_) {
              setState(() {
                _selectedSubDistrict = context
                    .read<LocationCubit>()
                    .state
                    .subDistricts
                    .firstWhere((element) {
                      return element.code == detailSpm?.user?.subDistrict?.code;
                    });
              });
            });
      }
    });
    _phoneController.text = detailSpm?.user?.phone ?? '';
    context
        .read<EditSpmCubit>()
        .fetchServiceCategories(spmFieldUuid: widget.spmFieldUuid)
        .then((_) {
          if (mounted) {
            setState(() {
              _selectedServiceCategory = context
                  .read<EditSpmCubit>()
                  .state
                  .serviceCategories
                  .firstWhere((element) {
                    return element.uuid == detailSpm?.serviceCategory?.uuid;
                  })
                  .uuid;
            });
          }
        });
    setState(() {
      _selectedServiceType = detailSpm?.type?.capitalize();
    });
    _reportDescriptionController.text = detailSpm?.description ?? '';

    if (detailSpm?.latitude != null && detailSpm?.longitude != null) {
      setState(() {
        _latitude = double.parse(detailSpm?.latitude ?? '0');
        _longitude = double.parse(detailSpm?.longitude ?? '0');
      });
    }
    _initSpmAttachments(detailSpm?.attachments);
  }

  void _initSpmAttachments(List<Attachment>? attachments) {
    final spmFieldName = widget.spmFieldName.toLowerCase();

    _spmAttachments = AppHelpers.filterSpmAttachmentsByField(
      spmFieldName: spmFieldName,
    );

    _attachmentControllers.addAll(
      _spmAttachments.map((e) => TextEditingController()),
    );

    if (attachments != null && attachments.isNotEmpty) {
      _checkListAttachments.addAll(
        attachments.map((e) => e.checklist ?? false),
      );

      if (widget.detailSpm?.latitude != null &&
          widget.detailSpm?.longitude != null) {
        _attachmentControllers.last.text = '$_latitude, $_longitude';
      }
    }

    _checkListAttachments.addAll(_spmAttachments.map((e) => false));
  }

  @override
  void initState() {
    _initEditSpmData();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _submissionDateController.dispose();
    _nikController.dispose();
    _fullNameController.dispose();
    _addressController.dispose();
    _districtController.dispose();
    _subDistrictController.dispose();
    _phoneController.dispose();
    _reportDescriptionController.dispose();

    for (var attachmentController in _attachmentControllers) {
      attachmentController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (_currentPage > 0) {
            _pageController.previousPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic,
            );
          } else {
            Navigator.pop(context);
          }
        }
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.greenColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOutCubic,
                            height: 6,
                            width: _currentPage == 0
                                ? 0
                                : (AppHelpers.getWidthDevice(context) - 42) / 2,
                            decoration: BoxDecoration(
                              color: AppColors.greenColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _currentPage == 0 ? 'Data Pengajuan' : 'Persyaratan',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                EditFirstSection(
                  spmFieldUuid: widget.spmFieldUuid,
                  spmFieldName: widget.spmFieldName,
                  formKey: _formKey,
                  selectedSubmissionDate: _selectedSubmissionDate,
                  submissionDateController: _submissionDateController,
                  onSelectedSubmissionDate: (date) {
                    setState(() {
                      _selectedSubmissionDate = date;
                    });
                    _submissionDateController.text = AppHelpers.dmyhmDateFormat(
                      date,
                    );
                  },
                  nikController: _nikController,
                  onFindResident: (resident) {
                    _fullNameController.text =
                        resident?.fullName?.capitalize() ?? '';
                    _addressController.text = resident?.address ?? '';
                    _phoneController.text = resident?.phone ?? '';
                    setState(() {
                      _selectedRt = resident?.rt;
                      _selectedRw = resident?.rw;
                      _selectedDistrict = null;
                      _selectedSubDistrict = null;
                    });

                    if (resident?.district?.code != null) {
                      setState(() {
                        _selectedDistrict = context
                            .read<LocationCubit>()
                            .state
                            .districts
                            .firstWhere(
                              (element) =>
                                  element.code == resident?.district?.code,
                            );
                        _selectedSubDistrict = null;
                      });
                    }

                    if (resident?.subDistrict?.code != null) {
                      context
                          .read<LocationCubit>()
                          .fetchSubDistricts(
                            districtCode: _selectedDistrict?.districtCode,
                          )
                          .then((value) {
                            setState(() {
                              _selectedSubDistrict = context
                                  .read<LocationCubit>()
                                  .state
                                  .subDistricts
                                  .firstWhere(
                                    (element) =>
                                        element.code ==
                                        resident?.subDistrict?.code,
                                  );
                            });
                          });
                    }
                  },
                  fullNameController: _fullNameController,
                  addressController: _addressController,
                  rt: rt,
                  selectedRt: _selectedRt,
                  onSelectedRt: (value) {
                    setState(() {
                      _selectedRt = value as String;
                    });
                  },
                  rw: rw,
                  selectedRw: _selectedRw,
                  onSelectedRw: (value) {
                    setState(() {
                      _selectedRw = value as String;
                    });
                  },
                  selectedDistrict: _selectedDistrict,
                  districtController: _districtController,
                  onSelectedDistrict: (value) {
                    setState(() {
                      _selectedSubDistrict = null;
                      _selectedDistrict = value as District;
                    });

                    context.read<LocationCubit>().fetchSubDistricts(
                      districtCode: _selectedDistrict?.districtCode,
                    );
                  },
                  selectedSubDistrict: _selectedSubDistrict,
                  subDistrictController: _subDistrictController,
                  onSelectedSubDistrict: (value) {
                    setState(() {
                      _selectedSubDistrict = value as SubDistrict;
                    });
                  },
                  phoneController: _phoneController,
                  selectedServiceCategory: _selectedServiceCategory,
                  onSelectedServiceCategory: (value) {
                    setState(() {
                      _selectedServiceCategory = value as String;
                    });
                  },
                  serviceTypes: _serviceTypes,
                  selectedServiceType: _selectedServiceType,
                  onSelectedServiceType: (value) {
                    setState(() {
                      _selectedServiceType = value as String;
                    });
                  },
                  reportDescriptionController: _reportDescriptionController,
                ),
                EditSecondSection(
                  spmFieldName: widget.spmFieldName,
                  formKeyAttachment: _formKeyAttachment,
                  spmAttachments: _spmAttachments,
                  attachments: widget.detailSpm?.attachments ?? const [],
                  attachmentControllers: _attachmentControllers,
                  latitude: _latitude,
                  longitude: _longitude,
                  onSelectedCoordinate: (coordinate, index) {
                    setState(() {
                      _latitude = coordinate.latitude;
                      _longitude = coordinate.longitude;
                    });

                    _attachmentControllers[index].text =
                        '${coordinate.latitude}, ${coordinate.longitude}';
                  },
                  checkListAttachments: _checkListAttachments,
                  onCheckedAttachment: (index) {
                    setState(() {
                      _checkListAttachments[index] =
                          !_checkListAttachments[index];
                    });

                    if (!_checkListAttachments[index] &&
                        _attachmentPaths.isNotEmpty) {
                      _attachmentPaths.remove(_spmAttachments[index].key);
                      _attachmentControllers[index].clear();
                    }
                  },
                  onPickedFile: (file, index) {
                    final filePath = file.path;

                    setState(() {
                      _attachmentControllers[index].text = file.name;
                      _attachmentPaths[_spmAttachments[index].key ?? ''] =
                          filePath ?? '';
                      _checkListAttachments[index] = true;
                    });
                  },
                ),
              ],
            ),
          ),
          BlocListener<EditSpmCubit, EditSpmState>(
            listenWhen: (previous, current) =>
                previous.formStatus != current.formStatus,
            listener: (context, state) {
              if (state.formStatus == FormStatus.loading) {
                context.loaderOverlay.show();
              }

              if (state.formStatus == FormStatus.success) {
                context.loaderOverlay.hide();
                Navigator.pop(context, 'updated-spm');
                showCustomToast(
                  context,
                  type: ToastificationType.success,
                  title: 'Edit SPM Berhasil',
                  description: state.formResponse?.data['message'],
                );
              }

              if (state.formStatus == FormStatus.error) {
                context.loaderOverlay.hide();
                showCustomToast(
                  context,
                  type: ToastificationType.error,
                  title: 'Edit SPM Gagal',
                  description: state.formError,
                );
              }
            },
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: BaseButtonIcon(
                    label: _currentPage == 0 ? 'Lanjutkan' : 'Kirim Pelaporan',
                    icon: _currentPage == 0
                        ? MingCute.arrow_right_line
                        : MingCute.send_line,
                    onPressed: () async {
                      if (_currentPage == 0) {
                        if (_formKey.currentState?.validate() ?? false) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOutCubic,
                          );
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            FocusScope.of(context).unfocus();
                          });
                        }
                      } else {
                        if (_formKeyAttachment.currentState?.validate() ??
                            false) {
                          context.read<EditSpmCubit>().updateSpm(
                            spmUuid: widget.detailSpm?.uuid,
                            submissionDate: _selectedSubmissionDate,
                            nik: _nikController.text,
                            name: _fullNameController.text,
                            address: _addressController.text,
                            rt: _selectedRt,
                            rw: _selectedRw,
                            districtCode: _selectedDistrict?.code,
                            subDistrictCode: _selectedSubDistrict?.code,
                            phone: _phoneController.text,
                            serviceType: _selectedServiceType,
                            spmFieldUuid: widget.spmFieldUuid,
                            serviceCategoryUuid: _selectedServiceCategory,
                            reportDescription:
                                _reportDescriptionController.text,
                            latitude: _latitude,
                            longitude: _longitude,
                            attachmentUuids:
                                widget.detailSpm?.attachments?.map((e) {
                                  return e.uuid ?? '';
                                }).toList() ??
                                const [],
                            spmAttachments: _spmAttachments,
                            attachmentPaths: _attachmentPaths,
                            checklistAttachments: _checkListAttachments,
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
