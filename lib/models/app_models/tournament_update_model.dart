class TournamentUpdate {
  final String id;
  final String message;
  final int updatedAt;

  TournamentUpdate({
    this.id,
    this.message,
    this.updatedAt,
  });

  TournamentUpdate copyWith({
    final String id,
    final String message,
    final int updatedAt,
  }) {
    return TournamentUpdate(
      id: id ?? this.id,
      message: message ?? this.message,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'updated_at': updatedAt,
    };
  }

  static TournamentUpdate fromJson(final Map<String, dynamic> data) {
    return TournamentUpdate(
      id: data['id'],
      message: data['message'],
      updatedAt: data['updated_at'],
    );
  }
}
