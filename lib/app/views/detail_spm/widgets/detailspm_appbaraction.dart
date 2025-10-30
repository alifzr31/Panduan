import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/cubits/detail_spm/detailspm_cubit.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/views/edit_spm/editspm_page.dart';
import 'package:panduan/app/widgets/base_iconbutton.dart';
import 'package:panduan/app/widgets/base_textbutton.dart';
import 'package:panduan/app/widgets/show_customtoast.dart';
import 'package:toastification/toastification.dart';

List<Widget> detailSpmAppBarAction(
  BuildContext context, {
  required String spmUuid,
}) {
  return [
    if (AppHelpers.hasPermission(
          context.read<AuthCubit>().state.userPermissions,
          permissionName: 'user-submission-update',
        ) &&
        context.watch<DetailSpmCubit>().state.detailSpm?.status ==
            'NEED_VERIFICATION_SUB_DISTRICT') ...{
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
              'detailSpm': context.read<DetailSpmCubit>().state.detailSpm,
            },
          );

          if (result != null) {
            if (result == 'updated-spm') {
              if (context.mounted) {
                context.read<DetailSpmCubit>().refetchDetailSpm(uuid: spmUuid);
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
              description: state.deleteResponse?.data['message'] ?? '',
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
                              context.read<DetailSpmCubit>().deleteSpm(
                                uuid: spmUuid,
                              );
                            },
                          ),
                          const SizedBox(width: 6),
                          BaseTextButton(
                            size: 14,
                            text: 'Batal',
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
  ];
}
