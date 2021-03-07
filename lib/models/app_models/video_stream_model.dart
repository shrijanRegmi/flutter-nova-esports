class VideoStream {
  final String id;
  final String link;
  final bool isLive;
  final int updatedAt;

  VideoStream({
    this.id,
    this.link,
    this.isLive,
    this.updatedAt,
  });

  VideoStream copyWith({
    final String id,
    final String link,
    final bool isLive,
    final int updatedAt,
  }) {
    return VideoStream(
      id: id,
      link: link,
      isLive: isLive,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'link': link,
      'is_live': isLive,
      'updated_at': updatedAt,
    };
  }

  static VideoStream fromJson(final Map<String, dynamic> data) {
    return VideoStream(
      id: data['id'],
      link: data['link'],
      isLive: data['is_live'] ?? false,
      updatedAt: data['updated_at'],
    );
  }
}
