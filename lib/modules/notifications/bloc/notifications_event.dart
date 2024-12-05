part of 'notifications_bloc.dart';

sealed class NotificationsEvent extends Equatable {
  @override
  List<Notification> get props => [];
}

class LoadNotificationsEvent extends NotificationsEvent {}
