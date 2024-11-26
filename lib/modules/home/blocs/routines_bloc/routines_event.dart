part of 'routines_bloc.dart';

sealed class RoutinesEvent extends Equatable {
  @override
  List<Routine> get props => [];
}

class LoadRoutinesEvent extends RoutinesEvent {}

class UpdateRoutinesEvent extends RoutinesEvent {
  final Routine routine;

  UpdateRoutinesEvent(this.routine);
}
