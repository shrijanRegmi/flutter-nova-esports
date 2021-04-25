import 'package:flutter/material.dart';
import 'package:peaman/helpers/dialog_provider.dart';
import 'package:peaman/models/app_models/team_model.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/tournament_provider.dart';
import 'package:peaman/services/database_services/user_provider.dart';

class AddTeamVm extends ChangeNotifier {
  final BuildContext context;
  AddTeamVm(this.context);

  TextEditingController _teamNameController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  List<AppUser> _players = [];
  bool _isLoading = false;

  TextEditingController get teamNameController => _teamNameController;
  TextEditingController get searchController => _searchController;
  List<AppUser> get players => _players;
  bool get isLoading => _isLoading;

  // get user
  searchUser() {
    DialogProvider(context).showAdminSearchDialog(
      _searchController,
      () async {
        if (_searchController.text.trim() != '') {
          final _searchedUser =
              await AppUserProvider().searchedUser(_searchController);
          if (_searchedUser != null) {
            _players.add(_searchedUser);
            updatePlayers(_players);
          }
        }
      },
    );
  }

  // update value of players
  updatePlayers(final List<AppUser> newVal) {
    _players = newVal;

    notifyListeners();
  }

  // add team
  addTeam(final Tournament tournament) async {
    if (_players.isNotEmpty && _teamNameController.text.trim() != '') {
      _isLoading = true;
      notifyListeners();

      final _team = Team(
        users: _players,
        userIds: _players.map((e) => e.uid).toList(),
        teamName: _teamNameController.text.trim(),
      );
      final _result =
          await TournamentProvider(tournament: tournament, team: _team)
              .addWildCardTeam(_players);
      if (_result == null) {
        _isLoading = false;
        notifyListeners();
      } else {
        Navigator.pop(context);
      }
    }
  }
}
