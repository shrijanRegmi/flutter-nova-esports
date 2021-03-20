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
    };
  }

  Map<String, dynamic> toShortJson() {
    return {
      'uid': uid,
      'photoUrl': photoUrl,
      'name': name,
      'email': email,
      'phone': phone,
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
