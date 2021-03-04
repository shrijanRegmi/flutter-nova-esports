import 'package:peaman/models/app_models/user_model.dart';

class FollowRequest {
  final String id;
  final AppUser sender;
  final int updatedAt;
  final bool isAccepted;

  FollowRequest({
    this.id,
    this.sender,
    this.updatedAt,
    this.isAccepted,
  });

  static FollowRequest fromJson(
      final Map<String, dynamic> data, final String id) {
    return FollowRequest(
      id: id,
      sender: AppUser.fromJson(data['user_data']),
      updatedAt: data['updated_at'],
      isAccepted: data['is_accepted'] ?? false,
    );
  }
}
