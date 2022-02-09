import 'package:peaman/enums/match_type.dart';
import 'package:peaman/enums/tournament_type.dart';

class Tournament {
  final String id;
  final String imgUrl;
  final String title;
  final String description;
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
  final bool isLive;
  final String state;
  final int registrationStart;
  final int registrationEnd;
  final String registrationEndTime;
  final Map<String, dynamic> roomKeys;
  final int activeRound;
  final int teamsCount;

  Tournament({
    this.id,
    this.imgUrl,
    this.title,
    this.description,
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
    this.isLive,
    this.state,
    this.registrationEnd,
    this.registrationStart,
    this.registrationEndTime,
    this.roomKeys,
    this.activeRound,
    this.teamsCount,
  });

  Tournament copyWith({
    final String id,
    final String imgUrl,
    final String title,
    final String description,
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
    final bool isLive,
    final String state,
    final int registrationStart,
    final int registrationEnd,
    final String registrationEndTime,
    final Map<String, dynamic> roomKey,
    final int activeRound,
    final int teamsCount,
  }) {
    return Tournament(
      id: id ?? this.id,
      imgUrl: imgUrl ?? this.imgUrl,
      title: title ?? this.title,
      description: description ?? this.description,
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
      isLive: isLive ?? this.isLive,
      state: state ?? this.state,
      registrationStart: registrationStart ?? this.registrationStart,
      registrationEnd: registrationEnd ?? this.registrationEnd,
      registrationEndTime: registrationEndTime ?? this.registrationEndTime,
      roomKeys: roomKeys ?? this.roomKeys,
      activeRound: activeRound ?? this.activeRound,
      teamsCount: teamsCount ?? this.teamsCount,
    );
  }

  static Tournament fromJson(final Map<String, dynamic> data) {
    return Tournament(
      id: data['id'],
      imgUrl: data['img_url'],
      title: data['title'] ?? 'N/A',
      description: data['description'] ?? '',
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
      isLive: data['is_live'] ?? false,
      state: data['state'],
      registrationStart: data['registration_start'],
      registrationEnd: data['registration_end'],
      registrationEndTime: data['registration_end_time'],
      roomKeys: data['room_keys'] ?? {},
      activeRound: data['active_round'] ?? 1,
      teamsCount: data['teams_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'img_url': imgUrl,
      'title': title,
      'description': description,
      'type': type.index,
      'tournament_type': tournamentType.index,
      'date': date,
      'time': time,
      'entry_cost': entryCost,
      'max_players': maxPlayers,
      'joined_players': joinedPlayers,
      'updated_at': updatedAt,
      'state': state,
      'registration_start': registrationStart,
      'registration_end': registrationEnd,
      'registration_end_time': registrationEndTime,
      'active_round': activeRound ?? 1,
      'teams_count': teamsCount,
    };
  }

  String getMatchTypeTitle({final MatchType matchType}) {
    final _type = matchType ?? type;
    if (tournamentType == TournamentType.clashSquad)
      return 'Clash Squad';
    else
      switch (_type) {
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
      case TournamentType.state:
        return 'State';
        break;
      case TournamentType.clashSquad:
        return 'Clash Squad';
        break;
      default:
        return 'Normal';
    }
  }

  int getPlayersCount() {
    switch (type) {
      case MatchType.solo:
        return 1;
      case MatchType.duo:
        return 2;
      case MatchType.squad:
        return 4;
    }
    return 4;
  }
}
