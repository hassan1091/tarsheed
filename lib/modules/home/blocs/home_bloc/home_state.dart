part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Device> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeLoadingState extends HomeState {}

final class HomeErrorState extends HomeState {
  final String message;

  const HomeErrorState(this.message);
}

final class HomeSuccessState extends HomeState {
  final List<Device> devices;

  const HomeSuccessState({required this.devices});

  @override
  List<Device> get props => devices;
}
