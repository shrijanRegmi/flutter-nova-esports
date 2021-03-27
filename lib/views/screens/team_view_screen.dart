import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/team_model.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/team_view_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:peaman/views/widgets/matchup_widgets/teams_list.dart';

class TeamViewScreen extends StatelessWidget {
  final Tournament tournament;
  final int index;
  final List<Team> teams;
  final Team myTeam;
  final int round;
  TeamViewScreen({
    this.tournament,
    this.index,
    this.teams,
    this.myTeam,
    this.round,
  });

  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider<TeamViewVm>(
      vm: TeamViewVm(context),
      onInit: (vm) => vm.onInit(tournament, index),
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          key: vm.scaffoldkey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: CommonAppbar(
              title: Text(
                'Lobby $index',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Color(0xff3D4A5A),
                ),
              ),
            ),
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (appUser.admin ||
                        (!appUser.admin &&
                            vm.roomKeyController.text.trim() != ''))
                      _roomKeyBuilder(appUser, vm),
                    if (appUser.admin ||
                        (!appUser.admin &&
                            vm.roomKeyController.text.trim() != ''))
                      SizedBox(
                        height: 10.0,
                      ),
                    TeamsList(
                      teams: teams,
                      myTeam: myTeam,
                      round: round,
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: !appUser.admin
              ? null
              : Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (vm.isCheckBox)
                        _cancelBtnBuilder(context, appUser, vm),
                      if (vm.isCheckBox)
                        SizedBox(
                          width: 10.0,
                        ),
                      _selectWinnersBtnBuilder(context, appUser, vm),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _selectWinnersBtnBuilder(
      final BuildContext context, final AppUser appUser, final TeamViewVm vm) {
    return Material(
      borderRadius: BorderRadius.circular(100.0),
      elevation: 2.0,
      color: Colors.blue,
      child: InkWell(
          onTap: () {
            if (!vm.isCheckBox)
              vm.updateIsCheckBox(true);
            else
              vm.selectLobbyWinners(tournament);
          },
          borderRadius: BorderRadius.circular(100.0),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            color: Colors.transparent,
            child: Text(
              vm.isCheckBox ? 'Done' : 'Select Winners',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          )),
    );
  }

  Widget _cancelBtnBuilder(
      final BuildContext context, final AppUser appUser, final TeamViewVm vm) {
    return Material(
      borderRadius: BorderRadius.circular(100.0),
      elevation: 2.0,
      color: Colors.blue,
      child: InkWell(
          onTap: () => vm.updateIsCheckBox(false),
          borderRadius: BorderRadius.circular(100.0),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            color: Colors.transparent,
            child: Text(
              'Cancel',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          )),
    );
  }

  Widget _roomKeyBuilder(final AppUser appUser, final TeamViewVm vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.0,
          ),
          Text(
            'Your Room Key'.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff3D4A5A),
              fontSize: 14.0,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6.5),
                  child: TextFormField(
                    enabled: appUser.admin,
                    controller: vm.roomKeyController,
                    decoration: InputDecoration(
                      hintText: 'Room Key',
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              MaterialButton(
                onPressed: () => appUser.admin
                    ? vm.saveRoomKey(tournament, index)
                    : vm.copyRoomKey(),
                color: Color(0xff5C49E0),
                child: Text(
                  appUser.admin ? 'Save' : 'Copy',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
