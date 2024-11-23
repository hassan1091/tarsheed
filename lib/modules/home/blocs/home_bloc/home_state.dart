part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Device> get props => [];

  Periodic get periodic => Periodic.monthly;
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

final class ReportPeriodicChangeState extends HomeState {
  final Periodic currentPeriodic;
  final List<Device> devices;


  const ReportPeriodicChangeState(this.currentPeriodic, this.devices);

  @override
  Periodic get periodic => currentPeriodic;

  @override
  List<Device> get props => devices;
}

final class ReportPeriodicChangedState extends HomeState {
  final Periodic currentPeriodic;
  final List<Device> devices;


  const ReportPeriodicChangedState(this.currentPeriodic, this.devices);

  @override
  Periodic get periodic => currentPeriodic;

  @override
  List<Device> get props => devices;
}
