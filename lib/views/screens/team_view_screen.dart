import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/team_model.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/team_view_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/screens/lobby_notification_screen.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:peaman/views/widgets/matchup_widgets/teams_list.dart';

class TeamViewScreen extends StatefulWidget {
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
  _TeamViewScreenState createState() => _TeamViewScreenState();
}

class _TeamViewScreenState extends State<TeamViewScreen> {
  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider<TeamViewVm>(
      vm: TeamViewVm(context),
      onInit: (vm) => vm.onInit(widget.tournament, widget.index),
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          key: vm.scaffoldkey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: CommonAppbar(
              title: Text(
                'Lobby ${widget.index}',
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
                    if (appVm.selectedTournament.activeRound == widget.round &&
                        (appUser.admin ||
                            appUser.worker ||
                            (!appUser.admin &&
                                vm.roomIdController.text.trim() != '')))
                      _roomKeyBuilder(appUser, vm),
                    if (appUser.admin ||
                        (!appUser.admin &&
                            vm.roomIdController.text.trim() != ''))
                      SizedBox(
                        height: 10.0,
                      ),
                    TeamsList(
                      teams: widget.teams,
                      myTeam: widget.myTeam,
                      round: widget.round,
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: !appUser.admin && !appUser.worker
              ? null
              : Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (appUser.admin || appUser.worker)
                        IconButton(
                          icon: Icon(
                            Icons.notifications,
                          ),
                          splashRadius: 30.0,
                          color: Colors.blue,
                          iconSize: 30.0,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LobbyNotificationScreen(
                                  widget.index,
                                  widget.teams,
                                ),
                              ),
                            );
                          },
                        ),
                      SizedBox(
                        width: 10.0,
                      ),
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
            vm.selectLobbyWinners(
              widget.tournament,
              widget.teams,
            );
        },
        borderRadius: BorderRadius.circular(100.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          color: Colors.transparent,
          child: Text(
            vm.isCheckBox ? 'Done' : 'Select Winners',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.5),
                  child: TextFormField(
                    enabled: appUser.admin || appUser.worker,
                    controller: vm.roomIdController,
                    decoration: InputDecoration(
                      hintText: 'Room ID',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.5),
                  child: TextFormField(
                    enabled: appUser.admin || appUser.worker,
                    controller: vm.roomPasswordController,
                    decoration: InputDecoration(
                      hintText: 'Room Password',
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                MaterialButton(
                  onPressed: () => appUser.admin || appUser.worker
                      ? vm.saveRoomKey(
                          widget.tournament,
                          widget.index,
                          Team().getUsersIdList(widget.teams),
                          Team().getTeamIdList(widget.teams),
                        )
                      : vm.copyRoomKey(),
                  color: Color(0xff5C49E0),
                  child: Text(
                    appUser.admin || appUser.worker ? 'Save' : 'Copy',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
