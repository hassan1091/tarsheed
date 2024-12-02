part of 'profile_bloc.dart';

sealed class ProfileEvent {}

class ProfileSubmittedEvent extends ProfileEvent {
  final String? email;
  final String? username;

  ProfileSubmittedEvent({this.email, this.username});
}

class SaveModeToggle extends ProfileEvent {}
