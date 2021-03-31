import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/services/database_services/tournament_provider.dart';

class MatchUpVm extends ChangeNotifier {
  Tournament _thisTournament;
  Tournament get thisTournament => _thisTournament;

  // init function
  onInit(final Tournament tournament) {
    if (tournament != null) {
      updateThisTournament(tournament);
    }
  }

  // start round
  startRound(final int roundToStart) async {
    final _tournament = _thisTournament.copyWith(
      activeRound: roundToStart,
    );
    updateThisTournament(_tournament);
    await TournamentProvider(tournament: _tournament).updateTournament();
  }

  // update value of this tournament
  updateThisTournament(final Tournament newVal) {
    _thisTournament = newVal;
    notifyListeners();
  }
}
