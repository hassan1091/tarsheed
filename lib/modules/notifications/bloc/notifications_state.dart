part of 'notifications_bloc.dart';

sealed class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Notification> get props => [];
}

final class NotificationsInitial extends NotificationsState {}

final class NotificationsLoadingState extends NotificationsState {}

final class NotificationsErrorState extends NotificationsState {
  final String message;

  const NotificationsErrorState(this.message);
}

final class NotificationsSuccessState extends NotificationsState {
  final List<Notification> devices;

  const NotificationsSuccessState({required this.devices});

  @override
  List<Notification> get props => devices;
}
