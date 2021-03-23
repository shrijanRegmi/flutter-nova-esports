import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/team_model.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/views/screens/team_view_screen.dart';

class LobbiesListItem extends StatelessWidget {
  final Tournament tournament;
  final List<Team> teams;
  final int index;
  final Team myTeam;
  LobbiesListItem({
    this.tournament,
    this.index,
    this.teams,
    this.myTeam,
  });

  @override
  Widget build(BuildContext context) {
    final _isMyLobby = teams.firstWhere((element) => element.id == myTeam.id,
            orElse: () => null) !=
        null;
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TeamViewScreen(
              tournament: tournament,
              index: index + 1,
              teams: teams,
              myTeam: myTeam,
            ),
          ),
        );
      },
      contentPadding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 20.0,
      ),
      leading: Icon(
        Icons.sports_esports,
        color: _isMyLobby ? Colors.green : Color(0xff3D4A5A),
      ),
      title: Text(
        'Lobby ${index + 1}',
        style: TextStyle(
          color: _isMyLobby ? Colors.green : Color(0xff3D4A5A),
          fontWeight: _isMyLobby ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 12.0,
        color: _isMyLobby ? Colors.green : Color(0xff3D4A5A),
      ),
    );
  }
}
