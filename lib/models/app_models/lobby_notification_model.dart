import 'package:peaman/models/app_models/user_model.dart';

class LobbyNotification {
  final String id;
  final String tournamentId;
  final int lobby;
  final AppUser sender;
  final String message;
  final int updatedAt;

  LobbyNotification({
    this.id,
    this.message,
    this.updatedAt,
    this.sender,
    this.lobby,
    this.tournamentId,
  });

  LobbyNotification copyWith({
    final String id,
    final String message,
    final int updatedAt,
    final AppUser sender,
    final int lobby,
    final String tournamentId,
  }) {
    return LobbyNotification(
      id: id ?? this.id,
      message: message ?? this.message,
      updatedAt: updatedAt ?? this.updatedAt,
      sender: sender ?? this.sender,
      lobby: lobby ?? this.lobby,
      tournamentId: tournamentId ?? this.tournamentId,
    );
  }

  Map<String, dynamic> toJson() {
    final _data = {
      'id': id,
      'message': message,
      'updated_at': updatedAt,
      'sender': sender?.toShortJson(),
      'lobby': lobby,
      'tournament_id': tournamentId,
    };
    _data.removeWhere((key, value) => value == null);
    return _data;
  }

  static LobbyNotification fromJson(final Map<String, dynamic> data) {
    return LobbyNotification(
      id: data['id'],
      message: data['message'],
      updatedAt: data['updated_at'],
      sender: data['sender'] == null ? null : AppUser.fromJson(data['sender']),
      lobby: data['lobby'],
      tournamentId: data['tournament_id'],
    );
  }
}
