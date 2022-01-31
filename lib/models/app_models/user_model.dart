import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peaman/enums/online_status.dart';

class AppUser {
  final String photoUrl;
  final String uid;
  final String name;
  final String email;
  final String phone;
  final OnlineStatus onlineStatus;
  final DocumentReference appUserRef;
  final bool admin;
  final int coins;
  final String address;
  final String inGameName;
  final String inGameId;
  final bool worker;
  final int completedTasks;
  final int lastTaskDoneAt;
  final bool newNotif;
  final int currentLevel;

  AppUser({
    this.uid,
    this.photoUrl,
    this.name,
    this.email,
    this.onlineStatus,
    this.appUserRef,
    this.admin,
    this.phone,
    this.coins,
    this.address,
    this.inGameName,
    this.inGameId,
    this.worker,
    this.completedTasks,
    this.lastTaskDoneAt,
    this.newNotif,
    this.currentLevel,
  });

  AppUser copyWith({
    final String photoUrl,
    final String uid,
    final String name,
    final String email,
    final String phone,
    final OnlineStatus onlineStatus,
    final DocumentReference appUserRef,
    final bool admin,
    final int coins,
    final String address,
    final String inGameName,
    final String inGameId,
    final bool worker,
    final int completedTasks,
    final int lastTaskDoneAt,
    final bool newNotif,
    final int currentLevel,
  }) {
    return AppUser(
      photoUrl: photoUrl ?? this.photoUrl,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      onlineStatus: onlineStatus ?? this.onlineStatus,
      appUserRef: appUserRef ?? this.appUserRef,
      admin: admin ?? this.admin,
      coins: coins ?? this.coins,
      address: address ?? this.address,
      inGameName: inGameName ?? this.inGameName,
      inGameId: inGameId ?? this.inGameId,
      worker: worker ?? this.worker,
      completedTasks: completedTasks ?? this.completedTasks,
      lastTaskDoneAt: lastTaskDoneAt ?? this.lastTaskDoneAt,
      newNotif: newNotif ?? this.newNotif,
      currentLevel: currentLevel ?? this.currentLevel,
    );
  }

  static Map<String, dynamic> toJson(AppUser appUser) {
    return {
      'uid': appUser.uid,
      'photoUrl': appUser.photoUrl,
      'name': appUser.name,
      'email': appUser.email,
      'phone': appUser.phone,
      'address': appUser.address,
      'in_game_name': appUser.inGameName,
      'in_game_id': appUser.inGameId,
    };
  }

  Map<String, dynamic> toShortJson() {
    return {
      'uid': uid,
      'photoUrl': photoUrl,
      'name': name,
      'email': email,
      'phone': phone,
      'in_game_name': inGameName,
      'in_game_id': inGameId,
    };
  }

  static AppUser fromJson(Map<String, dynamic> data) {
    final _ref = FirebaseFirestore.instance;

    return AppUser(
      uid: data['uid'],
      photoUrl: data['photoUrl'],
      name: data['name'],
      email: data['email'],
      onlineStatus:
          data['active_status'] == 1 ? OnlineStatus.active : OnlineStatus.away,
      appUserRef: _ref.collection('users').doc(data['uid']),
      admin: data['admin'] ?? false,
      coins: data['coins'] ?? 0,
      address: data['address'] ?? '',
      inGameId: data['in_game_id'],
      inGameName: data['in_game_name'],
      worker: data['worker'] ?? false,
      completedTasks: data['completed_tasks'] ?? 0,
      lastTaskDoneAt: data['last_task_done_at'],
      newNotif: data['new_notif'] ?? false,
      phone: data['phone'] ?? 'N/A',
      currentLevel: data['current_level'] ?? 1,
    );
  }

  DocumentReference getUserRef(final String uid) {
    final _ref = FirebaseFirestore.instance;
    return _ref.collection('users').doc(uid);
  }

  Future<AppUser> fromRef(final DocumentReference userRef) async {
    final _userSnap = await userRef.get();

    if (_userSnap.exists) {
      final _userData = _userSnap.data();
      if (_userData != null) {
        return AppUser.fromJson(_userData);
      }
    }

    return null;
  }
}
