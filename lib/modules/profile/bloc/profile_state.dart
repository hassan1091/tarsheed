part of 'profile_bloc.dart';

sealed class ProfileState {
  String get username => FirebaseAuth.instance.currentUser?.displayName ?? "";

  String get email => FirebaseAuth.instance.currentUser?.email ?? "";
}

final class ProfileInitialState extends ProfileState {}

final class ProfileLoadingState extends ProfileState {}

final class ProfileErrorState extends ProfileState {
  final String message;

  ProfileErrorState(this.message);
}

final class ProfileSuccessState extends ProfileState {
  final bool? isSafeMode;

  ProfileSuccessState({this.isSafeMode});
}
