part of 'notification_bloc.dart';

sealed class NotificationEvent {
  const NotificationEvent();
}

class NotificationStatusChanged extends NotificationEvent {
  final AuthorizationStatus status;
  NotificationStatusChanged(this.status);
}
