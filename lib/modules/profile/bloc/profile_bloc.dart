import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/core/constants/custom_exceptions.dart';
import 'package:tarsheed/services/firebase/firebase_service.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitialState()) {
    on<ProfileSubmittedEvent>(_onSignupSubmitted);
  }

  Future<void> _onSignupSubmitted(
      ProfileSubmittedEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());

    try {
      await FirebaseService().updateUser(
        username: event.username,
        email: event.email,
      );
      emit(ProfileSuccessState());
    } on CustomException catch (e) {
      emit(ProfileErrorState(e.message));
    } catch (e, stackTrace) {
      // Consider logging the error and stack trace for debugging purposes
      if (kDebugMode) {
        print("Unexpected error in SignupBloc: $e\n$stackTrace");
      }
      emit(ProfileErrorState(
          "An unexpected error occurred. Please try again later."));
    }
  }
}
