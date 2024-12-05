import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tarsheed/models/notification.dart' as model;
import 'package:tarsheed/modules/notifications/bloc/notifications_bloc.dart';
import 'package:tarsheed/shared/themes/app_theme.dart';
import 'package:tarsheed/shared/widgets/gradient_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<NotificationsBloc, NotificationsState>(
          listener: _notificationsListener,
          builder: (context, state) {
            List<model.Notification> notifications = state.props;
            return RefreshIndicator(
              onRefresh: () => _refresh(context),
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  model.Notification notification = notifications[index];
                  return Column(
                    children: [
                      GradientCard(
                        child: ExpansionTile(
                          shape: LinearBorder.none,
                          childrenPadding: const EdgeInsets.only(
                              bottom: 16, right: 16, left: 16),
                          title: Row(
                            children: [
                              Text(
                                "Title: ",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                notification.title ?? "",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                          subtitle: Text(
                            notification.createdAt!.toString().substring(0, 16),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.grey),
                          ),
                          children: [
                            Text(
                              notification.body ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(color: Colors.white70),
                            )
                          ],
                        ),
                      ),
                      const Gap(8)
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _notificationsListener(BuildContext context, NotificationsState state) {
    if (state is NotificationsLoadingState) {
      AppTheme.showLoadingDialog(context);
    } else if (state is NotificationsSuccessState) {
      Navigator.pop(context); // Close the loading dialog
      AppTheme.showSnackBar(context, 'Notifications loading successful!');
    } else if (state is NotificationsErrorState) {
      Navigator.pop(context); // Close the loading dialog
      AppTheme.showSnackBar(context, state.message);
    }
  }

  Future<void> _refresh(BuildContext context) async {
    context.read<NotificationsBloc>().add(LoadNotificationsEvent());
  }
}
