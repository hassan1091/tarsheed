part of 'login_bloc.dart';

sealed class LoginState {}

final class LoginInitialState extends LoginState {}

final class LoginLoadingState extends LoginState {}

final class LoginErrorState extends LoginState {
  final String message;

  LoginErrorState(this.message);
}

final class LoginSuccessState extends LoginState {}
