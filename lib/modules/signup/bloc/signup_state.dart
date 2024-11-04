part of 'signup_bloc.dart';

sealed class SignupState {}

final class SignupInitialState extends SignupState {}

final class SignupLoadingState extends SignupState {}

final class SignupErrorState extends SignupState {
  final String message;

  SignupErrorState(this.message);
}

final class SignupSuccessState extends SignupState {}
