import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/temporary_img_model.dart';

class TempImgVm extends ChangeNotifier {
  List<TempImage> _tempImages = [];
  List<TempImage> get tempImages => _tempImages;

  // add item to temp images list
  addItemToTempImagesList(final TempImage img) {
    _tempImages.add(img);
    notifyListeners();
  }

  // remove item from temp images list
  removeItemToTempImagesList(final TempImage img) {
    _tempImages.remove(img);
    notifyListeners();
  }
}
