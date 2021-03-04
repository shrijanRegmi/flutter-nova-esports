import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/notification_model.dart';
import 'package:peaman/views/widgets/notification_widgets/notifications_list_item.dart';

class NotificationsList extends StatelessWidget {
  final List<Notifications> notifications;
  NotificationsList(this.notifications);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final _notification = notifications[index];

        return NotificationsListItem(_notification);
      },
    );
  }
}
