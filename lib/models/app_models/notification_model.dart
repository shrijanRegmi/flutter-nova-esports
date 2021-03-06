import 'package:peaman/enums/notification_type.dart';
import 'package:peaman/models/app_models/user_model.dart';

class Notifications {
  final String id;
  final AppUser sender;
  final List<AppUser> reactedBy;
  final List<AppUser> commentedBy;
  final NotificationType type;
  final int updatedAt;
  final bool isAccepted;
  final bool isRead;

  Notifications({
    this.id,
    this.sender,
    this.type,
    this.updatedAt,
    this.isAccepted,
    this.reactedBy,
    this.commentedBy,
    this.isRead,
  });

  static Notifications fromJson(
      final Map<String, dynamic> data, final String id) {
    final _type = data['type'];
    if (_type == 1) {
      // final _reactedBy = List<AppUser>.from(
      //   List<Map>.from(data['reacted_by']).map((e) => AppUser.fromJson(e)),
      // );
      // return ReactNotification(
      //   id: id,
      //   reactedBy: List<AppUser>.from(_reactedBy.reversed),
      //   updatedAt: data['updated_at'],
      //   isRead: data['is_read'] ?? false,
      // );
    }
    if (_type == 2) {
      // final _commentedBy = List<AppUser>.from(
      //   List<Map>.from(data['commented_by']).map((e) => AppUser.fromJson(e)),
      // );

      // return CommentNotification(
      //   id: id,
      //   commentedBy: List<AppUser>.from(_commentedBy.reversed),
      //   updatedAt: data['updated_at'],
      //   isRead: data['is_read'] ?? false,
      // );
    }
    return null;
  }
}
