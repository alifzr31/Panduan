import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/configs/get_it/service_locator.dart';
import 'package:panduan/app/cubits/activity/activity_cubit.dart';
import 'package:panduan/app/cubits/detail_spm/detailspm_cubit.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/views/detail_spm/widgets/complete_bottomsheet.dart';
import 'package:panduan/app/views/detail_spm/widgets/verification_bottomsheet.dart';
import 'package:panduan/app/widgets/base_button.dart';
import 'package:panduan/app/widgets/show_custombottomsheet.dart';

class DetailSpmFooter extends StatelessWidget {
  const DetailSpmFooter({
    required this.spmUuid,
    required this.canSubmit,
    required this.canVerify,
    super.key,
  });

  final String spmUuid;
  final bool canSubmit;
  final bool canVerify;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(52),
              blurRadius: 1,
              offset: const Offset(0, -1),
              spreadRadius: 0,
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              if (canSubmit) ...{
                Expanded(
                  child: BaseButtonIcon(
                    bgColor: Colors.green,
                    label: 'Selesaikan SPM',
                    icon: MingCute.check_circle_fill,
                    onPressed: () async {
                      final result = await showDynamicHeightBottomSheet(
                        context,
                        child: BlocProvider(
                          create: (ctx) => sl<ActivityCubit>(),
                          child: CompleteBottomSheet(
                            spmUuid: spmUuid,
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
                              uuid: spmUuid,
                            );
                          }
                        }
                      }
                    },
                  ),
                ),
              },
              if (canVerify) ...{
                Expanded(
                  child: BaseButtonIcon(
                    bgColor: AppColors.purpleColor,
                    label: 'Verifikasi SPM',
                    icon: MingCute.file_check_line,
                    onPressed: () async {
                      final result = await showDynamicHeightBottomSheet(
                        context,
                        child: BlocProvider(
                          create: (ctx) => sl<ActivityCubit>(),
                          child: VerificationBottomSheet(
                            spmUuid: spmUuid,
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
                              uuid: spmUuid,
                            );
                          }
                        }
                      }
                    },
                  ),
                ),
              },
            ],
          ),
        ),
      ),
    );
  }
}
