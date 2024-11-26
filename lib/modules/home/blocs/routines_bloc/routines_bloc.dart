import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:tarsheed/models/routine.dart';
import 'package:tarsheed/services/firebase/firebase_service.dart';

part 'routines_event.dart';
part 'routines_state.dart';

class RoutinesBloc extends Bloc<RoutinesEvent, RoutinesState> {
  RoutinesBloc() : super(RoutinesInitial()) {
    on<LoadRoutinesEvent>(_onRoutinesLoad);
    on<UpdateRoutinesEvent>(_onRoutinesUpdate);
  }

  List<Routine> currentRoutines = [];

  Future<void> _onRoutinesLoad(
      LoadRoutinesEvent event, Emitter<RoutinesState> emit) async {
    emit(RoutinesLoadingState());
    try {
      currentRoutines = await FirebaseService().getUserRoutines();
      emit(RoutinesSuccessState(devices: currentRoutines));
    } catch (e, stackTrace) {
      // Consider logging the error and stack trace for debugging purposes
      if (kDebugMode) {
        print("Unexpected error in RoutinesBloc: $e\n$stackTrace");
      }
      emit(const RoutinesErrorState(
          "An unexpected error occurred. Please try again later."));
    }
  }

  Future<void> _onRoutinesUpdate(
      UpdateRoutinesEvent event, Emitter<RoutinesState> emit) async {
    emit(RoutinesLoadingState());
    try {
      currentRoutines = await FirebaseService().updateRoutines(event.routine);
      emit(RoutinesSuccessState(devices: currentRoutines));
    } catch (e, stackTrace) {
      // Consider logging the error and stack trace for debugging purposes
      if (kDebugMode) {
        print("Unexpected error in RoutinesBloc: $e\n$stackTrace");
      }
      emit(const RoutinesErrorState(
          "An unexpected error occurred. Please try again later."));
    }
  }
}
