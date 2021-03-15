import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/team_model.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:peaman/views/widgets/matchup_widgets/teams_list.dart';

class TeamViewScreen extends StatelessWidget {
  final String title;
  final List<Team> teams;
  final Team myTeam;
  TeamViewScreen(
    this.title,
    this.teams,
    this.myTeam,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: CommonAppbar(
          title: Text(
            '$title',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Color(0xff3D4A5A),
            ),
          ),
        ),
      ),
      body: TeamsList(teams, myTeam),
    );
  }
}
