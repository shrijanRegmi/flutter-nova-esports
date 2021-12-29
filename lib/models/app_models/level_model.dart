class Level {
  final String id;
  final int level;
  final int difficulty;
  final String imgUrl;
  final int updatedAt;
  final bool numColorWhite;
  Level({
    this.id,
    this.difficulty,
    this.level,
    this.imgUrl,
    this.updatedAt,
    this.numColorWhite,
  });

  Level copyWith({
    final String id,
    final int level,
    final int difficulty,
    final String imgUrl,
    final int updatedAt,
    final bool numColorWhite,
  }) {
    return Level(
      id: id ?? this.id,
      level: level ?? this.level,
      difficulty: difficulty ?? this.difficulty,
      imgUrl: imgUrl ?? this.imgUrl,
      updatedAt: updatedAt ?? this.updatedAt,
      numColorWhite: numColorWhite ?? this.numColorWhite,
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
      numColorWhite: data['num_color_white'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level,
      'difficulty': difficulty,
      'img_url': imgUrl,
      'updated_at': updatedAt,
      'num_color_white': numColorWhite,
    };
  }
}
