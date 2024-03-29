import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peaman/models/app_models/team_model.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/services/database_services/tournament_provider.dart';

class TeamViewVm extends ChangeNotifier {
  final BuildContext context;
  TeamViewVm(this.context);

  TextEditingController _roomIdController = TextEditingController();
  TextEditingController _roomPasswordController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  bool _isCheckBox = false;
  List<Team> _selectedWinners = [];
  List<Team> _checkedWinners = [];
  final _ref = FirebaseFirestore.instance;

  TextEditingController get roomIdController => _roomIdController;
  TextEditingController get roomPasswordController => _roomPasswordController;
  GlobalKey<ScaffoldState> get scaffoldkey => _scaffoldkey;
  bool get isCheckBox => _isCheckBox;
  List<Team> get selectedWinners => _selectedWinners;
  List<Team> get checkedWinners => _checkedWinners;

  // init function
  onInit(final Tournament tournament, final int index) {
    _initializeValues(tournament, index);
  }

  // initialize values
  _initializeValues(final Tournament tournament, final int index) {
    final _roomKeys = tournament.roomKeys;

    if (_roomKeys != null && _roomKeys.containsKey('$index')) {
      _roomIdController.text = _roomKeys['$index']['room_id'];
      _roomPasswordController.text = _roomKeys['$index']['room_password'];
    }

    notifyListeners();
  }

  // save room key
  saveRoomKey(
    final Tournament tournament,
    final int index,
    final List<String> users,
    final List<String> teamIds,
  ) async {
    FocusScope.of(context).unfocus();
    final _roomKeys = tournament.roomKeys;
    _roomKeys['$index'] = {
      'room_id': _roomIdController.text.trim(),
      'room_password': _roomPasswordController.text.trim(),
    };

    final _tournament = tournament.copyWith(
      roomKey: _roomKeys,
    );
    final _result = await TournamentProvider(tournament: _tournament)
        .releaseRoomKey(users, index);
    _scaffoldkey.currentState.showSnackBar(
      SnackBar(
        content: Text('Successfully saved room key.'),
      ),
    );

    if (_result != null) {
      if (_roomIdController.text.trim() != '' &&
          _roomPasswordController.text.trim() != '') {
        final _triggerRef = _ref.collection('room_key_triggers').doc();

        await TournamentProvider(tournament: _tournament).trigger(
          _triggerRef,
          {
            'id': _triggerRef.id,
            'tournament_id': _tournament.id,
            'tournament_title': _tournament.title,
            'room_keys': _tournament.roomKeys,
            'lobby': index,
            'users': users,
          },
        );

        for (final teamId in teamIds) {
          await TournamentProvider(tournament: _tournament).sendUpdate(
            teamId,
            'The Room ID is: ${_roomIdController.text.trim()}\nThe Room Password is: ${_roomPasswordController.text.trim()}',
          );
        }
      }
    }
  }

  // copy room key
  copyRoomKey() async {
    await Clipboard.setData(
      ClipboardData(
        text: _roomIdController.text.trim(),
      ),
    );
    _scaffoldkey.currentState.showSnackBar(
      SnackBar(
        content: Text('Coppied to clipboard.'),
      ),
    );
  }

  // select winners for next round
  selectLobbyWinners(
    final Tournament tournament,
    final List<Team> teams,
  ) async {
    if (_checkedWinners.isNotEmpty) {
      final _newWinners = _selectedWinners;
      _checkedWinners.forEach((element) {
        _newWinners.add(element);
      });
      updateSelectedWinner(_newWinners);

      final _unselectedTeams = teams
          .where((element) =>
              !_checkedWinners.map((e) => e.id).toList().contains(element.id))
          .toList();
      final _result =
          await TournamentProvider(tournament: tournament).selectLobbyWinners(
        _checkedWinners,
        _unselectedTeams,
      );

      if (_result != null) {
        updateIsCheckBox(false);
        updateCheckedWinner([]);
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

  // update value of checked winner
  updateCheckedWinner(final List<Team> newVal) {
    _checkedWinners = newVal;
    notifyListeners();
  }
}
