import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peaman/helpers/dialog_provider.dart';
import 'package:peaman/models/app_models/level_model.dart';
import 'package:peaman/services/database_services/game_provider.dart';
import 'package:peaman/services/storage_services/game_storage_service.dart';

class CreateLevelVm extends ChangeNotifier {
  final BuildContext context;
  CreateLevelVm(this.context);

  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _difficultyController = TextEditingController();
  bool _numColorWhite = false;
  File _img;
  bool _isLoading = false;
  Level _existingLevel;

  TextEditingController get levelController => _levelController;
  TextEditingController get difficultyController => _difficultyController;
  bool get numColorWhite => _numColorWhite;
  File get img => _img;
  bool get isLoading => _isLoading;

  // init function
  onInit(final Level level) {
    if (level != null) {
      _initializeValues(level);
    }
  }

  // initialize values
  _initializeValues(final Level level) {
    _levelController.text = '${level.level}';
    _difficultyController.text = '${level.difficulty}';
    _img = File(level.imgUrl);
    _existingLevel = level;
    notifyListeners();
  }

  // update value of _isLoading
  updateIsLoading(final bool newVal) {
    _isLoading = newVal;
    notifyListeners();
  }

  // update value of numColorWhite
  updateNumColorWhite(final bool newVal) {
    _numColorWhite = newVal;

    notifyListeners();
  }

  // get image from gallery
  getImgFromGallery() async {
    final _pickedImg =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (_pickedImg != null) {
      _img = File(_pickedImg.path);
      notifyListeners();
    }
  }

  // create level
  createLevel() async {
    if (_levelController.text.trim() != '' &&
        _difficultyController.text.trim() != '' &&
        _img != null) {
      updateIsLoading(true);

      final _imgUrl = _img.path.contains('.com')
          ? _img.path
          : await GameStorage().uploadLevelImg(imgFile: _img);
      final _level = Level(
        id: _existingLevel?.id,
        level: int.parse(_levelController.text.trim()),
        difficulty: int.parse(_difficultyController.text.trim()),
        imgUrl: _imgUrl,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        numColorWhite: _numColorWhite,
      );

      var _result;
      if (_existingLevel == null) {
        _result = await GameProvider(level: _level).createLevel();
      } else {
        _result = await GameProvider(level: _level).updateLevel();
      }

      if (_result == null) {
        updateIsLoading(false);
      } else {
        Navigator.pop(context);
      }
    } else {
      DialogProvider(context).showWarningDialog(
        'Fill up all the data',
        'Please make sure you have entered the level, difficulty and have selected an image.',
        () {},
      );
    }
  }
}
