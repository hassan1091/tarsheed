import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/core/constants/custom_exceptions.dart';
import 'package:tarsheed/services/firebase/auth_firebase_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginSubmittedEvent>(_onSignupSubmitted);
  }

  Future<void> _onSignupSubmitted(
      LoginSubmittedEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());

    try {
      await AuthFirebaseService().login(event.email, event.password);
      emit(LoginSuccessState());
    } on CustomException catch (e) {
      emit(LoginErrorState(e.message));
    } catch (e, stackTrace) {
      // Consider logging the error and stack trace for debugging purposes
      if (kDebugMode) {
        print("Unexpected error in SignupBloc: $e\n$stackTrace");
      }
      emit(LoginErrorState(
          "An unexpected error occurred. Please try again later."));
    }
  }
}
