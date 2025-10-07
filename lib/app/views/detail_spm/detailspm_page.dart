import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:panduan/app/configs/get_it/service_locator.dart';
import 'package:panduan/app/cubits/activity/activity_cubit.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/cubits/detail_spm/detailspm_cubit.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/views/detail_spm/components/detailspm_loading.dart';
import 'package:panduan/app/views/detail_spm/widgets/activity_section.dart';
import 'package:panduan/app/views/detail_spm/widgets/complete_bottomsheet.dart';
import 'package:panduan/app/views/detail_spm/widgets/report_section.dart';
import 'package:panduan/app/views/detail_spm/widgets/reporter_section.dart';
import 'package:panduan/app/views/detail_spm/widgets/verification_bottomsheet.dart';
import 'package:panduan/app/views/edit_spm/editspm_page.dart';
import 'package:panduan/app/widgets/base_iconbutton.dart';
import 'package:panduan/app/widgets/base_textbutton.dart';
import 'package:panduan/app/widgets/show_custombottomsheet.dart';
import 'package:panduan/app/widgets/show_customtoast.dart';
import 'package:toastification/toastification.dart';

class DetailSpmPage extends StatefulWidget {
  const DetailSpmPage({required this.spmUuid, super.key});

  final String spmUuid;

  static const String routeName = '/detailSpm';

  @override
  State<DetailSpmPage> createState() => _DetailSpmPageState();
}

class _DetailSpmPageState extends State<DetailSpmPage> {
  bool _canVerify = false;
  bool _canSubmit = false;

  void _checkCanVerify() {
    if (AppHelpers.hasPermission(
      context.read<AuthCubit>().state.userPermissions,
      permissionName: 'level-opd',
    )) {
      final possible =
          context.read<DetailSpmCubit>().state.detailSpm?.status ==
              'NEED_VERIFICATION_OPD' &&
          AppHelpers.hasPermission(
            context.read<AuthCubit>().state.userPermissions,
            permissionName: 'user-submission-verification',
          );

      setState(() {
        _canVerify = possible;
      });
    }

    if (AppHelpers.hasPermission(
      context.read<AuthCubit>().state.userPermissions,
      permissionName: 'level-kecamatan',
    )) {
      final possible =
          context.read<DetailSpmCubit>().state.detailSpm?.status ==
              'NEED_APPROVAL_DISTRICT' &&
          AppHelpers.hasPermission(
            context.read<AuthCubit>().state.userPermissions,
            permissionName: 'user-submission-verification',
          );

      setState(() {
        _canVerify = possible;
      });
    }

    if (AppHelpers.hasPermission(
      context.read<AuthCubit>().state.userPermissions,
      permissionName: 'level-kelurahan',
    )) {
      final possible =
          context.read<DetailSpmCubit>().state.detailSpm?.status ==
              'NEED_VERIFICATION_SUB_DISTRICT' &&
          AppHelpers.hasPermission(
            context.read<AuthCubit>().state.userPermissions,
            permissionName: 'user-submission-verification',
          );

      setState(() {
        _canVerify = possible;
      });
    }
  }

  void _checkCanSubmit() {
    if (AppHelpers.hasPermission(
      context.read<AuthCubit>().state.userPermissions,
      permissionName: 'level-opd',
    )) {
      final possible =
          context.read<DetailSpmCubit>().state.detailSpm?.status ==
              'PROCESS_BY_OPD' &&
          AppHelpers.hasPermission(
            context.read<AuthCubit>().state.userPermissions,
            permissionName: 'user-submission-submit',
          );

      setState(() {
        _canSubmit = possible;
      });
    }

    if (AppHelpers.hasPermission(
      context.read<AuthCubit>().state.userPermissions,
      permissionName: 'level-kelurahan',
    )) {
      final possible =
          context.read<DetailSpmCubit>().state.detailSpm?.status ==
              'PROCESS_BY_SUB_DISTRICT' &&
          AppHelpers.hasPermission(
            context.read<AuthCubit>().state.userPermissions,
            permissionName: 'user-submission-submit',
          );

      setState(() {
        _canSubmit = possible;
      });
    }
  }

  @override
  void initState() {
    context.read<DetailSpmCubit>().fetchDetailSpm(uuid: widget.spmUuid).then((
      _,
    ) {
      _checkCanVerify();
      _checkCanSubmit();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Detail SPM',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        actionsPadding: const EdgeInsets.only(right: 16),
        actions:
            context.watch<DetailSpmCubit>().state.detailStatus ==
                DetailStatus.success
            ? [
                if (_canSubmit) ...{
                  BaseIconButton(
                    icon: MingCute.check_circle_fill,
                    size: 22,
                    color: AppColors.greenColor,
                    onPressed: () async {
                      final result = await showDynamicHeightBottomSheet(
                        context,
                        child: BlocProvider(
                          create: (ctx) => sl<ActivityCubit>(),
                          child: CompleteBottomSheet(
                            spmUuid: widget.spmUuid,
                            serviceCategoryUuid:
                                context
                                    .read<DetailSpmCubit>()
                                    .state
                                    .detailSpm
                                    ?.serviceCategory
                                    ?.uuid ??
                                '',
                          ),
                        ),
                      );

                      if (result != null) {
                        if (result == 'submitted-spm') {
                          if (context.mounted) {
                            context.read<DetailSpmCubit>().refetchDetailSpm(
                              uuid: widget.spmUuid,
                            );
                            _checkCanVerify();
                            _checkCanSubmit();
                          }
                        }
                      }
                    },
                  ),
                },
                if (AppHelpers.hasPermission(
                      context.read<AuthCubit>().state.userPermissions,
                      permissionName: 'user-submission-update',
                    ) &&
                    context.watch<DetailSpmCubit>().state.detailSpm?.status ==
                        'NEED_VERIFICATION_SUB_DISTRICT') ...{
                  const SizedBox(width: 8),
                  BaseIconButton(
                    icon: MingCute.edit_line,
                    size: 22,
                    color: AppColors.amberColor,
                    onPressed: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        EditSpmPage.routeName,
                        arguments: {
                          'spmFieldUuid': context
                              .read<DetailSpmCubit>()
                              .state
                              .detailSpm
                              ?.spmField
                              ?.uuid,
                          'spmFieldName': context
                              .read<DetailSpmCubit>()
                              .state
                              .detailSpm
                              ?.spmField
                              ?.name,
                          'detailSpm': context
                              .read<DetailSpmCubit>()
                              .state
                              .detailSpm,
                        },
                      );

                      if (result != null) {
                        if (result == 'updated-spm') {
                          if (context.mounted) {
                            context.read<DetailSpmCubit>().refetchDetailSpm(
                              uuid: widget.spmUuid,
                            );
                            _checkCanVerify();
                            _checkCanSubmit();
                          }
                        }
                      }
                    },
                  ),
                },
                if (_canVerify) ...{
                  const SizedBox(width: 8),
                  BaseIconButton(
                    icon: MingCute.file_check_line,
                    size: 22,
                    color: AppColors.purpleColor,
                    onPressed: () async {
                      final result = await showDynamicHeightBottomSheet(
                        context,
                        child: BlocProvider(
                          create: (ctx) => sl<ActivityCubit>(),
                          child: VerificationBottomSheet(
                            spmUuid: widget.spmUuid,
                            serviceCategoryUuid:
                                context
                                    .read<DetailSpmCubit>()
                                    .state
                                    .detailSpm
                                    ?.serviceCategory
                                    ?.uuid ??
                                '',
                            spmFieldType:
                                context
                                    .read<DetailSpmCubit>()
                                    .state
                                    .detailSpm
                                    ?.spmField
                                    ?.type ??
                                0,
                          ),
                        ),
                      );

                      if (result != null) {
                        if (result == 'verified-spm') {
                          if (context.mounted) {
                            context.read<DetailSpmCubit>().refetchDetailSpm(
                              uuid: widget.spmUuid,
                            );
                            _checkCanVerify();
                            _checkCanSubmit();
                          }
                        }
                      }
                    },
                  ),
                },
                if (AppHelpers.hasPermission(
                      context.read<AuthCubit>().state.userPermissions,
                      permissionName: 'user-submission-delete',
                    ) &&
                    context.watch<DetailSpmCubit>().state.detailSpm?.status ==
                        'NEED_VERIFICATION_SUB_DISTRICT') ...{
                  const SizedBox(width: 8),
                  BlocListener<DetailSpmCubit, DetailSpmState>(
                    listenWhen: (previous, current) =>
                        previous.deleteStatus != current.deleteStatus,
                    listener: (context, state) {
                      if (state.deleteStatus == DeleteStatus.loading) {
                        context.loaderOverlay.show();
                      }

                      if (state.deleteStatus == DeleteStatus.success) {
                        context.loaderOverlay.hide();
                        Navigator.pop(context);
                        Navigator.pop(context, 'spm-deleted');
                        showCustomToast(
                          context,
                          type: ToastificationType.success,
                          title: 'Hapus SPM Berhasil',
                          description:
                              state.deleteResponse?.data['message'] ?? '',
                        );
                      }

                      if (state.deleteStatus == DeleteStatus.error) {
                        context.loaderOverlay.hide();
                        showCustomToast(
                          context,
                          type: ToastificationType.error,
                          title: 'Hapus SPM Gagal',
                          description: state.deleteError,
                        );
                      }
                    },
                    child: BaseIconButton(
                      icon: MingCute.delete_2_line,
                      size: 22,
                      color: AppColors.redColor,
                      onPressed: () {
                        showAdaptiveDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (ctx) {
                            return BlocProvider(
                              create: (ctx_) => context.read<DetailSpmCubit>(),
                              child: BlocBuilder<DetailSpmCubit, DetailSpmState>(
                                builder: (_, state) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 1,
                                    surfaceTintColor: Colors.white,
                                    titleTextStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Jost',
                                      color: Colors.black,
                                    ),
                                    contentTextStyle: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Jost',
                                      color: Colors.black,
                                    ),
                                    title: const Text('Apakah Anda Yakin?'),
                                    content: Text(
                                      'Data SPM dengan no. resi ${state.detailSpm?.receiptNumber} akan dihapus secara permanen, dan tidak dapat dikembalikan setelah dihapus.',
                                    ),
                                    actions: [
                                      BaseTextButton(
                                        size: 14,
                                        text: 'Ya, Hapus',
                                        color: AppColors.blueColor,
                                        onPressed: () {
                                          context
                                              .read<DetailSpmCubit>()
                                              .deleteSpm(uuid: widget.spmUuid);
                                        },
                                      ),
                                      const SizedBox(width: 6),
                                      BaseTextButton(
                                        size: 14,
                                        text: 'Batsl',
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                },
              ]
            : null,
      ),
      body: BlocBuilder<DetailSpmCubit, DetailSpmState>(
        builder: (context, state) {
          switch (state.detailStatus) {
            case DetailStatus.error:
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(state.detailError ?? ''),
                ),
              );
            case DetailStatus.success:
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ReportSection(
                    receiptNumber: state.detailSpm?.receiptNumber ?? '',
                    healthPostName: state.detailSpm?.healthPost?.name ?? '',
                    subDistrictName: state.detailSpm?.subDistrict?.name ?? '',
                    districtName: state.detailSpm?.district?.name ?? '',
                    reportedAt: state.detailSpm?.date ?? DateTime(0000),
                    createdAt: state.detailSpm?.createdAt ?? DateTime(0000),
                    spmFieldName: state.detailSpm?.spmField?.name ?? '',
                    serviceCategoryName:
                        state.detailSpm?.serviceCategory?.name ?? '',
                    serviceType: state.detailSpm?.type ?? '',
                    status: state.detailSpm?.status ?? '',
                    reportDescription: state.detailSpm?.description ?? '',
                    latitude: state.detailSpm?.latitude,
                    longitude: state.detailSpm?.longitude,
                    attachments: state.detailSpm?.attachments ?? const [],
                  ),
                  const SizedBox(height: 16),
                  ReporterSection(
                    nik: state.detailSpm?.user?.nik ?? '',
                    fullName: state.detailSpm?.user?.fullName ?? '',
                    address: state.detailSpm?.user?.address ?? '',
                    rt: state.detailSpm?.user?.rt ?? '',
                    rw: state.detailSpm?.user?.rw ?? '',
                    subDistrictName:
                        state.detailSpm?.user?.subDistrict?.name ?? '',
                    districtName: state.detailSpm?.user?.district?.name ?? '',
                    phone: state.detailSpm?.user?.phone ?? '',
                  ),
                  const SizedBox(height: 16),
                  ActivitySection(
                    activities: state.detailSpm?.activity ?? const [],
                  ),
                ],
              );
            default:
              return detailSpmLoading();
          }
        },
      ),
    );
  }
}
