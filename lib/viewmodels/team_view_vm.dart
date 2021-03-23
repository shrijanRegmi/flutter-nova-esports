import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/services/database_services/tournament_provider.dart';

class TeamViewVm extends ChangeNotifier {
  final BuildContext context;
  TeamViewVm(this.context);

  TextEditingController _roomKeyController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  TextEditingController get roomKeyController => _roomKeyController;
  GlobalKey<ScaffoldState> get scaffoldkey => _scaffoldkey;

  // init function
  onInit(final Tournament tournament, final int index) {
    _initializeValues(tournament, index);
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

  // initialize values
  _initializeValues(final Tournament tournament, final int index) {
    final _roomKeys = tournament.roomKeys;
    _roomKeyController.text = _roomKeys['$index'];

    notifyListeners();
  }
}
