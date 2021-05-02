import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/tournament_list.dart';
import 'package:provider/provider.dart';

class RegisteredTournamentsViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _tournamentList = Provider.of<List<Tournament>>(context) ?? [];
    final _appUser = Provider.of<AppUser>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30.0),
        child: CommonAppbar(
          title: Text(
            'Registered Tournaments',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Color(0xff3D4A5A),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: TournamentList(
          _tournamentList
              .where((element) => element.users.contains(_appUser.uid))
              .toList(),
          requiredTitle: false,
        ),
      ),
    );
  }
}
