import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/chat_model.dart';
import 'package:peaman/models/app_models/team_model.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/tournament_provider.dart';
import 'package:peaman/views/screens/chat_convo_screen.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class TournamentViewVm extends ChangeNotifier {
  final BuildContext context;
  TournamentViewVm(this.context);

  Team _team;
  bool _isLoading = false;
  TextEditingController _teamCodeController = TextEditingController();
  Tournament _thisTournament;
  bool _isShowingDetails = false;

  Team get team => _team;
  bool get isLoading => _isLoading;
  TextEditingController get teamCodeController => _teamCodeController;
  Tournament get thisTournament => _thisTournament;
  bool get isShowingDetails => _isShowingDetails;

  // init function
  onInit(final Tournament tournament, final AppUser appUser) async {
    if (tournament != null) {
      updateTournament(tournament);
      _updateIsLoading(true);
      if (tournament.users.contains(appUser.uid)) {
        await getTeam(tournament, appUser);
        await Future.delayed(Duration(milliseconds: 1000));
      } else {
        updateIsShowingDetails(true);
        await Future.delayed(Duration(milliseconds: 2000));
      }
      _updateIsLoading(false);
    }
  }

  // get team
  getTeam(final Tournament tournament, final AppUser appUser) async {
    final _team =
        await TournamentProvider(tournament: tournament, appUser: appUser)
            .getTeam();
    _updateTeam(_team);
  }

  // share link
  shareTeamCode() async {
    await Share.share(
      '${_team.id}',
      subject: 'Here is our team code. Join my team in NOVA ESPORTS.',
    );
  }

  // join team
  joinTeam(final Tournament tournament, final AppUser appUser,
      final TournamentViewVm vm) async {
    if (_teamCodeController.text.trim() != '') {
      _updateIsLoading(true);
      await Future.delayed(Duration(milliseconds: 1300));
      final _result = await TournamentProvider(
        context: context,
        appUser: appUser,
        tournament: tournament,
      ).joinTournament(_teamCodeController.text.trim(), vm);
      if (_result == null) {
        _updateIsLoading(false);
      }
    }
  }

  // navigate to chats
  navigateToChats(final AppUser appUser) {
    final _chats = Provider.of<List<Chat>>(context, listen: false) ?? [];
    final _thisChat =
        _chats.firstWhere((chat) => chat.id == _team.id, orElse: () => null);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatConvoScreen(
          friend: null,
          chat: _thisChat,
          team: _team,
        ),
      ),
    );
  }

  // update value of team
  _updateTeam(final Team newVal) {
    _team = newVal;
    notifyListeners();
  }

  // update value of is loading
  _updateIsLoading(final bool newVal) {
    _isLoading = newVal;
    notifyListeners();
  }

  // update value of tournament
  updateTournament(final Tournament newVal) {
    _thisTournament = newVal;
    notifyListeners();
  }

  // update value of is showing details
  updateIsShowingDetails(final bool newVal) {
    _isShowingDetails = newVal;
    notifyListeners();
  }
}
