import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/cubits/detail_spm/detailspm_cubit.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/views/detail_spm/components/detailspm_loading.dart';
import 'package:panduan/app/views/detail_spm/widgets/activity_section.dart';
import 'package:panduan/app/views/detail_spm/widgets/detailspm_appbaraction.dart';
import 'package:panduan/app/views/detail_spm/widgets/detailspm_footer.dart';
import 'package:panduan/app/views/detail_spm/widgets/report_section.dart';
import 'package:panduan/app/views/detail_spm/widgets/reporter_section.dart';
import 'package:panduan/app/widgets/base_handlestate.dart';

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
      permissionName: 'level-walikota',
    )) {
      final possible =
          (context.read<DetailSpmCubit>().state.detailSpm?.status ==
                  'FORWARD_TO_TP_POSYANDU_KOTA' ||
              context.read<DetailSpmCubit>().state.detailSpm?.status ==
                  'RETURN_TO_TP_POSYANDU_KOTA') &&
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

    // if (AppHelpers.hasPermission(
    //   context.read<AuthCubit>().state.userPermissions,
    //   permissionName: 'level-posyandu',
    // )) {
    //   final possible =
    //       context.read<DetailSpmCubit>().state.detailSpm?.status ==
    //           'RETURN_TO_KADER' &&
    //       AppHelpers.hasPermission(
    //         context.read<AuthCubit>().state.userPermissions,
    //         permissionName: 'user-submission-verification',
    //       );

    //   setState(() {
    //     _canVerify = possible;
    //   });
    // }
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
      permissionName: 'level-kecamatan',
    )) {
      final possible =
          context.read<DetailSpmCubit>().state.detailSpm?.status ==
              'PROCESS_BY_DISTRICT' &&
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
    super.initState();
    context.read<DetailSpmCubit>().fetchDetailSpm(uuid: widget.spmUuid).then((
      _,
    ) {
      _checkCanVerify();
      _checkCanSubmit();
    });
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
            ? detailSpmAppBarAction(context, spmUuid: widget.spmUuid)
            : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<DetailSpmCubit, DetailSpmState>(
              listenWhen: (previous, current) =>
                  previous.detailStatus != current.detailStatus,
              listener: (context, state) {
                if (state.detailStatus == DetailStatus.success) {
                  _checkCanSubmit();
                  _checkCanVerify();
                }
              },
              builder: (context, state) {
                switch (state.detailStatus) {
                  case DetailStatus.error:
                    return BaseHandleState(
                      handleType: HandleType.error,
                      errorMessage: state.detailError ?? '',
                      onRefetch: () {
                        context.read<DetailSpmCubit>().refetchDetailSpm(
                          uuid: widget.spmUuid,
                        );
                      },
                    );
                  case DetailStatus.success:
                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        ReportSection(
                          receiptNumber: state.detailSpm?.receiptNumber ?? '',
                          healthPostName:
                              state.detailSpm?.healthPost?.name ?? '',
                          subDistrictName:
                              state.detailSpm?.subDistrict?.name ?? '',
                          districtName: state.detailSpm?.district?.name ?? '',
                          reportedAt: state.detailSpm?.date ?? DateTime(0000),
                          createdAt:
                              state.detailSpm?.createdAt ?? DateTime(0000),
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
                          districtName:
                              state.detailSpm?.user?.district?.name ?? '',
                          phone: state.detailSpm?.user?.phone ?? '',
                        ),
                        const SizedBox(height: 16),
                        ActivitySection(
                          activities: state.detailSpm?.activity ?? const [],
                          canSubmitOrVerify: _canSubmit || _canVerify,
                        ),
                      ],
                    );
                  default:
                    return const DetailSpmLoading();
                }
              },
            ),
          ),
          if (context.watch<DetailSpmCubit>().state.detailStatus ==
                  DetailStatus.success &&
              (_canSubmit || _canVerify)) ...{
            DetailSpmFooter(
              spmUuid: widget.spmUuid,
              spmStatus:
                  context.watch<DetailSpmCubit>().state.detailSpm?.status ?? '',
              canSubmit: _canSubmit,
              canVerify: _canVerify,
            ),
          },
        ],
      ),
    );
  }
}
