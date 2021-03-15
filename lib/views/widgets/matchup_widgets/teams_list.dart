import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/team_model.dart';
import 'package:peaman/views/widgets/matchup_widgets/teams_list_item.dart';

class TeamsList extends StatelessWidget {
  final List<Team> teams;
  final Team myTeam;
  TeamsList(this.teams, this.myTeam);

  @override
  Widget build(BuildContext context) {
    return teams.isEmpty
        ? _emptyUpdatesBuilder()
        : ListView.separated(
            itemCount: teams.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return TeamsListItem(
                teams[index],
                isMyTeam: myTeam.id == teams[index].id,
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                height: 1.0,
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
