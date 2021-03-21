import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/user_provider.dart';
import 'package:peaman/services/storage_services/user_storage_service.dart';

class EditProfileVm extends ChangeNotifier {
  final BuildContext context;
  EditProfileVm(this.context);

  TextEditingController _nameController = TextEditingController();
  TextEditingController _inGameIdController = TextEditingController();
  TextEditingController _inGameNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  File _photo;
  bool _isLoading = false;
  bool _isGettingAddress = false;

  TextEditingController get nameController => _nameController;
  TextEditingController get addressController => _addressController;
  TextEditingController get inGameNameController => _inGameNameController;
  TextEditingController get inGameIdController => _inGameIdController;
  File get photo => _photo;
  bool get isLoading => _isLoading;
  bool get isGettingAddress => _isGettingAddress;

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
      'address': _addressController.text.trim(),
      'in_game_id': _inGameIdController.text.trim(),
      'in_game_name': _inGameNameController.text.trim(),
      'photoUrl': _photoUrl,
    };

    if (_nameController.text.trim() == '') _data.remove('name');
    if (_addressController.text.trim() == '') _data.remove('address');
    if (_inGameIdController.text.trim() == '') _data.remove('in_game_id');
    if (_inGameNameController.text.trim() == '') _data.remove('in_game_name');

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

  // on pressed on address
  onPressedAddress() async {
    if (_addressController.text.trim() == '') {
      updateIsGettingAddress(true);
      final _address = await _getAddressFromLatLng();
      updateIsGettingAddress(false);
      if (_address != null) {
        _addressController.text = _address;
        notifyListeners();
      }
    }
  }

  // get current device postion on map
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  // get address from postion
  Future<String> _getAddressFromLatLng() async {
    try {
      final _position = await _determinePosition();
      final coordinates =
          new Coordinates(_position.latitude, _position.longitude);
      final _address =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      if (_address.isNotEmpty) {
        return _address.first.addressLine;
      }
    } catch (e) {
      print(e);
      if (e?.message ==
          "User denied permissions to access the device's location.") {
        // _scaffoldKey.currentState.showSnackBar(
        //   SnackBar(
        //     content:
        //         Text('Please go to settings and turn on location permission !'),
        //   ),
        // );
      }
      print('Error!!!: Getting user address');
    }
    return null;
  }

  // update value of is loading
  updateIsLoading(final bool newVal) {
    _isLoading = newVal;
    notifyListeners();
  }

  // update value of is getting address
  updateIsGettingAddress(final bool newVal) {
    _isGettingAddress = newVal;
    notifyListeners();
  }

  // initialize values
  _initializeValues(final AppUser appUser) {
    _nameController.text = appUser.name;
    _addressController.text = appUser.address;
    _inGameNameController.text = appUser.inGameName;
    _inGameIdController.text = appUser.inGameId;
    if (appUser.photoUrl != null) _photo = File(appUser.photoUrl);

    notifyListeners();
  }
}
