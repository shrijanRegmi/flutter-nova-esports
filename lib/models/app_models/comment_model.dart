import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peaman/models/app_models/user_model.dart';

class Comment {
  final String id;
  final AppUser user;
  final DocumentReference userRef;
  final String comment;
  final int updatedAt;

  Comment({this.id, this.user, this.userRef, this.comment, this.updatedAt});

  Comment copyWith({
    final String id,
    final AppUser user,
    final DocumentReference userRef,
    final String comment,
    final int updatedAt,
  }) {
    return Comment(
      id: id ?? this.id,
      user: user ?? this.user,
      userRef: userRef ?? this.userRef,
      comment: comment ?? this.comment,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static Comment fromJson(final Map<String, dynamic> data, final AppUser user) {
    return Comment(
      id: data['id'],
      user: user,
      userRef: data['user_ref'],
      comment: data['comment'] ?? '',
      updatedAt: data['updated_at'] ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_ref': userRef,
      'comment': comment,
      'updated_at': updatedAt,
    };
  }
}
