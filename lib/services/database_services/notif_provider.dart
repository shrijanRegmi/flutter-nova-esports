import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/notification_model.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/views/screens/tournament_view_screen.dart';
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

  // navigate to tournament view screen
  void navigateToTournamentView(final String tournamentId) async {
    try {
      if (tournamentId != null) {
        final _tournaments =
            Provider.of<List<Tournament>>(context, listen: false);
        if (_tournaments != null) {
          final _index =
              _tournaments.indexWhere((element) => element.id == tournamentId);
          if (_index != -1) {
            final _tournament = _tournaments[_index];

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TournamentViewScreen(_tournament),
              ),
            );
          }
        }
      }
    } catch (e) {
      print(e);
      print('Error!!!: Navigating to feed $tournamentId');
    }
  }

  // send custom notif
  Future sendCustomNotif() async {
    try {
      final _notifRef = _ref.collection('custom_notifs').doc();
      final _notification = notification.copyWith(
        id: _notifRef.id,
      );
      await _notifRef.set(_notification.toJson());
      return 'Success';
    } catch (e) {
      print(e);
      return null;
    }
  }

  // get notification from firebase
  List<Notifications> notificationFromFirebase(QuerySnapshot colSnap) {
    return colSnap.docs
        .map((doc) => Notifications.fromJson(doc.data(), doc.id))
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
}
