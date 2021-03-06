import 'package:peaman/enums/match_type.dart';

class Tournament {
  final String imgUrl;
  final String title;
  final MatchType type;
  final int date;
  final String entryCost;
  final int maxPlayers;
  final int joinedPlayers;
  final bool isRegistered;

  Tournament({
    this.imgUrl,
    this.title,
    this.type,
    this.date,
    this.entryCost,
    this.maxPlayers,
    this.joinedPlayers,
    this.isRegistered = false,
  });

  Tournament copyWith({
    final String imgUrl,
    final String title,
    final MatchType type,
    final int date,
    final String entryCost,
    final int maxPlayers,
    final int joinedPlayers,
    final bool isRegistered,
  }) {
    return Tournament(
      imgUrl: imgUrl ?? this.imgUrl,
      title: title ?? this.title,
      type: type ?? this.type,
      date: date ?? this.date,
      entryCost: entryCost ?? this.entryCost,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      joinedPlayers: joinedPlayers ?? this.joinedPlayers,
      isRegistered: isRegistered ?? this.isRegistered,
    );
  }

  static Tournament fromJson(final Map<String, dynamic> data) {
    return Tournament(
      imgUrl: data['img_url'],
      title: data['title'] ?? 'N/A',
      type: MatchType.values[data['type'] ?? 0],
      date: data['date'],
      entryCost: data['entry_cost'],
      maxPlayers: data['max_players'],
      joinedPlayers: data['joined_players'] ?? 0,
      isRegistered: data['is_registered'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'img_url': imgUrl,
      'title': title,
      'type': type.index,
      'date': date,
      'entry_cost': entryCost,
      'max_players': maxPlayers,
      'joined_players': joinedPlayers,
    };
  }

  String getTypeTitle(final MatchType type) {
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
}
