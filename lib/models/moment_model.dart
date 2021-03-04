import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peaman/models/app_models/user_model.dart';

class Moment {
  final String id;
  final String photo;
  final AppUser owner;
  final String ownerId;
  final DocumentReference ownerRef;
  final int updatedAt;
  final int expiresAt;
  final bool isSeen;

  Moment({
    this.id,
    this.photo,
    this.owner,
    this.ownerId,
    this.ownerRef,
    this.updatedAt,
    this.expiresAt,
    this.isSeen,
  });

  Moment copyWith({
    final String id,
    final String photo,
    final AppUser owner,
    final String ownerId,
    final DocumentReference ownerRef,
    final int updatedAt,
    final bool isSeen,
  }) {
    return Moment(
      id: id ?? this.id,
      photo: photo ?? this.photo,
      owner: owner ?? this.owner,
      ownerId: ownerId ?? this.ownerId,
      ownerRef: ownerRef ?? this.ownerRef,
      updatedAt: updatedAt ?? this.updatedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isSeen: isSeen ?? this.isSeen,
    );
  }

  static Moment fromJson(final Map<String, dynamic> data) {
    return Moment(
      id: data['id'],
      photo: data['photo'],
      owner: AppUser.fromJson(data['owner']),
      ownerId: data['owner_id'],
      ownerRef: data['owner_ref'],
      updatedAt: data['updated_at'],
      expiresAt: data['expires_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'photo': photo,
      'owner_id': ownerId,
      'owner_ref': ownerRef,
      'updated_at': updatedAt,
      'expires_at': DateTime.fromMillisecondsSinceEpoch(updatedAt)
          .add(Duration(minutes: 1440))
          .millisecondsSinceEpoch,
      'owner': owner.toFeedUser(),
    };
  }
}
