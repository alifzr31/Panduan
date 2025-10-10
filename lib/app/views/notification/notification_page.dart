import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/cubits/notification/notification_cubit.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/views/detail_notification/detailnotification_page.dart';
import 'package:panduan/app/views/notification/components/notification_card.dart';
import 'package:panduan/app/views/notification/components/notificationcard_loading.dart';
import 'package:panduan/app/widgets/base_handlestate.dart';
import 'package:panduan/app/widgets/base_loadscroll.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  static const String routeName = '/notification';

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final _scrollController = ScrollController();

  void _onScrollNotification() {
    if (_scrollController.hasClients) {
      final currentScroll = _scrollController.position.pixels;
      final maxScroll = _scrollController.position.maxScrollExtent;

      if (currentScroll == maxScroll &&
          context.read<NotificationCubit>().state.hasMoreNotification) {
        context.read<NotificationCubit>().fetchNotifications();
      }
    }
  }

  @override
  void initState() {
    context.read<NotificationCubit>().fetchNotifications().then((value) {
      _scrollController.addListener(_onScrollNotification);
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScrollNotification)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Notifikasi',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        actionsPadding: const EdgeInsets.only(right: 16),
        actions:
            context.watch<NotificationCubit>().state.listStatus ==
                    ListStatus.success &&
                context
                    .watch<NotificationCubit>()
                    .state
                    .notifications
                    .isNotEmpty &&
                context
                    .watch<NotificationCubit>()
                    .state
                    .notifications
                    .map((element) => element.readAt != null)
                    .toList()
                    .isEmpty
            ? [
                BlocListener<NotificationCubit, NotificationState>(
                  listenWhen: (previous, current) =>
                      previous.readAllStatus != current.readAllStatus,
                  listener: (context, state) {
                    if (state.readAllStatus == ReadAllStatus.success) {
                      context.read<NotificationCubit>().refetchNotifications();
                    }
                  },
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    onPressed: () {
                      context.read<NotificationCubit>().readAllNotification();
                    },
                    child: const Row(
                      children: [
                        Icon(
                          MingCute.checks_line,
                          size: 18,
                          color: AppColors.amberColor,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Tandai Baca Semua',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.amberColor,
                            fontFamily: 'Jost',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]
            : null,
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          switch (state.listStatus) {
            case ListStatus.error:
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: BaseHandleState(
                    handleType: HandleType.error,
                    errorMessage: state.listError ?? '',
                    onRefetch: () {
                      context.read<NotificationCubit>().refetchNotifications();
                    },
                  ),
                ),
              );
            case ListStatus.success:
              return state.notifications.isEmpty
                  ? BaseHandleState(
                      handleType: HandleType.empty,
                      errorMessage: 'Data Notifikasi Kosong',
                      onRefetch: () {
                        context
                            .read<NotificationCubit>()
                            .refetchNotifications();
                      },
                    )
                  : RefreshIndicator(
                      backgroundColor: Colors.white,
                      onRefresh: () async {
                        await Future.delayed(
                          const Duration(milliseconds: 2500),
                          () {
                            if (context.mounted) {
                              context
                                  .read<NotificationCubit>()
                                  .refetchNotifications();
                            }
                          },
                        );
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: state.hasMoreNotification
                            ? state.notifications.length + 1
                            : state.notifications.length,
                        itemBuilder: (context, index) {
                          return SafeArea(
                            top: false,
                            bottom: state.hasMoreNotification
                                ? index == state.notifications.length
                                      ? true
                                      : false
                                : index == state.notifications.length - 1
                                ? true
                                : false,
                            child: index >= state.notifications.length
                                ? const BaseLoadScroll()
                                : NotificationCard(
                                    title:
                                        state
                                            .notifications[index]
                                            .data
                                            ?.title ??
                                        '',
                                    description:
                                        state.notifications[index].data?.body ??
                                        '',
                                    readAt: state.notifications[index].readAt,
                                    createdAt:
                                        state.notifications[index].createdAt ??
                                        DateTime(0000),
                                    numbering:
                                        state.notifications[index].numbering ??
                                        0,
                                    index: index,
                                    dataLength: state.notifications.length,
                                    onTap: () async {
                                      final result = await Navigator.pushNamed(
                                        context,
                                        DetailNotificationPage.routeName,
                                        arguments: {
                                          'notificationCubit': context
                                              .read<NotificationCubit>(),
                                          'notificationUuid':
                                              state.notifications[index].id,
                                        },
                                      );

                                      if (result != null) {
                                        if (result == 'readed-notification') {
                                          if (context.mounted) {
                                            context
                                                .read<NotificationCubit>()
                                                .refetchNotifications();
                                          }
                                        }
                                      }
                                    },
                                  ),
                          );
                        },
                      ),
                    );
            default:
              return notificationCardLoading();
          }
        },
      ),
    );
  }
}
