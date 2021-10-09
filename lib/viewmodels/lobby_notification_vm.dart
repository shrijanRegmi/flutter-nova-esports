import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/lobby_notification_model.dart';
import 'package:peaman/models/app_models/team_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/tournament_provider.dart';

class LobbyNotificationVm extends ChangeNotifier {
  final TextEditingController _textController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController get textController => _textController;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  // send lobby notification
  Future sendLobbyNotification(
    final String tournamentId,
    final AppUser appUser,
    final int lobby,
    final List<Team> teams,
  ) async {
    if (_textController.text.trim() != '') {
      final _message = _textController.text.trim();
      _textController.clear();
      final _lobbyNotif = LobbyNotification(
        tournamentId: tournamentId,
        lobby: lobby,
        sender: appUser,
        message: _message,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
      TournamentProvider().sendLobbyNotification(_lobbyNotif);

      for (final team in teams) {
        TournamentProvider().sendUpdate(
          team.id,
          _message,
          sender: appUser,
          lobby: lobby,
        );
      }
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Lobby notification sent successfully!'),
      ));
    }
  }
}
