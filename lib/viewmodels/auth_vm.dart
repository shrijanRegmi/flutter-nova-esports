import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peaman/enums/age.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/auth_services/auth_provider.dart';
import 'package:peaman/services/storage_services/user_storage_service.dart';

class AuthVm extends ChangeNotifier {
  final BuildContext context;
  AuthVm(this.context);

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  File _imgFile;
  bool _isNextPressed = false;
  Age _age;
  bool _keyboardVisibility = false;
  StreamSubscription _subscription;

  TextEditingController get nameController => _nameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get passController => _passController;
  TextEditingController get phoneController => _phoneController;
  bool get isLoading => _isLoading;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  File get imgFile => _imgFile;
  bool get isNextPressed => _isNextPressed;
  Age get age => _age;
  bool get keyboardVisibility => _keyboardVisibility;

  // init function
  onInit() {
    _subscription = KeyboardVisibility.onChange.listen((event) {
      _keyboardVisibility = event;
      print(event);
      notifyListeners();
    });
  }

  // dispose function
  onDispose() {
    _subscription?.cancel();
  }

  // login user with email and password;
  Future loginUser() async {
    var _result;
    _updateLoader(true);
    if (_emailController.text.trim() != '' &&
        _passController.text.trim() != '') {
      _result = await AuthProvider().loginWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passController.text.trim(),
      );
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Please fill up all fields'),
      ));
    }
    if (_result == null) {
      _updateLoader(false);
    }
    return _result;
  }

  // signup user with email and password;
  Future signUpUser() async {
    var _result;
    _updateLoader(true);
    if (_nameController.text.trim() != '' &&
        _emailController.text.trim() != '' &&
        _passController.text.trim() != '') {
      if (imgFile != null) {
        _result = await UserStorage().uploadUserImage(imgFile: imgFile);
      }

      _result = await AuthProvider().signUpWithEmailAndPassword(
        photoUrl: _result,
        age: _age,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passController.text.trim(),
      );
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Please fill up all fields'),
      ));
    }
    if (_result == null) {
      _updateLoader(false);
    }
    return _result;
  }

  // update the value of loader
  _updateLoader(final bool _newVal) {
    _isLoading = _newVal;
    notifyListeners();
  }

  // on back btn pressed
  onPressedBackBtn() {
    if (_isNextPressed) {
      _updateIsNextBtnPressed(!_isNextPressed);
    } else {
      Navigator.pop(context);
    }
  }

  // on next btn pressed
  onPressedNextBtn() {
    if (_nameController.text.trim() != '' &&
        _phoneController.text.trim() != '') {
      _updateIsNextBtnPressed(true);
    } else {
      if (_nameController.text.trim() == '') {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Please add your username !'),
          ),
        );
      } else {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Please add your phone number !'),
          ),
        );
      }
    }
  }

  // update value of isNextBtnPressed
  _updateIsNextBtnPressed(final bool _newVal) {
    _isNextPressed = _newVal;
    notifyListeners();
  }

  // update value of age
  updateAgeValue(final Age _newAge) {
    _age = _newAge;
    notifyListeners();
  }

  // upload user image
  uploadImage() async {
    final _pickedImg = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 20,
      maxHeight: 500.0,
      maxWidth: 500.0,
    );
    File _myImg = _pickedImg != null ? File(_pickedImg.path) : null;
    _imgFile = _myImg;
    notifyListeners();
  }

  // log in using google
  logInWithGoogle() async {
    _updateLoader(true);
    final _result = await AuthProvider().loginWithGoogle(_scaffoldKey);
    if (_result == null) {
      _updateLoader(false);
    }
  }

  // sign up using google
  signUpWithGoogle() async {
    _updateLoader(true);
    String _imgUrl;
    if (_imgFile != null) {
      _imgUrl = await UserStorage().uploadUserImage(imgFile: imgFile);
    }
    final _appUser = AppUser(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      photoUrl: _imgUrl,
    );
    final _result =
        await AuthProvider().signUpWithGoogle(_appUser, _scaffoldKey);
    if (_result == null) {
      _updateLoader(false);
    }
  }
}
