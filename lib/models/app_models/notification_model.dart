class Notifications {
  final String id;
  final String notifTitle;
  final String notifBody;
  final int updatedAt;
  final String extraId;
  final bool isRead;

  Notifications({
    this.id,
    this.notifTitle,
    this.notifBody,
    this.extraId,
    this.updatedAt,
    this.isRead,
  });

  Notifications copyWith({
    final String id,
    final String notifTitle,
    final String notifBody,
    final int updatedAt,
    final String extraId,
    final bool isRead,
  }) {
    return Notifications(
      id: id ?? this.id,
      notifTitle: notifTitle ?? this.notifTitle,
      notifBody: notifBody ?? this.notifBody,
      extraId: extraId ?? this.extraId,
      updatedAt: updatedAt ?? this.updatedAt,
      isRead: isRead ?? this.isRead,
    );
  }

  static Notifications fromJson(
      final Map<String, dynamic> data, final String id) {
    return Notifications(
      id: data['id'],
      notifTitle: data['notif_title'] ?? '',
      notifBody: data['notif_body'] ?? '',
      updatedAt: data['updated_at'],
      extraId: data['extra_id'],
      isRead: data['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'notif_title': notifTitle,
      'notif_body': notifBody,
      'updated_at': updatedAt,
    };
  }
}
