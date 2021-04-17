import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/services/database_services/tournament_provider.dart';
import 'package:peaman/viewmodels/app_vm.dart';
import 'package:provider/provider.dart';

class MatchUpVm extends ChangeNotifier {
  final BuildContext context;
  MatchUpVm(this.context);

  Tournament _thisTournament;
  Tournament get thisTournament => _thisTournament;
  final _ref = FirebaseFirestore.instance;

  // init function
  onInit(final Tournament tournament) {
    if (tournament != null) {
      updateThisTournament(tournament);
    }
  }

  // start round
  startRound(final int roundToStart, final List<String> users,
      final List<String> teamIds) async {
    final _appVm = Provider.of<AppVm>(context, listen: false);
    final _tournament = _thisTournament.copyWith(
      activeRound: roundToStart,
    );
    updateThisTournament(_tournament);
    _appVm.updateSelectedTournament(_tournament);
    final _result =
        await TournamentProvider(tournament: _tournament).updateTournament();

    if (_result != null) {
      final _triggerRef = _ref.collection('round_start_triggers').doc();
      final _data = {
        'id': _triggerRef.id,
        'tournament_id': _tournament.id,
        'tournament_title': _tournament.title,
        'round': roundToStart,
        'users': users,
      };
      await TournamentProvider(tournament: _tournament).trigger(
        _triggerRef,
        _data,
      );

      for (final teamId in teamIds) {
        await TournamentProvider(tournament: _tournament).sendUpdate(
          teamId,
          'Congrats! Your team is selected for Round: $roundToStart',
        );
      }
    }
  }

  // update value of this tournament
  updateThisTournament(final Tournament newVal) {
    _thisTournament = newVal;
    notifyListeners();
  }
}
