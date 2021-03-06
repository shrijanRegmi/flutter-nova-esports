import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peaman/enums/match_type.dart';
import 'package:peaman/enums/tournament_type.dart';
import 'package:peaman/helpers/date_time_helper.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/services/database_services/tournament_provider.dart';
import 'package:peaman/services/storage_services/tournament_storage.dart';

class CreateTournamentVm extends ChangeNotifier {
  final BuildContext context;
  CreateTournamentVm(this.context);

  TextEditingController _titleController = TextEditingController();
  File _dp;
  MatchType _selectedMatchType = MatchType.solo;
  TournamentType _selectedTournament = TournamentType.normal;
  TextEditingController _entryCostController = TextEditingController();
  TextEditingController _maxPlayersController = TextEditingController();
  DateTime _matchDate;
  TimeOfDay _matchTime;
  bool _isEditing = false;
  String _tournamentId;

  TextEditingController get titleController => _titleController;
  TextEditingController get entryController => _entryCostController;
  TextEditingController get maxPlayersController => _maxPlayersController;
  File get dp => _dp;
  MatchType get selectedMatchType => _selectedMatchType;
  TournamentType get selectedTournament => _selectedTournament;
  DateTime get matchDate => _matchDate;
  TimeOfDay get matchTime => _matchTime;

  // init function
  onInit(final Tournament tournament) {
    if (tournament != null) {
      _initializeTournament(tournament);
    }
  }

  // get image from gallery
  getImage() async {
    final _pickedImage = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (_pickedImage != null) {
      _dp = File(_pickedImage.path);
      notifyListeners();
    }
  }

  // update value of selectedMatchType
  updateSelectedMatchType(final MatchType newVal) {
    _selectedMatchType = newVal;
    notifyListeners();
  }

  // update value of selectedTournament
  updateSelectedTournament(final TournamentType newVal) {
    _selectedTournament = newVal;
    notifyListeners();
  }

  // open date picker
  openDatePicker() async {
    final _pickedDate = await showDatePicker(
      context: context,
      initialDate: _matchDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(
        DateTime.now().year + 10,
        DateTime.now().month,
        DateTime.now().day,
      ),
    );

    if (_pickedDate != null) {
      _matchDate = _pickedDate;
      notifyListeners();
    }
  }

  // open time picker
  openTimePicker() async {
    final _pickedTime = await showTimePicker(
      context: context,
      initialTime: _matchTime ?? TimeOfDay.fromDateTime(DateTime.now()),
    );

    if (_pickedTime != null) {
      _matchTime = _pickedTime;
      notifyListeners();
    }
  }

  // create tournament
  createTournament() async {
    final _isFormComplete = _titleController.text.trim() != '' &&
        _entryCostController.text.trim() != '' &&
        _maxPlayersController.text.trim() != '' &&
        _matchDate != null &&
        _matchTime != null;
    if (_isFormComplete) {
      String _imgUrl;

      if (_dp != null) {
        if (_dp.path.contains('.com')) {
          _imgUrl = _dp.path;
        } else {
          _imgUrl = await TournamentStorage().uploadTournamentDp(imgFile: _dp);
        }
      }

      final _tournament = Tournament(
        id: _tournamentId,
        imgUrl: _imgUrl ??
            'https://play-lh.googleusercontent.com/KxIKOXKi9bJukZCQyzilpDqHL6f7WTcXgMQFo1IaJOhd6rrTdYONMvdewqnvivauTSGL',
        title: _titleController.text.trim(),
        type: _selectedMatchType,
        tournamentType: _selectedTournament,
        date: _matchDate.millisecondsSinceEpoch,
        time: DateTimeHelper().getFormattedTime(_matchTime),
        entryCost: int.parse(_entryCostController.text.trim()),
        maxPlayers: int.parse(_maxPlayersController.text.trim()),
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );

      var _result;
      if (_isEditing) {
        _result = await TournamentProvider(tournament: _tournament)
            .updateTournament();
      } else {
        _result = await TournamentProvider(tournament: _tournament)
            .createTournament();
      }
      if (_result != null) {
        Navigator.pop(context);
      }
    }
  }

  // initialize tournament
  _initializeTournament(final Tournament tournament) async {
    _isEditing = true;
    _tournamentId = tournament.id;
    _titleController.text = tournament.title;
    _selectedMatchType = tournament.type;
    _selectedTournament = tournament.tournamentType;
    _entryCostController.text = tournament.entryCost.toString();
    _maxPlayersController.text = tournament.maxPlayers.toString();
    _matchDate = DateTime.fromMillisecondsSinceEpoch(tournament.date);
    _matchTime = TimeOfDay(
      hour: int.parse(tournament.time.substring(0, 2)),
      minute: int.parse(tournament.time.substring(5, 7)),
    );
    _dp = File(tournament.imgUrl);

    notifyListeners();
  }
}
