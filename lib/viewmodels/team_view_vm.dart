import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peaman/models/app_models/team_model.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/services/database_services/tournament_provider.dart';

class TeamViewVm extends ChangeNotifier {
  final BuildContext context;
  TeamViewVm(this.context);

  TextEditingController _roomKeyController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  bool _isCheckBox = false;
  List<Team> _selectedWinners = [];

  TextEditingController get roomKeyController => _roomKeyController;
  GlobalKey<ScaffoldState> get scaffoldkey => _scaffoldkey;
  bool get isCheckBox => _isCheckBox;
  List<Team> get selectedWinners => _selectedWinners;

  // init function
  onInit(final Tournament tournament, final int index) {
    _initializeValues(tournament, index);
  }

  // initialize values
  _initializeValues(final Tournament tournament, final int index) {
    final _roomKeys = tournament.roomKeys;
    _roomKeyController.text = _roomKeys['$index'];

    notifyListeners();
  }

  // save room key
  saveRoomKey(final Tournament tournament, final int index) async {
    if (_roomKeyController.text.trim() != '') {
      FocusScope.of(context).unfocus();
      final _roomKeys = tournament.roomKeys;
      _roomKeys['$index'] = _roomKeyController.text.trim();

      final _tournament = tournament.copyWith(
        roomKey: _roomKeys,
      );
      await TournamentProvider(tournament: _tournament).releaseRoomKey();
      _scaffoldkey.currentState.showSnackBar(
        SnackBar(
          content: Text('Successfully saved room key.'),
        ),
      );
    }
  }

  // copy room key
  copyRoomKey() async {
    await Clipboard.setData(
      ClipboardData(
        text: _roomKeyController.text.trim(),
      ),
    );
    _scaffoldkey.currentState.showSnackBar(
      SnackBar(
        content: Text('Coppied to clipboard.'),
      ),
    );
  }

  // select winners for next round
  selectLobbyWinners(final Tournament tournament) async {
    if (_selectedWinners.isNotEmpty) {
      final _result = await TournamentProvider(tournament: tournament)
          .selectLobbyWinners(_selectedWinners);
      if (_result != null) {
        updateIsCheckBox(false);
        _scaffoldkey.currentState.showSnackBar(
          SnackBar(
            content: Text(
              'Selected teams are registered in Round-${tournament.activeRound + 1}',
            ),
          ),
        );
      }
    } else {
      _scaffoldkey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please select at least 1 team'),
        ),
      );
    }
  }

  // update value of checkbox
  updateIsCheckBox(final bool newVal) {
    _isCheckBox = newVal;
    notifyListeners();
  }

  // update value of selected winner
  updateSelectedWinner(final List<Team> newVal) {
    _selectedWinners = newVal;
    notifyListeners();
  }
}
