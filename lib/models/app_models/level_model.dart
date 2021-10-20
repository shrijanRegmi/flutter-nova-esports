class Level {
  final String id;
  final int level;
  final int difficulty;
  final String imgUrl;
  final int updatedAt;
  Level({
    this.id,
    this.difficulty,
    this.level,
    this.imgUrl,
    this.updatedAt,
  });

  Level copyWith({
    final String id,
    final int level,
    final int difficulty,
    final String imgUrl,
    final int updatedAt,
  }) {
    return Level(
      id: id ?? this.id,
      level: level ?? this.level,
      difficulty: difficulty ?? this.difficulty,
      imgUrl: imgUrl ?? this.imgUrl,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static Level fromJson(final Map<String, dynamic> data) {
    return Level(
      id: data['id'],
      level: data['level'] ?? 1,
      difficulty: data['difficulty'] == null
          ? 2
          : data['difficulty'] < 2
              ? 2
              : data['difficulty'] > 15
                  ? 15
                  : data['difficulty'],
      imgUrl: data['img_url'],
      updatedAt: data['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level,
      'difficulty': difficulty,
      'img_url': imgUrl,
      'updated_at': updatedAt,
    };
  }
}
