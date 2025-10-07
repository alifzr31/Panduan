import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:panduan/app/models/notification.dart';
import 'package:panduan/app/repositories/notification_repository.dart';
import 'package:panduan/app/utils/app_strings.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit(this._repository) : super(const NotificationState());

  final NotificationRepository _repository;

  int currentNotificationPage = 1;

  Future<void> fetchNotifications() async {
    if (currentNotificationPage == 1) {
      emit(state.copyWith(listStatus: ListStatus.loading));
    }

    try {
      final notifications = await _repository.fetchNotifications(
        page: currentNotificationPage,
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
      emit(
        state.copyWith(
          listStatus: ListStatus.error,
          listError: e.response?.data['message'] ?? AppStrings.errorApiMessage,
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
      } else {
        emit(
          state.copyWith(
            readAllStatus: ReadAllStatus.error,
            readAllError: response.data['message'],
          ),
        );
      }
    } on DioException catch (e) {
      emit(
        state.copyWith(
          readAllStatus: ReadAllStatus.error,
          readAllError:
              e.response?.data['message'] ?? AppStrings.errorApiMessage,
        ),
      );
    }
  }
}
