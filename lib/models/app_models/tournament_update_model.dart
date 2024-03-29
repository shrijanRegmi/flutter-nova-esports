import 'package:peaman/enums/update_type.dart';
import 'package:peaman/models/app_models/user_model.dart';

class TournamentUpdate {
  final String id;
  final String message;
  final int updatedAt;
  final AppUser sender;
  final UpdateType type;
  final int lobby;

  TournamentUpdate({
    this.id,
    this.message,
    this.updatedAt,
    this.sender,
    this.type,
    this.lobby,
  });

  TournamentUpdate copyWith({
    final String id,
    final String message,
    final int updatedAt,
    final AppUser sender,
    final UpdateType type,
    final int lobby,
  }) {
    return TournamentUpdate(
      id: id ?? this.id,
      message: message ?? this.message,
      updatedAt: updatedAt ?? this.updatedAt,
      sender: sender ?? this.sender,
      type: type ?? this.type,
      lobby: lobby ?? this.lobby,
    );
  }

  Map<String, dynamic> toJson() {
    final _data = {
      'id': id,
      'message': message,
      'updated_at': updatedAt,
      'sender': sender?.toShortJson(),
      'type': type?.index,
      'lobby': lobby,
    };
    _data.removeWhere((key, value) => value == null);
    return _data;
  }

  static TournamentUpdate fromJson(final Map<String, dynamic> data) {
    return TournamentUpdate(
      id: data['id'],
      message: data['message'],
      updatedAt: data['updated_at'],
      sender: data['sender'] == null ? null : AppUser.fromJson(data['sender']),
      type: UpdateType.values[data['type'] ?? 0] ?? UpdateType.entire,
      lobby: data['lobby'],
    );
  }
}
