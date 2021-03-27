import 'dart:io';

import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/user_model.dart';

class UserViewVm extends ChangeNotifier {
  final BuildContext context;
  UserViewVm(this.context);

  TextEditingController _nameController = TextEditingController();
  TextEditingController _inGameIdController = TextEditingController();
  TextEditingController _inGameNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  File _photo;

  File get photo => _photo;
  TextEditingController get nameController => _nameController;
  TextEditingController get addressController => _addressController;
  TextEditingController get inGameNameController => _inGameNameController;
  TextEditingController get inGameIdController => _inGameIdController;
  TextEditingController get emailController => _emailController;
  TextEditingController get phoneController => _phoneController;

  // init function
  onInit(final AppUser appUser) {
    if (appUser != null) {
      _initializeValues(appUser);
    }
  }

  // initialize values
  _initializeValues(final AppUser appUser) {
    _nameController.text = appUser.name ?? 'N/A';
    _addressController.text = appUser.address ?? 'N/A';
    _inGameNameController.text = appUser.inGameName ?? 'N/A';
    _inGameIdController.text = appUser.inGameId ?? 'N/A';
    _emailController.text = appUser.email ?? 'N/A';
    _phoneController.text = appUser.phone ?? 'N/A';
    if (appUser.photoUrl != null) _photo = File(appUser.photoUrl);

    notifyListeners();
  }
}
