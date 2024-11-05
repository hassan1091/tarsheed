part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  @override
  List<Device> get props => [];
}

class AddLinkHomeEvent extends HomeEvent {
  final String deviceId;

  AddLinkHomeEvent(this.deviceId);
}

class LoadHomeEvent extends HomeEvent {}

class ToggleSwitchEvent extends HomeEvent {
  final Device device;
  final bool value;

  ToggleSwitchEvent(this.device, this.value);
}
