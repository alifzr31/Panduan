import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/cubits/notification/notification_cubit.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/views/detail_spm/detailspm_page.dart';
import 'package:panduan/app/widgets/base_button.dart';
import 'package:panduan/app/widgets/base_handlestate.dart';

class DetailNotificationPage extends StatefulWidget {
  const DetailNotificationPage({required this.notificationUuid, super.key});

  final String notificationUuid;

  static const String routeName = '/detailNotification';

  @override
  State<DetailNotificationPage> createState() => _DetailNotificationPageState();
}

class _DetailNotificationPageState extends State<DetailNotificationPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().fetchDetailNotification(
      notificationUuid: widget.notificationUuid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        bool hasReadAt =
            context
                .read<NotificationCubit>()
                .state
                .detailNotification
                ?.readAt !=
            null;

        if (!didPop) {
          Navigator.pop(context, hasReadAt ? null : 'readed-notification');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: const Text(
            'Detail Notifikasi',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
        ),
        body: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            switch (state.detailStatus) {
              case DetailStatus.error:
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: BaseHandleState(
                      handleType: HandleType.error,
                      errorMessage: state.detailError ?? '',
                      onRefetch: () {
                        context
                            .read<NotificationCubit>()
                            .refetchDetailNotification(
                              notificationUuid: widget.notificationUuid,
                            );
                      },
                    ),
                  ),
                );
              case DetailStatus.success:
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Material(
                          elevation: 1,
                          color: Colors.white,
                          clipBehavior: Clip.antiAlias,
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        state.detailNotification?.data?.title ??
                                            '',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      '#${state.detailNotification?.numbering}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  state.detailNotification?.data?.body ?? '',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(
                                      MingCute.clock_2_fill,
                                      size: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 2),
                                    Flexible(
                                      child: Text(
                                        AppHelpers.dmyhmDateFormat(
                                          state.detailNotification?.createdAt ??
                                              DateTime(0000),
                                        ),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SafeArea(
                        top: false,
                        child: SizedBox(
                          width: double.infinity,
                          child: Material(
                            elevation: 1,
                            color: Colors.white,
                            clipBehavior: Clip.antiAlias,
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Data SPM',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'No. Resi :',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    state
                                            .detailNotification
                                            ?.data
                                            ?.data
                                            ?.receiptNumber ??
                                        '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Jenis Pelayanan :',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    AppHelpers.serviceTypeIndonesian(
                                      state
                                              .detailNotification
                                              ?.data
                                              ?.data
                                              ?.type ??
                                          '',
                                    ),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Tanggal Lapor :',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    AppHelpers.dmyhmDateFormat(
                                      state
                                              .detailNotification
                                              ?.data
                                              ?.data
                                              ?.date ??
                                          DateTime(0000),
                                    ),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Tanggal Dibuat :',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    AppHelpers.dmyhmDateFormat(
                                      state
                                              .detailNotification
                                              ?.data
                                              ?.data
                                              ?.createdAt ??
                                          DateTime(0000),
                                    ),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Divider(
                                      height: 1,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  BaseButton(
                                    width: double.infinity,
                                    label: 'Detail SPM',
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        DetailSpmPage.routeName,
                                        arguments: state
                                            .detailNotification
                                            ?.data
                                            ?.data
                                            ?.uuid,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              default:
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
            }
          },
        ),
      ),
    );
  }
}
