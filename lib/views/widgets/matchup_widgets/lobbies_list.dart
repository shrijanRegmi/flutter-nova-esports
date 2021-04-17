import 'package:flutter/material.dart';
import 'package:peaman/enums/tournament_type.dart';
import 'package:peaman/models/app_models/team_model.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/tournament_provider.dart';
import 'package:peaman/viewmodels/match_up_vm.dart';
import 'package:peaman/views/widgets/common_widgets/filled_btn.dart';
import 'package:peaman/views/widgets/matchup_widgets/lobbies_list_item.dart';
import 'package:provider/provider.dart';

class LobbiesList extends StatelessWidget {
  final MatchUpVm vm;
  final Tournament tournament;
  final Team team;
  final int round;
  LobbiesList(
    this.vm,
    this.tournament,
    this.team,
    this.round,
  );

  @override
  Widget build(BuildContext context) {
    final _teamsInALobby =
        tournament.tournamentType == TournamentType.clashSquad
            ? 2
            : 48 ~/ tournament.getPlayersCount();
    final _appUser = Provider.of<AppUser>(context);

    return Column(
      children: [
        StreamBuilder<List<Team>>(
          stream: TournamentProvider(tournament: tournament, round: round)
              .tournamentTeamsList,
          builder: (context, snap) {
            if (snap.hasData) {
              final _teams = snap.data ?? [];
              return _appUser.admin
                  ? _teams.isEmpty
                      ? _emptyUpdatesBuilder()
                      : Column(
                          children: [
                            if (_appUser.admin &&
                                tournament.activeRound != round)
                              _startRoundBuilder(_teams),
                            ListView.separated(
                              itemCount: _teams.length % _teamsInALobby == 0
                                  ? _teams.length ~/ _teamsInALobby
                                  : (_teams.length ~/ _teamsInALobby) + 1,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final _start = _teamsInALobby * index;
                                final _end = _teamsInALobby * (index + 1);
                                return LobbiesListItem(
                                  tournament: tournament,
                                  index: index,
                                  teams: _teams.length < _end
                                      ? _teams.sublist(_start)
                                      : _teams.sublist(_start, _end),
                                  myTeam: team,
                                  round: round,
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Divider(
                                  height: 1.0,
                                );
                              },
                            ),
                          ],
                        )
                  : _teams.isEmpty || tournament.activeRound < round
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
                              tournament: tournament,
                              index: index,
                              teams: _teams.length < _end
                                  ? _teams.sublist(_start)
                                  : _teams.sublist(_start, _end),
                              myTeam: team,
                              round: round,
                            );
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
        ),
      ],
    );
  }

  Widget _startRoundBuilder(final List<Team> teams) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10.0,
          ),
          FilledBtn(
            color: Colors.blue,
            title: 'Start Round $round',
            onPressed: () => vm.startRound(
              round,
              Team().getUsersIdList(teams),
              Team().getTeamIdList(teams),
            ),
          ),
        ],
      ),
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
