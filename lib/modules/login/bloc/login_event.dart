part of 'login_bloc.dart';

sealed class LoginEvent {}

class LoginSubmittedEvent extends LoginEvent {
  final String email;
  final String password;

  LoginSubmittedEvent({
    required this.email,
    required this.password,
  });
}
