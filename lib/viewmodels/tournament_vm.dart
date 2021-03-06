import 'package:flutter/material.dart';
import 'package:peaman/helpers/dialog_provider.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/services/database_services/tournament_provider.dart';
import 'package:peaman/views/screens/create_tournament_screen.dart';

class TournamentVm extends ChangeNotifier {
  final BuildContext context;
  TournamentVm(this.context);

  // delete tournament
  deleteTournament(final Tournament tournament) async {
    DialogProvider(context).showConfirmationDialog(
      'Are you sure you want to delete this tournament ?',
      () async {
        Navigator.pop(context);
        await TournamentProvider(tournament: tournament).deleteTournament();
      },
    );
  }

  // update tournament
  updateTournament(final Tournament tournament) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateTournamentScreen(tournament: tournament),
      ),
    );
  }
}
