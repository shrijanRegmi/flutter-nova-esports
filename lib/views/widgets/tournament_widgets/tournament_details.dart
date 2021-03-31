import 'package:flutter/material.dart';
import 'package:peaman/enums/tournament_type.dart';
import 'package:peaman/helpers/date_time_helper.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/tournament_view_vm.dart';
import 'package:peaman/views/widgets/tournament_widgets/private_tournament_password.dart';
import 'package:provider/provider.dart';

class TournamentDetails extends StatelessWidget {
  final TournamentViewVm vm;
  TournamentDetails(this.vm);

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleBuilder(),
          SizedBox(
            height: vm.team == null ? 20.0 : 10.0,
          ),
          if (_appUser.admin &&
              vm.thisTournament.tournamentType == TournamentType.private)
            PrivateTournamentPass(vm),
          if (_appUser.admin &&
              vm.thisTournament.tournamentType == TournamentType.private)
            SizedBox(
              height: 20.0,
            ),
          _registrationTimeBuilder(),
          SizedBox(
            height: 20.0,
          ),
          _tournamentDetailsBuilder(),
          SizedBox(
            height: 20.0,
          ),
          _tournamentRulesBuilder(),
          SizedBox(
            height: vm.team == null ? 80.0 : 20.0,
          ),
        ],
      ),
    );
  }

  Widget _titleBuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'DETAILS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        if (vm.team != null)
          TextButton(
            onPressed: () => vm.updateIsShowingDetails(false),
            child: Text(
              'GO BACK',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
      ],
    );
  }

  Widget _registrationTimeBuilder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'REGISTRATION PERIOD',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    '${DateTimeHelper().getFormattedDate(DateTime.fromMillisecondsSinceEpoch(vm.thisTournament.registrationStart))} - ${DateTimeHelper().getFormattedDate(DateTime.fromMillisecondsSinceEpoch(vm.thisTournament.registrationEnd))}  Upto ${vm.thisTournament.registrationEndTime}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tournamentDetailsBuilder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOURNAMENT DETAILS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Welcome to ${vm.thisTournament.title} tournament. It is a ${vm.thisTournament.getMatchTypeTitle()} tournament.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  Divider(),
                  Text(
                    'DATE :   ${DateTimeHelper().getFormattedDate(DateTime.fromMillisecondsSinceEpoch(vm.thisTournament.date))}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    'ID PASS TIME :   ${vm.thisTournament.time}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    'WAITING TIME :   10 mins',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tournamentRulesBuilder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOURNAMENT RULES',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  _rulesItemBuilder(
                      '1. Please be respectful towards your host and other participant. If any malicious behaviour is reported, you will be removed from the tournament.'),
                  _rulesItemBuilder(
                      '2. Please be on time for your registration and for the actual tournament. Your team will be disqualified on no-show.'),
                  _rulesItemBuilder(
                      '3. You and all of your teammates must be registered to qualify for the event.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rulesItemBuilder(final String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Text(
        '$title',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
        ),
      ),
    );
  }
}
