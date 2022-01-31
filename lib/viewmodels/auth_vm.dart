import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peaman/enums/age.dart';
import 'package:peaman/helpers/dialog_provider.dart';
import 'package:peaman/models/app_models/app_config.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/ad_services/ad_provider.dart';
import 'package:peaman/services/auth_services/auth_provider.dart';
import 'package:peaman/services/database_services/user_provider.dart';
import 'package:peaman/services/storage_services/user_storage_service.dart';

class AuthVm extends ChangeNotifier {
  final BuildContext context;
  AuthVm(this.context);

  TextEditingController _nameController = TextEditingController();
  TextEditingController _inGameNameController = TextEditingController();
  TextEditingController _inGameIdController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  PageController _pageController = PageController();
  bool _isLoading = false;
  bool _isLoadingGoogleSignUp = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  File _imgFile;
  bool _isNextPressed = false;
  Age _age;
  StreamSubscription _subscription;
  String _address;
  InterstitialAd _interstitialAd;
  AdListener _adListener;
  bool _isTermsAccepted = false;
  String _verificationId;

  TextEditingController get nameController => _nameController;
  TextEditingController get inGameNameController => _inGameNameController;
  TextEditingController get inGameIdController => _inGameIdController;
  TextEditingController get emailController => _emailController;
  TextEditingController get passController => _passController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get otpController => _otpController;
  bool get isLoading => _isLoading;
  bool get isLoadingGoogleSignUp => _isLoadingGoogleSignUp;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  File get imgFile => _imgFile;
  bool get isNextPressed => _isNextPressed;
  Age get age => _age;
  String get address => _address;
  bool get isTermsAccepted => _isTermsAccepted;
  PageController get pageController => _pageController;

  // init function
  onInit(final AppConfig appConfig) {
    if (appConfig != null) {
      _handleInterstitialAd(appConfig);
    }
  }

  // dispose function
  onDispose() {
    _subscription?.cancel();
    _interstitialAd?.dispose();
  }

  // handle interstitial ad
  _handleInterstitialAd(final AppConfig appConfig) {
    _adListener = AdListener(
      onAdLoaded: (Ad ad) => print('Ad loaded.'),
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
        print('Ad failed to load: $error');
      },
      onAdOpened: (Ad ad) => print('Ad opened.'),
      onAdClosed: (Ad ad) {
        ad.dispose();
        print('Ad closed.');
      },
      onApplicationExit: (Ad ad) => print('Left application.'),
    );
    _interstitialAd = InterstitialAd(
      adUnitId: '${appConfig.interstitialId}',
      listener: _adListener,
      request: AdRequest(),
    )..load();
  }

  // sign in with email and password
  void signInWithEmailAndPassword() {
    if (_passController.text.trim() != '') {
      _updateLoader(true);
      AuthProvider().signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _emailController.text.trim(),
        onError: (e) {
          _updateLoader(false);
        },
      );
    }
  }

  // on continue btn pressed
  void onPressedContinueBtn() {
    if (_emailController.text.trim() != '') {
      FocusScope.of(context).unfocus();
      _updateLoader(true);
      Future.delayed(Duration(milliseconds: 2000), () {
        _updateLoader(false);
        _scrollPageView();
      });
    } else {
      DialogProvider(context).showWarningDialog(
        'Email is required',
        'Please enter your email to continue',
        () {},
      );
    }
  }

  // sign up using google
  void signUpWithGoogle() async {
    _updateGoogleSignUpLoader(true);
    final _result = await AuthProvider().signUpWithGoogle();
    if (_result == null) {
      _updateGoogleSignUpLoader(false);
    }
  }

  // send user data to firestore
  void _sendUserToFirestore() async {
    var _result;
    final _auth = FirebaseAuth.instance;
    final _uid = _auth.currentUser?.uid;
    final _email = _auth.currentUser?.email;

    if (imgFile != null) {
      _result = await UserStorage().uploadUserImage(imgFile: imgFile);
    }
    final _appUser = AppUser(
      uid: _uid,
      phone: _phoneController.text.trim(),
      photoUrl: _result,
      address: _address,
      email: _email,
      name: _nameController.text.trim(),
      inGameName: _inGameNameController.text.trim(),
      inGameId: _inGameIdController.text.trim(),
    );

    _result = await AppUserProvider(user: _appUser).sendUserToFirestore();
  }

  // sign in with phone
  void signInWithPhone() {
    if (_phoneController.text.trim() != '') {
      FocusScope.of(context).unfocus();
      _updateLoader(true);
      AuthProvider().signInWithPhone(
        _phoneController.text.trim(),
        onSuccess: (id, token) {
          _updateLoader(false);
          _scrollPageView();
          _verificationId = id;
        },
        onError: (e) {
          _updateLoader(false);
          DialogProvider(context).showWarningDialog(
            'Error logging in with phone number',
            '${e.message}',
            () {},
          );
        },
      );
    }
  }

  // submit otp code
  void submitOtpCode() {
    if (_verificationId != null && _otpController.text.trim() != '') {
      FocusScope.of(context).unfocus();
      _updateLoader(true);
      AuthProvider().submitVerificationCode(
        _verificationId,
        _otpController.text.trim(),
        onError: (e) {
          _updateLoader(false);
          DialogProvider(context).showWarningDialog(
            'Error submitting OTP code',
            '${e.message}',
            () {},
          );
        },
      );
    }
  }

  // login user with email and password;
  Future loginUser() async {
    var _result;
    _updateLoader(true);
    if (_emailController.text.trim() != '' &&
        _passController.text.trim() != '') {
      AdProvider.loadInterstitial(context);
      _result = await AuthProvider(context: context).loginWithEmailAndPassword(
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
      AdProvider.loadInterstitial(context);
      if (imgFile != null) {
        _result = await UserStorage().uploadUserImage(imgFile: imgFile);
      }
      final _appUser = AppUser(
        photoUrl: _result,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        inGameName: _inGameNameController.text.trim(),
        inGameId: _inGameIdController.text.trim(),
        email: _emailController.text.trim(),
        address: _address,
      );

      _result = await AuthProvider(appUser: _appUser, context: context)
          .signUpWithEmailAndPassword(password: _passController.text.trim());
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
  onPressedNextBtn() async {
    if (_nameController.text.trim() != '' &&
        _phoneController.text.trim() != '' &&
        _inGameIdController.text.trim() != '' &&
        _inGameNameController.text.trim() != '') {
      if (!_isTermsAccepted) {
        await DialogProvider(context).showWarningDialog(
          'Terms & Condition and Privacy Policy not accepted',
          'Please accept our Terms & Condition and Privacy Policy to continue',
          () {},
        );
      } else {
        _updateLoader(true);
        final _searchedUserByInGameId =
            await AppUserProvider().searchedUser(_inGameIdController);

        if (_searchedUserByInGameId == null) {
          final _addressFromPosition = await _getAddressFromLatLng();
          _updateLoader(false);
          if (_addressFromPosition != null) {
            _updateAddress(_addressFromPosition);

            // Send the user to firebase
            _sendUserToFirestore();
          } else {
            _updateLoader(false);
          }
        } else {
          _updateLoader(false);
          await DialogProvider(context).showWarningDialog(
            'In-Game Id already taken',
            'The in-game id you have entered is already taken. Please use a different one !',
            () {},
          );
        }
      }
    } else {
      await DialogProvider(context).showWarningDialog(
        'Empty fields',
        'Please fill up all the fields to continue.',
        () {},
      );
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
    final _result =
        await AuthProvider(context: context).loginWithGoogle(_scaffoldKey);
    if (_result == null) {
      _updateLoader(false);
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
      if (e is String &&
          (e.contains('Location permissions are denied') ||
              e.contains(
                  'Location permissions are permanently denied, we cannot request permissions.'))) {
        await DialogProvider(context).showWarningDialog(
          'Location permission denied',
          'You need to accept location permission to continue.',
          () {},
        );
      } else {
        await DialogProvider(context).showLocationPermissionDeniedDialog();
      }

      print(e);
      print('Error!!!: Getting user address');
    }
    return null;
  }

  // update value of address
  _updateAddress(final String newVal) {
    _address = newVal;
    notifyListeners();
  }

  // update value of is terms accepted
  updateIsTermsAccepted(final bool newVal) {
    _isTermsAccepted = newVal;
    notifyListeners();
  }

  // scroll page view
  void _scrollPageView() {
    FocusScope.of(context).unfocus();
    _pageController.animateTo(
      MediaQuery.of(context).size.width,
      duration: Duration(milliseconds: 1000),
      curve: Curves.ease,
    );
  }

  // update value of isLoadingGoogleSignUp
  void _updateGoogleSignUpLoader(final bool newVal) {
    _isLoadingGoogleSignUp = newVal;
    notifyListeners();
  }
}
