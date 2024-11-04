import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/core/constants/custom_exceptions.dart';
import 'package:tarsheed/services/firebase/auth_firebase_service.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitialState()) {
    on<SignupSubmittedEvent>(_onSignupSubmitted);
  }

  Future<void> _onSignupSubmitted(
      SignupSubmittedEvent event, Emitter<SignupState> emit) async {
    emit(SignupLoadingState());

    try {
      await AuthFirebaseService()
          .signup(event.username, event.email, event.password);
      emit(SignupSuccessState());
    } on CustomException catch (e) {
      emit(SignupErrorState(e.message));
    } catch (e, stackTrace) {
      // Consider logging the error and stack trace for debugging purposes
      if (kDebugMode) {
        print("Unexpected error in SignupBloc: $e\n$stackTrace");
      }
      emit(SignupErrorState(
          "An unexpected error occurred. Please try again later."));
    }
  }
}
