import 'package:peaman/models/app_models/user_model.dart';

class Call {
  final String id;
  final AppUser caller;
  final AppUser receiver;
  final bool hasExpired;
  final int updatedAt;
  final bool isPicked;

  Call({
    this.id,
    this.caller,
    this.receiver,
    this.hasExpired,
    this.updatedAt,
    this.isPicked,
  });

  Call copyWith({
    final String id,
    final AppUser caller,
    final AppUser receiver,
    final bool hasExpired,
    final int updatedAt,
    final bool isPicked,
  }) {
    return Call(
      id: id ?? this.id,
      caller: caller ?? this.caller,
      receiver: receiver ?? this.receiver,
      hasExpired: hasExpired ?? this.hasExpired,
      updatedAt: updatedAt ?? this.updatedAt,
      isPicked: isPicked ?? this.isPicked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'caller': caller.toFeedUser(),
      'receiver': receiver.toFeedUser(),
      'has_expired': hasExpired,
      'updated_at': updatedAt,
      'is_picked': isPicked,
    };
  }

  static Call fromJson(final Map<String, dynamic> data) {
    return Call(
      id: data['id'],
      caller: AppUser.fromJson(data['caller']),
      receiver: AppUser.fromJson(data['receiver']),
      hasExpired: data['has_expired'] ?? false,
      updatedAt: data['updated_at'],
      isPicked: data['is_picked'] ?? false,
    );
  }
}
