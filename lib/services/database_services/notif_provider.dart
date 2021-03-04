import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peaman/enums/notification_type.dart';
import 'package:peaman/models/app_models/feed_model.dart';
import 'package:peaman/models/app_models/follow_request_model.dart';
import 'package:peaman/models/app_models/notification_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/app_vm.dart';
import 'package:peaman/views/screens/view_post_screen.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/feed_comments_list.dart';
import 'package:provider/provider.dart';

class NotificationProvider {
  final BuildContext context;
  final AppUser appUser;
  final Notifications notification;
  NotificationProvider({
    this.context,
    this.appUser,
    this.notification,
  });

  final _ref = FirebaseFirestore.instance;

  Future readNotification() async {
    try {
      final _notifRef =
          appUser.appUserRef.collection('notifications').doc(notification.id);
      await _notifRef.update({
        'is_read': true,
      });
      print('Success: Reading notification ${notification.id}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Reading notification ${notification.id}');
      return null;
    }
  }

  // navigate to feed
  void navigateToFeed() async {
    try {
      final _appVm = Provider.of<AppVm>(context, listen: false);
      final _existingFeedsList = _appVm.myFeeds ?? [];

      final _feed = _existingFeedsList.firstWhere(
          (element) => element.id == notification.feed.id,
          orElse: () => null);

      if (_feed != null) {
        Feed _thisFeed = _feed;

        if (notification.type == NotificationType.reaction) {
          _thisFeed = _feed.copyWith(
            reactionCount: notification.reactedBy.length == _feed.reactionCount
                ? _feed.reactionCount
                : (_feed.reactionCount ?? 0) + 1,
            reactorsPhoto: notification.reactedBy.length == _feed.reactionCount
                ? _feed.reactorsPhoto
                : [..._feed.reactorsPhoto, notification.reactedBy[0].photoUrl],
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ViewFeedScreen('View Post', _thisFeed),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FeedCommentScreen(_thisFeed),
            ),
          );
        }
      } else {
        if (notification.type == NotificationType.reaction) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ViewFeedScreen(
                'View Post',
                _feed,
                feedId: notification.feed.id,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FeedCommentScreen(
                _feed,
                feedId: notification.feed.id,
              ),
            ),
          );
        }
      }
    } catch (e) {
      print(e);
      print('Error!!!: Navigating to feed ${notification.feed.id}');
    }
  }

  // get notification from firebase
  List<Notifications> notificationFromFirebase(QuerySnapshot colSnap) {
    return colSnap.docs
        .map((doc) => Notifications.fromJson(doc.data(), doc.id))
        .toList();
  }

  // get follow requests from firebase
  List<FollowRequest> followRequestsFromFirebase(QuerySnapshot colSnap) {
    return colSnap.docs
        .map((doc) => FollowRequest.fromJson(doc.data(), doc.id))
        .toList();
  }

  // stream of notifications
  Stream<List<Notifications>> get notificationsList {
    return _ref
        .collection('users')
        .doc(appUser.uid)
        .collection('notifications')
        .orderBy('updated_at', descending: true)
        .snapshots()
        .map(notificationFromFirebase);
  }

  // stream of follow requests
  Stream<List<FollowRequest>> get followRequests {
    return _ref
        .collection('users')
        .doc(appUser.uid)
        .collection('follow_requests')
        .limit(10)
        .orderBy('updated_at', descending: true)
        .snapshots()
        .map(followRequestsFromFirebase);
  }
}
