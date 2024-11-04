part of 'signup_bloc.dart';

sealed class SignupEvent {}

class SignupSubmittedEvent extends SignupEvent {
  final String username;
  final String email;
  final String password;

  SignupSubmittedEvent({
    required this.username,
    required this.email,
    required this.password,
  });
}
