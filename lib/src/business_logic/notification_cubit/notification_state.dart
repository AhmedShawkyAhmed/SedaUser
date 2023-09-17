part of 'notification_cubit.dart';

@immutable
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationsGetAllLoadingState extends NotificationState {}

class NotificationsGetAllSuccessState extends NotificationState {}

class NotificationsGetAllFailureState extends NotificationState {}

class NotificationsGetSingleLoadingState extends NotificationState {}

class NotificationsGetSingleSuccessState extends NotificationState {}

class NotificationsGetSingleFailureState extends NotificationState {}

class NotificationsMarkAllAsReadLoadingState extends NotificationState {}

class NotificationsMarkAllAsReadSuccessState extends NotificationState {}

class NotificationsMarkAllAsReadFailureState extends NotificationState {}

class NotificationsMarkSingleAsReadLoadingState extends NotificationState {}

class NotificationsMarkSingleAsReadSuccessState extends NotificationState {}

class NotificationsMarkSingleAsReadFailureState extends NotificationState {}
