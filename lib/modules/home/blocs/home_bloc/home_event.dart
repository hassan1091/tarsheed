part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  @override
  List<Device> get props => [];
}

class LoadHomeEvent extends HomeEvent {}
