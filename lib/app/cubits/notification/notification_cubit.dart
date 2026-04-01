import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:panduan/app/models/notification.dart';
import 'package:panduan/app/repositories/notification_repository.dart';
import 'package:panduan/app/utils/app_helpers.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit(this._repository) : super(const NotificationState());

  final NotificationRepository _repository;

  int currentNotificationPage = 1;
  final Map<String, CancelToken> _cancelTokens = {};

  Future<void> fetchNotifications() async {
    final cancelToken = AppHelpers.createCancelToken(
      _cancelTokens,
      key: 'notifications',
    );

    if (currentNotificationPage == 1) {
      emit(state.copyWith(listStatus: ListStatus.loading));
    }

    try {
      final notifications = await _repository.fetchNotifications(
        page: currentNotificationPage,
        cancelToken: cancelToken,
      );
      if (notifications.length < 10) {
        emit(state.copyWith(hasMoreNotification: false));
      }

      emit(
        state.copyWith(
          listStatus: ListStatus.success,
          notifications: List.of(state.notifications)..addAll(notifications),
        ),
      );
      currentNotificationPage++;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        return;
      }

      emit(
        state.copyWith(
          listStatus: ListStatus.error,
          listError: AppHelpers.errorHandlingApiMessage(e),
        ),
      );
    }
  }

  void refetchNotifications() async {
    currentNotificationPage = 1;

    emit(
      state.copyWith(
        listStatus: ListStatus.initial,
        hasMoreNotification: true,
        notifications: const [],
        listError: null,
      ),
    );

    await fetchNotifications();
  }

  void markAsReadNotification(String id) {
    final updatedList = state.notifications.map((notification) {
      if (notification.id == id) {
        return notification.copyWith(readAt: DateTime.now());
      }

      return notification;
    }).toList();

    emit(
      state.copyWith(
        listStatus: ListStatus.success,
        notifications: updatedList,
      ),
    );
  }

  Future<void> fetchDetailNotification({String? notificationUuid}) async {
    emit(state.copyWith(detailStatus: DetailStatus.loading));

    try {
      final detailNotification = await _repository.fetchDetailNotification(
        notificationUuid: notificationUuid,
      );

      emit(
        state.copyWith(
          detailStatus: DetailStatus.success,
          detailNotification: detailNotification,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          detailStatus: DetailStatus.error,
          detailError: AppHelpers.errorHandlingApiMessage(e),
        ),
      );
    }
  }

  void refetchDetailNotification({String? notificationUuid}) async {
    emit(
      state.copyWith(
        detailStatus: DetailStatus.initial,
        detailNotification: null,
        detailError: null,
      ),
    );

    await fetchDetailNotification(notificationUuid: notificationUuid);
  }

  void readAllNotification() async {
    emit(state.copyWith(readAllStatus: ReadAllStatus.loading));

    try {
      final response = await _repository.readAllNotification();

      if (response.data['status']) {
        emit(
          state.copyWith(
            readAllStatus: ReadAllStatus.success,
            readAllResponse: response,
          ),
        );

        markAllAsReadNotification();
      } else {
        emit(
          state.copyWith(
            readAllStatus: ReadAllStatus.error,
            readAllError: response.data['message'],
          ),
        );
      }
    } on DioException catch (e) {
      if (kDebugMode) print(e.response?.data);

      emit(
        state.copyWith(
          readAllStatus: ReadAllStatus.error,
          readAllError: AppHelpers.errorHandlingApiMessage(e),
        ),
      );
    }
  }

  void markAllAsReadNotification() {
    final updatedList = state.notifications.map((notification) {
      return notification.copyWith(readAt: DateTime.now());
    }).toList();

    emit(
      state.copyWith(
        listStatus: ListStatus.success,
        notifications: updatedList,
      ),
    );
  }

  @override
  Future<void> close() {
    AppHelpers.removeAllCancelToken(_cancelTokens);
    return super.close();
  }
}
