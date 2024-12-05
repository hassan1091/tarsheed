import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/models/notification.dart';
import 'package:tarsheed/services/firebase/firebase_service.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc() : super(NotificationsInitial()) {
    on<NotificationsEvent>(_onNotificationsLoad);
  }
}

List<Notification> currentDevices = [];

Future<void> _onNotificationsLoad(
    NotificationsEvent event, Emitter<NotificationsState> emit) async {
  emit(NotificationsLoadingState());
  try {
    currentDevices = await FirebaseService().getNotifications();
    emit(NotificationsSuccessState(devices: currentDevices));
  } catch (e, stackTrace) {
    // Consider logging the error and stack trace for debugging purposes
    if (kDebugMode) {
      print("Unexpected error in NotificationsBloc: $e\n$stackTrace");
    }
    emit(const NotificationsErrorState(
        "An unexpected error occurred. Please try again later."));
  }
}
