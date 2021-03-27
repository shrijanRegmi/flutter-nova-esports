import 'package:peaman/models/app_models/user_model.dart';

class Team {
  final String id;
  final String teamName;
  final List<AppUser> users;
  final List<String> userIds;
  final List<int> rounds;
  Team({
    this.id,
    this.teamName,
    this.users,
    this.userIds,
    this.rounds,
  });

  Team copyWith({
    final String id,
    final String teamName,
    final List<AppUser> users,
    final List<String> userIds,
    final List<int> rounds,
  }) {
    return Team(
      id: id ?? this.id,
      teamName: teamName ?? this.teamName,
      users: users ?? this.users,
      userIds: userIds ?? this.userIds,
      rounds: rounds ?? this.rounds,
    );
  }

  static Team fromJson(final Map<String, dynamic> data) {
    return Team(
      id: data['id'],
      teamName: data['team_name'],
      users: data['users'] == null
          ? []
          : List<AppUser>.from(
              data['users'].map((e) => AppUser.fromJson(e)).toList()),
      userIds:
          data['user_ids'] == null ? [] : List<String>.from(data['user_ids']),
      rounds: data['rounds'] == null ? [] : List<int>.from(data['rounds']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'team_name': teamName,
      'users': users.map((e) => e.toShortJson()).toList(),
      'user_ids': userIds,
      'rounds': [1],
    };
  }
}
