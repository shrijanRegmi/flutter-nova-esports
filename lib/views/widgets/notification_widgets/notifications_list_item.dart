import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/notification_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/notif_provider.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsListItem extends StatelessWidget {
  final Notifications notification;
  NotificationsListItem(this.notification);

  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider<NotificationItemVm>(
      vm: NotificationItemVm(context),
      builder: (context, vm, appVm, appUser) {
        return _notifBuilder(vm, appUser);
      },
    );
  }

  Widget _notifBuilder(
    final NotificationItemVm vm,
    final AppUser appUser,
  ) {
    return ListTile(
      onTap: () => vm.onPressedNotifItem(notification, appUser),
      tileColor: notification.isRead ? null : Colors.blue.withOpacity(0.1),
      leading: Icon(
        Icons.campaign,
        color: Colors.grey,
        size: 30.0,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${notification.notifTitle}',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${notification.notifBody}',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
              fontFamily: 'Nunito',
            ),
          ),
          Text(
            timeago.format(
                DateTime.fromMillisecondsSinceEpoch(notification.updatedAt)),
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationItemVm extends ChangeNotifier {
  final BuildContext context;
  NotificationItemVm(this.context);

  // on pressed notification item
  onPressedNotifItem(final Notifications notification, final AppUser appUser) {
    NotificationProvider(appUser: appUser, notification: notification)
        .readNotification();
    NotificationProvider(context: context, notification: notification)
        .navigateToTournamentView(notification.extraId);
  }
}
