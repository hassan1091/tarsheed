import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/models/device.dart';
import 'package:tarsheed/services/firebase/firebase_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeEvent>(_onHomeLoad);
  }

  Future<void> _onHomeLoad(LoadHomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    try {
      final List<Device> devices = await FirebaseService().getUserDevices();
      emit(HomeSuccessState(devices: devices));
    } catch (e, stackTrace) {
      // Consider logging the error and stack trace for debugging purposes
      if (kDebugMode) {
        print("Unexpected error in HomeBloc: $e\n$stackTrace");
      }
      emit(const HomeErrorState(
          "An unexpected error occurred. Please try again later."));
    }
  }
}
