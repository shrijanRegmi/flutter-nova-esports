import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peaman/enums/match_type.dart';
import 'package:peaman/enums/tournament_type.dart';
import 'package:peaman/helpers/date_time_helper.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/models/app_models/video_stream_model.dart';
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
  DateTime _registrationStartDate;
  DateTime _registrationEndDate;
  TimeOfDay _registrationEndTime;
  bool _isEditing = false;
  String _tournamentId;
  TextEditingController _link1 = TextEditingController();
  TextEditingController _link2 = TextEditingController();
  TextEditingController _link3 = TextEditingController();
  bool _live1 = false;
  bool _live2 = false;
  bool _live3 = false;
  bool _isLoading = false;
  String _selectedState = 'Choose State';

  TextEditingController get titleController => _titleController;
  TextEditingController get entryController => _entryCostController;
  TextEditingController get maxPlayersController => _maxPlayersController;
  File get dp => _dp;
  MatchType get selectedMatchType => _selectedMatchType;
  TournamentType get selectedTournament => _selectedTournament;
  DateTime get matchDate => _matchDate;
  TimeOfDay get matchTime => _matchTime;
  DateTime get registrationStartDate => _registrationStartDate;
  DateTime get registrationEndDate => _registrationEndDate;
  TimeOfDay get registrationEndTime => _registrationEndTime;
  TextEditingController get link1 => _link1;
  TextEditingController get link2 => _link2;
  TextEditingController get link3 => _link3;
  bool get live1 => _live1;
  bool get live2 => _live2;
  bool get live3 => _live3;
  bool get isLoading => _isLoading;
  String get selectedState => _selectedState;

  // init function
  onInit(final Tournament tournament, final List<VideoStream> videoStreams) {
    if (tournament != null) {
      _initializeTournament(tournament);
    }

    if (videoStreams != null) {
      _initializeVideoStream(videoStreams);
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

  // update value of selectedState
  updateSelectedState(final String newVal) {
    _selectedState = newVal;
    notifyListeners();
  }

  // open date picker
  openDatePicker() async {
    final _currentDate = DateTime.now();
    final _pickedDate = await showDatePicker(
      context: context,
      initialDate: _matchDate ?? DateTime.now(),
      firstDate: _matchDate != null && _currentDate.isAfter(_matchDate)
          ? _matchDate
          : _currentDate,
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

  // open registration start date picker
  registrationStartPicker() async {
    final _currentDate = DateTime.now();
    final _pickedDate = await showDatePicker(
      context: context,
      initialDate: _registrationStartDate ?? DateTime.now(),
      firstDate: _registrationStartDate != null &&
              _currentDate.isAfter(_registrationStartDate)
          ? _registrationStartDate
          : _currentDate,
      lastDate: DateTime(
        DateTime.now().year + 10,
        DateTime.now().month,
        DateTime.now().day,
      ),
    );

    if (_pickedDate != null) {
      _registrationStartDate = _pickedDate;
      notifyListeners();
    }
  }

  // open registration end date picker
  registrationEndPicker() async {
    final _currentDate = DateTime.now();
    final _pickedDate = await showDatePicker(
      context: context,
      initialDate: _registrationEndDate ?? DateTime.now(),
      firstDate: _registrationEndDate != null &&
              _currentDate.isAfter(_registrationEndDate)
          ? _registrationEndDate
          : _currentDate,
      lastDate: DateTime(
        DateTime.now().year + 10,
        DateTime.now().month,
        DateTime.now().day,
      ),
    );

    if (_pickedDate != null) {
      _registrationEndDate = _pickedDate;
      notifyListeners();
    }
  }

  // open registration end time picker
  registrationEndTimePicker() async {
    final _pickedTime = await showTimePicker(
      context: context,
      initialTime:
          _registrationEndTime ?? TimeOfDay.fromDateTime(DateTime.now()),
    );

    if (_pickedTime != null) {
      _registrationEndTime = _pickedTime;
      notifyListeners();
    }
  }

  // create tournament
  createTournament() async {
    final _isFormComplete = _titleController.text.trim() != '' &&
        _entryCostController.text.trim() != '' &&
        _maxPlayersController.text.trim() != '' &&
        _matchDate != null &&
        _matchTime != null &&
        _registrationStartDate != null &&
        _registrationEndDate != null &&
        _registrationEndTime != null;
    if (_isFormComplete) {
      updateIsLoading(true);
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
        type: _selectedTournament == TournamentType.clashSquad
            ? MatchType.squad
            : _selectedMatchType,
        tournamentType: _selectedTournament,
        date: _matchDate.millisecondsSinceEpoch,
        time: DateTimeHelper().getFormattedTime(_matchTime),
        entryCost: int.parse(_entryCostController.text.trim()),
        maxPlayers: int.parse(_maxPlayersController.text.trim()),
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        state: _selectedState == 'Choose State' ? null : _selectedState,
        registrationStart: _registrationStartDate.millisecondsSinceEpoch,
        registrationEnd: _registrationEndDate.millisecondsSinceEpoch,
        registrationEndTime:
            DateTimeHelper().getFormattedTime(_registrationEndTime),
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
      } else {
        updateIsLoading(false);
      }
    }
  }

  // publish video stream
  publishVideoStream() async {
    updateIsLoading(true);
    if (_link1.text.trim() != '') {
      final _stream1 = VideoStream(
        id: 'stream1',
        link: _link1.text.trim(),
        isLive: _live1,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
      await TournamentProvider(videoStream: _stream1).addVideoStreams();
    } else {
      await TournamentProvider(videoStream: VideoStream(id: 'stream1'))
          .removeVideoStreams();
    }

    if (_link2.text.trim() != '') {
      final _stream2 = VideoStream(
        id: 'stream2',
        link: _link2.text.trim(),
        isLive: _live2,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
      await TournamentProvider(videoStream: _stream2).addVideoStreams();
    } else {
      await TournamentProvider(videoStream: VideoStream(id: 'stream2'))
          .removeVideoStreams();
    }

    if (_link3.text.trim() != '') {
      final _stream3 = VideoStream(
        id: 'stream3',
        link: _link3.text.trim(),
        isLive: _live3,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
      await TournamentProvider(videoStream: _stream3).addVideoStreams();
    } else {
      await TournamentProvider(videoStream: VideoStream(id: 'stream3'))
          .removeVideoStreams();
    }

    Navigator.pop(context);
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
    _registrationStartDate =
        DateTime.fromMillisecondsSinceEpoch(tournament.registrationStart);
    _registrationEndDate =
        DateTime.fromMillisecondsSinceEpoch(tournament.registrationEnd);
    _registrationEndTime = TimeOfDay(
      hour: int.parse(tournament.registrationEndTime.substring(0, 2)),
      minute: int.parse(tournament.registrationEndTime.substring(5, 7)),
    );
    _dp = File(tournament.imgUrl);

    notifyListeners();
  }

  // initialize video streams
  _initializeVideoStream(final List<VideoStream> videoStreams) {
    final _controller = <TextEditingController>[
      _link1,
      _link2,
      _link3,
    ];

    for (int i = 0; i < videoStreams.length; i++) {
      _controller[i].text = videoStreams[i].link;
      if (i == 0) {
        updateLives(newVal1: videoStreams[i].isLive);
      } else if (i == 1) {
        updateLives(newVal2: videoStreams[i].isLive);
      } else if (i == 2) {
        updateLives(newVal3: videoStreams[i].isLive);
      }
    }
    print(_live3);
  }

  // update value of lives
  updateLives({
    final bool newVal1,
    final bool newVal2,
    final bool newVal3,
  }) {
    _live1 = newVal1 ?? _live1;
    _live2 = newVal2 ?? _live2;
    _live3 = newVal3 ?? _live3;
    notifyListeners();
  }

  // update value of isloading
  updateIsLoading(final bool newVal) {
    _isLoading = newVal;

    notifyListeners();
  }
}
