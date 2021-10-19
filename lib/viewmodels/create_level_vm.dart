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
  File _img;
  bool _isLoading = false;

  TextEditingController get levelController => _levelController;
  TextEditingController get difficultyController => _difficultyController;
  File get img => _img;
  bool get isLoading => _isLoading;

  // update value of _isLoading
  updateIsLoading(final bool newVal) {
    _isLoading = newVal;
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

      final _imgUrl = await GameStorage().uploadLevelImg(imgFile: _img);
      final _level = Level(
        level: int.parse(_levelController.text.trim()),
        difficulty: int.parse(_difficultyController.text.trim()),
        imgUrl: _imgUrl,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
      final _result = await GameProvider(level: _level).createLevel();

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
