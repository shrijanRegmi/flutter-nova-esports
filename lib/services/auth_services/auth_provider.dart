import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:peaman/enums/online_status.dart';
import 'package:peaman/helpers/dialog_provider.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/user_provider.dart';

class AuthProvider {
  final AppUser appUser;
  final BuildContext context;
  AuthProvider({
    this.appUser,
    this.context,
  });

  final _auth = FirebaseAuth.instance;
  final _ref = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // sign up with google
  Future signUpWithGoogle() async {
    try {
      final _account = await _googleSignIn.signIn();
      final _tokens = await _account.authentication;
      final _cred = GoogleAuthProvider.credential(
        idToken: _tokens.idToken,
        accessToken: _tokens.accessToken,
      );
      final _result = await _auth.signInWithCredential(_cred);
      final _user = _result.user;

      final _usersRef = _ref
          .collection('users')
          .where('email', isEqualTo: _user.email)
          .limit(1);
      final _usersSnap = await _usersRef.get();
      final _registered = _usersSnap.docs.isNotEmpty;

      if (!_registered) {
        final _appUser = AppUser(
          uid: _user.uid,
          email: _user.email,
        );
        await AppUserProvider(user: _appUser).sendUserToFirestore();
      }
      print('Success: Signing up with google');
      return _user;
    } catch (e) {
      print(e);
      print('Error!!!: Signing up with google');
      return null;
    }
  }

  // sign in with email and password
  Future<void> signInWithEmailAndPassword({
    @required final String email,
    @required final String password,
    final Function(String) onSuccess,
    final Function(dynamic) onError,
  }) async {
    try {
      final _usersRef =
          _ref.collection('users').where('email', isEqualTo: email).limit(1);
      final _usersSnap = await _usersRef.get();
      final _registered = _usersSnap.docs.isNotEmpty;

      UserCredential _result;
      if (_registered) {
        _result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        _result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final _appUser = AppUser(
          uid: _result.user.uid,
          email: email,
        );
        AppUserProvider(user: _appUser).sendUserToFirestore();
      }
      _userFromFirebase(_result.user);

      onSuccess?.call(_result.user.uid);
      print('Success: Signing user with email and password');
    } catch (e) {
      print(e);
      print('Error!!!: Signing user with email and password');
      onError?.call(e);
    }
  }

  // sign in with phone
  Future<void> signInWithPhone(
    final String phoneNum, {
    final Function(String, int) onSuccess,
    final Function(dynamic) onError,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNum,
        verificationCompleted: (cred) async {
          final _result = await _auth.signInWithCredential(cred);
          final _user = _result.user;
          _userFromFirebase(_user);
          print('Success: Signing in user with phone $phoneNum');
        },
        verificationFailed: (e) {
          print(e);
          print('Error!!!: Signing in user with phone $phoneNum');
          onError?.call(e);
        },
        codeSent: onSuccess,
        codeAutoRetrievalTimeout: (id) {},
      );
    } catch (e) {
      print(e);
      print('Error!!!: Signing in user with phone $phoneNum');
      onError?.call(e);
    }
  }

  Future<void> submitVerificationCode(
    final String verificationId,
    final String otpCode, {
    final Function(dynamic) onSuccess,
    final Function(dynamic) onError,
  }) async {
    try {
      final _cred = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpCode,
      );

      final _result = await _auth.signInWithCredential(_cred);
      final _user = _result.user;
      _userFromFirebase(_user);
      print('Success: Submitting OTP code');
      onSuccess?.call(_user);
    } catch (e) {
      print(e);
      print('Error!!!: Submitting OTP code');
      onError?.call(e);
    }
  }

  // forget password
  Future<void> resetPassword(
    final String email, {
    final Function() onSuccess,
    final Function(dynamic) onError,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('Success: Sending password reset email');
      onSuccess?.call();
    } catch (e) {
      print(e);
      print('Error!!!: Sending password reset email');
      onError?.call(e);
    }
  }

  // create account with email and password
  Future signUpWithEmailAndPassword({
    final String password,
  }) async {
    try {
      final _result = await _auth.createUserWithEmailAndPassword(
          email: appUser.email, password: password);

      final _appUser = appUser.copyWith(
        uid: _result.user.uid,
      );

      await AppUserProvider(user: _appUser).sendUserToFirestore();

      _userFromFirebase(_result.user);
      print('Success: Creating user with name ${appUser.name}');
      return _result;
    } catch (e) {
      print(e);
      _handleErrors(e);
      print('Error!!!: Creating user with name ${appUser.name}');
      return null;
    }
  }

  // login with email and password
  Future loginWithEmailAndPassword({
    final String email,
    final String password,
  }) async {
    try {
      final _result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _userFromFirebase(_result.user);
      print('Success: Logging in user with email $email');
      return _result;
    } catch (e) {
      print(e);
      _handleErrors(e);
      print('Error!!!: Logging in user with email $email');
      return null;
    }
  }

  // login with google
  Future loginWithGoogle(final GlobalKey<ScaffoldState> scaffoldKey) async {
    try {
      final _account = await _googleSignIn.signIn();
      final _tokens = await _account.authentication;
      final _cred = GoogleAuthProvider.credential(
          idToken: _tokens.idToken, accessToken: _tokens.accessToken);
      final _result = await _auth.signInWithCredential(_cred);
      final _user = _result.user;
      final _ref = FirebaseFirestore.instance;
      final _userRef = _ref.collection('users').doc(_user.uid);
      final _userSnap = await _userRef.get();

      if (!_userSnap.exists) {
        DialogProvider(context).showWarningDialog(
          'Oops !',
          'User with that email does not exist! Please create an account first.',
          () {},
        );
        logOut();
        return null;
      } else {
        _userFromFirebase(_user);
        print('Success: Logging in user with name ${_user.displayName}');
      }
      return _user;
    } catch (e) {
      print(e);
      _handleErrors(e);
      print('Error!!!: Signing up with google');
      return null;
    }
  }

  // handle error message
  void _handleErrors(dynamic e) {
    switch (e?.message) {
      case "The email address is badly formatted.":
        DialogProvider(context).showWarningDialog(
          'Oops !',
          'Please enter a valid email.',
          () {},
        );
        break;
      case "The password is invalid or the user does not have a password.":
        DialogProvider(context).showWarningDialog(
          'Oops !',
          'The password you have entered is incorrect.',
          () {},
        );
        break;
      case "The email address is already in use by another account.":
        DialogProvider(context).showWarningDialog(
          'Oops !',
          'The email address is already in use by another account. Please use a different one.',
          () {},
        );
        break;
      case "There is no user record corresponding to this identifier. The user may have been deleted.":
        DialogProvider(context).showWarningDialog(
          'Oops !',
          'The user with this email does not exist. Please create an account first with that email.',
          () {},
        );
        break;
      case "Password should be at least 6 characters":
        DialogProvider(context).showWarningDialog(
          'Oops !',
          'Password should be at least 6 characters long.',
          () {},
        );
        break;
      default:
        DialogProvider(context).showWarningDialog(
          'Oops !',
          'Unexpected error occurred! Please try again later. ($e)',
          () {},
        );
    }
  }

  // log out user
  Future logOut() async {
    print('Success: Logging out user');
    await _googleSignIn.signOut();
    await _auth.signOut();
    await AppUserProvider(uid: appUser?.uid).setUserActiveStatus(
      onlineStatus: OnlineStatus.away,
    );
  }

  // user from firebase
  AppUser _userFromFirebase(User user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  // stream of user
  Stream<AppUser> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  Stream<DataConnectionStatus> get internetConnection {
    return DataConnectionChecker().onStatusChange;
  }
}
