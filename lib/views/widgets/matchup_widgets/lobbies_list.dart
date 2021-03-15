import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/team_model.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/services/database_services/tournament_provider.dart';
import 'package:peaman/views/widgets/matchup_widgets/lobbies_list_item.dart';

class LobbiesList extends StatelessWidget {
  final Tournament tournament;
  final Team team;
  LobbiesList(this.tournament, this.team);

  @override
  Widget build(BuildContext context) {
    final _teamsInALobby = 12;

    return StreamBuilder<List<Team>>(
      stream: TournamentProvider(tournament: tournament).tournamentTeamsList,
      builder: (context, snap) {
        if (snap.hasData) {
          final _teams = snap.data ?? [];
          return _teams.isEmpty
              ? _emptyUpdatesBuilder()
              : ListView.separated(
                  itemCount: _teams.length % _teamsInALobby == 0
                      ? _teams.length ~/ _teamsInALobby
                      : (_teams.length ~/ _teamsInALobby) + 1,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final _start = _teamsInALobby * index;
                    final _end = _teamsInALobby * (index + 1);
                    return LobbiesListItem(
                        index,
                        _teams.length < _end
                            ? _teams.sublist(_start)
                            : _teams.sublist(_start, _end),
                        // _teams,
                        team);
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 1.0,
                    );
                  },
                );
        }
        return Center(
          child: Column(
            children: [
              SizedBox(
                height: 100.0,
              ),
              CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
  }

  Widget _emptyUpdatesBuilder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100.0,
          ),
          Text(
            'No lobbies to show',
            style: TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
