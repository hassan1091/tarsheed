part of 'routines_bloc.dart';

sealed class RoutinesState extends Equatable {
  const RoutinesState();

  @override
  List<Routine> get props => [];
}

final class RoutinesInitial extends RoutinesState {}

final class RoutinesLoadingState extends RoutinesState {}

final class RoutinesErrorState extends RoutinesState {
  final String message;

  const RoutinesErrorState(this.message);
}

final class RoutinesSuccessState extends RoutinesState {
  final List<Routine> devices;

  const RoutinesSuccessState({required this.devices});

  @override
  List<Routine> get props => devices;
}
