import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/team_model.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/tournament_provider.dart';
import 'package:peaman/viewmodels/tournament_view_vm.dart';

class RegisterVm extends ChangeNotifier {
  final BuildContext context;
  RegisterVm(this.context);
  final TextEditingController _teamNameController = TextEditingController();
  bool _isLoading = false;

  TextEditingController get teamNameController => _teamNameController;
  bool get isLoading => _isLoading;

  // register team
  registerTeam(final Tournament tournament, final AppUser appUser,
      final TournamentViewVm vm) async {
    if (_teamNameController.text.trim() != '') {
      _updateIsLoading(true);
      final _team = Team(
        users: [appUser],
        userIds: [appUser.uid],
        teamName: _teamNameController.text.trim(),
      );
      final _result = await TournamentProvider(
        tournament: tournament,
        appUser: appUser,
        team: _team,
      ).register();
      if (_result != null) {
        final _tournament = vm.thisTournament.copyWith(
          users: [...vm.thisTournament.users, appUser.uid],
        );
        vm.updateTournament(_tournament);
        vm.updateIsShowingDetails(false);
        vm.getTeam(tournament, appUser);
        Navigator.pop(context);
      } else {
        _updateIsLoading(false);
      }
    }
  }

  // update value of is loading
  _updateIsLoading(final bool newVal) {
    _isLoading = newVal;
    notifyListeners();
  }
}
