import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/user_provider.dart';
import 'package:peaman/services/storage_services/user_storage_service.dart';

class EditProfileVm extends ChangeNotifier {
  final BuildContext context;
  EditProfileVm(this.context);

  TextEditingController _nameController = TextEditingController();
  File _photo;
  bool _isLoading = false;

  TextEditingController get nameController => _nameController;
  File get photo => _photo;
  bool get isLoading => _isLoading;

  // init function
  onInit(final AppUser appUser) {
    if (appUser != null) {
      _initializeValues(appUser);
    }
  }

  // get photo from gallery
  getPhotoFromGallery() async {
    final _pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (_pickedImage != null) {
      _photo = File(_pickedImage.path);
      notifyListeners();
    }
  }

  // edit profile on button press
  editProfile(final AppUser appUser) async {
    if (_nameController.text.trim() != '' || _photo != null)
      updateIsLoading(true);

    String _photoUrl = _photo?.path;
    final _data = {
      'name': _nameController.text.trim(),
      'photoUrl': _photoUrl,
    };

    if (_nameController.text.trim() == '') _data.remove('name');

    if (_photo == null)
      _data.remove('photoUrl');
    else if (!_photo.path.contains('.com')) {
      _photoUrl = await UserStorage().uploadUserImage(imgFile: _photo);
      _data['photoUrl'] = _photoUrl;
    }

    if (_data.isNotEmpty) {
      final _result =
          await AppUserProvider(uid: appUser.uid).updateUserDetail(data: _data);
      if (_result != null) {
        await Future.delayed(Duration(milliseconds: 1000));
        Navigator.pop(context);
      } else {
        updateIsLoading(false);
      }
    }
  }

  // update value of is loading
  updateIsLoading(final bool newVal) {
    _isLoading = newVal;
    notifyListeners();
  }

  // initialize values
  _initializeValues(final AppUser appUser) {
    _nameController.text = appUser.name;
    if (appUser.photoUrl != null) _photo = File(appUser.photoUrl);

    notifyListeners();
  }
}
