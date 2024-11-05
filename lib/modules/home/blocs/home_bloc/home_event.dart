part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  @override
  List<Device> get props => [];
}

class LoadHomeEvent extends HomeEvent {}

class ToggleSwitchEvent extends HomeEvent {
  final Device device;
  final bool value;

  ToggleSwitchEvent(this.device, this.value);
}
