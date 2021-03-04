import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peaman/enums/notification_type.dart';
import 'package:peaman/models/app_models/notification_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/notif_provider.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/common_widgets/multi_avatar_builder.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsListItem extends StatelessWidget {
  final Notifications notification;
  NotificationsListItem(this.notification);

  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider<NotificationItemVm>(
      vm: NotificationItemVm(context),
      builder: (context, vm, appVm, appUser) {
        Widget _widget;
        switch (notification.type) {
          case NotificationType.reaction:
            _widget = _reactNotifBuilder(vm, appUser);
            break;
          case NotificationType.comment:
            _widget = _commentNotifBuilder(vm, appUser);
            break;
          default:
            _widget = Container();
        }

        return InkWell(
          onTap: () => vm.onPressedNotifItem(notification, appUser),
          child: Container(
            color: notification.isRead
                ? Colors.transparent
                : Color(0xff3D4A5A).withOpacity(0.1),
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: _widget,
          ),
        );
      },
    );
  }

  Widget _reactNotifBuilder(
      final NotificationItemVm vm, final AppUser appUser) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: <Widget>[
              // user image
              MultiAvatarBuilder(
                users: notification.reactedBy,
              ),
              SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontFamily: 'Nunito',
                        ),
                        children: [
                          TextSpan(
                            text: notification.reactedBy.length >= 2
                                ? '${notification.reactedBy[0].name} and ${notification.reactedBy.length - 1} ${notification.reactedBy.length - 1 > 1 ? 'others' : 'other'}'
                                : '${notification.reactedBy[0].name}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' recently reacted to your post.',
                          ),
                        ],
                      ),
                    ),
                    Text(
                      timeago.format(DateTime.fromMillisecondsSinceEpoch(
                          notification.updatedAt)),
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Container(
          height: 50.0,
          width: 50.0,
          constraints: BoxConstraints(
            maxWidth: 50.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.grey[350],
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                notification.feed.photos[0],
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _commentNotifBuilder(
      final NotificationItemVm vm, final AppUser appUser) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: <Widget>[
              // user image
              MultiAvatarBuilder(
                users: notification.commentedBy,
              ),
              SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontFamily: 'Nunito',
                        ),
                        children: [
                          TextSpan(
                            text: notification.commentedBy.length >= 2
                                ? '${notification.commentedBy[0].name} and ${notification.commentedBy.length - 1} ${notification.commentedBy.length - 1 > 1 ? 'others' : 'other'} '
                                : '${notification.commentedBy[0].name}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' recently commented on your post.',
                          ),
                        ],
                      ),
                    ),
                    Text(
                      timeago.format(DateTime.fromMillisecondsSinceEpoch(
                          notification.updatedAt)),
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Container(
          height: 50.0,
          width: 50.0,
          constraints: BoxConstraints(
            maxWidth: 50.0,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[350],
            borderRadius: BorderRadius.circular(5.0),
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                notification.feed.photos[0],
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
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
        .navigateToFeed();
  }
}
