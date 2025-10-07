part of 'notification_cubit.dart';

enum ListStatus { initial, loading, success, error }

enum ReadAllStatus { initial, loading, success, error }

class NotificationState extends Equatable {
  final ListStatus listStatus;
  final bool hasMoreNotification;
  final List<Notification> notifications;
  final String? listError;
  final ReadAllStatus readAllStatus;
  final Response? readAllResponse;
  final String? readAllError;

  const NotificationState({
    this.listStatus = ListStatus.initial,
    this.hasMoreNotification = true,
    this.notifications = const [],
    this.listError,
    this.readAllStatus = ReadAllStatus.initial,
    this.readAllResponse,
    this.readAllError,
  });

  NotificationState copyWith({
    ListStatus? listStatus,
    bool? hasMoreNotification,
    List<Notification>? notifications,
    String? listError,
    ReadAllStatus? readAllStatus,
    Response? readAllResponse,
    String? readAllError,
  }) {
    return NotificationState(
      listStatus: listStatus ?? this.listStatus,
      hasMoreNotification: hasMoreNotification ?? this.hasMoreNotification,
      notifications: notifications ?? this.notifications,
      listError: listError,
      readAllStatus: readAllStatus ?? this.readAllStatus,
      readAllResponse: readAllResponse,
      readAllError: readAllError,
    );
  }

  @override
  List<Object?> get props => [
    listStatus,
    hasMoreNotification,
    notifications,
    listError,
    readAllStatus,
    readAllResponse,
    readAllError,
  ];
}
