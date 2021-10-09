import 'package:flutter/material.dart';
import 'package:peaman/helpers/dialog_provider.dart';
import 'package:peaman/models/app_models/lobby_notification_model.dart';
import 'package:peaman/models/app_models/team_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/tournament_provider.dart';
import 'package:peaman/viewmodels/app_vm.dart';
import 'package:peaman/viewmodels/lobby_notification_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:peaman/views/widgets/create_tournament_widgets/new_tournament_field.dart';
import 'package:timeago/timeago.dart' as timeago;

class LobbyNotificationScreen extends StatefulWidget {
  final int lobby;
  final List<Team> teams;

  LobbyNotificationScreen(this.lobby, this.teams);
  @override
  _LobbyNotificationScreenState createState() =>
      _LobbyNotificationScreenState();
}

class _LobbyNotificationScreenState extends State<LobbyNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider<LobbyNotificationVm>(
      vm: LobbyNotificationVm(),
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          key: vm.scaffoldKey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: CommonAppbar(
              title: Text(
                'Lobby ${widget.lobby} Notifications',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Color(0xff3D4A5A),
                ),
              ),
            ),
          ),
          body: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 20.0,
                ),
                _sendNotifBuilder(appVm, vm, appUser),
                SizedBox(
                  height: 10.0,
                ),
                Expanded(child: _lobbyNotificationListBuilder(appVm)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sendNotifBuilder(
    final AppVm appVm,
    final LobbyNotificationVm vm,
    final AppUser appUser,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          NewTournamentField(
            hintText: 'Noification text',
            controller: vm.textController,
            requiredCapitalization: false,
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  vm.sendLobbyNotification(
                    appVm.selectedTournament.id,
                    appUser,
                    widget.lobby,
                    widget.teams,
                  );
                },
                color: Color(0xff5C49E0),
                child: Text(
                  'Send',
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

  Widget _lobbyNotificationListBuilder(final AppVm appVm) {
    return StreamBuilder<List<LobbyNotification>>(
      stream: TournamentProvider(
        tournament: appVm.selectedTournament,
        lobby: widget.lobby,
      ).lobbyNotificationsList,
      builder: (context, snap) {
        if (snap.hasData) {
          final _lobbyNotifs = snap.data ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Text(
                  'Tap on the notification to see sender details',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black38,
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final _lobbyNotif = _lobbyNotifs[index];
                    return ListTile(
                      onTap: () {
                        DialogProvider(context).showWarningDialog(
                          'User Details',
                          'Username: ${_lobbyNotif.sender.name}\nIn-game name: ${_lobbyNotif.sender.inGameName}\nIn-game id: ${_lobbyNotif.sender.inGameId}',
                          () {},
                        );
                      },
                      leading: Icon(
                        Icons.campaign,
                        color: Colors.grey,
                        size: 30.0,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_lobbyNotif.message}',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            timeago.format(DateTime.fromMillisecondsSinceEpoch(
                              _lobbyNotif.updatedAt,
                            )),
                            style: TextStyle(
                              fontSize: 10.0,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemCount: _lobbyNotifs.length,
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
