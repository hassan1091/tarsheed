import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/core/constants/app_constants.dart';
import 'package:tarsheed/core/constants/custom_exceptions.dart';
import 'package:tarsheed/models/device.dart';
import 'package:tarsheed/services/firebase/firebase_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<AddLinkHomeEvent>(_onAddNewLink);
    on<LoadHomeEvent>(_onHomeLoad);
    on<ChangePeriodicEvent>(_onPeriodicChange);
    on<ToggleSwitchEvent>(_toggleSwitch);
  }

  List<Device> currentDevices = [];

  Future<void> _onAddNewLink(
      AddLinkHomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    try {
      currentDevices = await FirebaseService().addDeviceLink(event.deviceId);
      emit(HomeSuccessState(devices: currentDevices));
    } on CustomException catch (e) {
      emit(HomeErrorState(e.message));
    } catch (e, stackTrace) {
      // Consider logging the error and stack trace for debugging purposes
      if (kDebugMode) {
        print("Unexpected error in HomeBloc: $e\n$stackTrace");
      }
      emit(const HomeErrorState(
          "An unexpected error occurred. Please try again later."));
    }
  }

  Future<void> _onHomeLoad(LoadHomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    try {
      currentDevices = await FirebaseService().getUserDevices();
      emit(HomeSuccessState(devices: currentDevices));
    } catch (e, stackTrace) {
      // Consider logging the error and stack trace for debugging purposes
      if (kDebugMode) {
        print("Unexpected error in HomeBloc: $e\n$stackTrace");
      }
      emit(const HomeErrorState(
          "An unexpected error occurred. Please try again later."));
    }
  }

  Future<void> _toggleSwitch(
      ToggleSwitchEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    try {
      final List<Device> devices =
          await FirebaseService().toggleDeviceStatus(event.device, event.value);
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

  Future<void> _onPeriodicChange(
      ChangePeriodicEvent event, Emitter<HomeState> emit) async {
    emit(ReportPeriodicChangeState(event.currentPeriodic, currentDevices));
    emit(ReportPeriodicChangedState(event.currentPeriodic, currentDevices));
  }
}
