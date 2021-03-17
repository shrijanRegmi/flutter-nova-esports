import 'package:peaman/enums/match_type.dart';
import 'package:peaman/enums/tournament_type.dart';

class Tournament {
  final String id;
  final String imgUrl;
  final String title;
  final MatchType type;
  final TournamentType tournamentType;
  final int date;
  final String time;
  final int entryCost;
  final int maxPlayers;
  final int joinedPlayers;
  final bool isRegistered;
  final int updatedAt;
  final List<String> users;

  Tournament({
    this.id,
    this.imgUrl,
    this.title,
    this.type,
    this.tournamentType,
    this.date,
    this.time,
    this.entryCost,
    this.maxPlayers,
    this.joinedPlayers,
    this.isRegistered = false,
    this.updatedAt,
    this.users,
  });

  Tournament copyWith({
    final String id,
    final String imgUrl,
    final String title,
    final MatchType type,
    final TournamentType tournamentType,
    final int date,
    final String time,
    final int entryCost,
    final int maxPlayers,
    final int joinedPlayers,
    final bool isRegistered,
    final int updatedAt,
    final List<String> users,
  }) {
    return Tournament(
      id: id ?? this.id,
      imgUrl: imgUrl ?? this.imgUrl,
      title: title ?? this.title,
      type: type ?? this.type,
      tournamentType: tournamentType ?? this.tournamentType,
      date: date ?? this.date,
      time: time ?? this.time,
      entryCost: entryCost ?? this.entryCost,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      joinedPlayers: joinedPlayers ?? this.joinedPlayers,
      isRegistered: isRegistered ?? this.isRegistered,
      updatedAt: updatedAt ?? this.updatedAt,
      users: users ?? this.users,
    );
  }

  static Tournament fromJson(final Map<String, dynamic> data) {
    return Tournament(
      id: data['id'],
      imgUrl: data['img_url'],
      title: data['title'] ?? 'N/A',
      type: MatchType.values[data['type'] ?? 0],
      tournamentType: TournamentType.values[data['tournament_type'] ?? 0],
      date: data['date'],
      time: data['time'],
      entryCost: data['entry_cost'],
      maxPlayers: data['max_players'],
      joinedPlayers: data['joined_players'] ?? 0,
      isRegistered: data['is_registered'] ?? false,
      updatedAt: data['updated_at'],
      users: data['users'] != null ? List<String>.from(data['users']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'img_url': imgUrl,
      'title': title,
      'type': type.index,
      'tournament_type': tournamentType.index,
      'date': date,
      'time': time,
      'entry_cost': entryCost,
      'max_players': maxPlayers,
      'joined_players': joinedPlayers,
      'updated_at': updatedAt,
    };
  }

  String getMatchTypeTitle() {
    switch (type) {
      case MatchType.solo:
        return 'Solo';
        break;
      case MatchType.duo:
        return 'Duo';
        break;
      default:
        return 'Squad';
    }
  }

  String getTournamentTypeTitle(final TournamentType type) {
    switch (type) {
      case TournamentType.normal:
        return 'Normal';
        break;
      case TournamentType.private:
        return 'Private';
        break;
      default:
        return 'State';
    }
  }
}
