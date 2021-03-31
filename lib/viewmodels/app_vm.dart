import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/tournament_model.dart';

class AppVm extends ChangeNotifier {
  final BuildContext context;
  AppVm(this.context);

  Tournament _selectedTournament;
  Tournament get selectedTournament => _selectedTournament;

  // update value of selected tournament
  updateSelectedTournament(final Tournament newVal) {
    _selectedTournament = newVal;
    notifyListeners();
  }
}
