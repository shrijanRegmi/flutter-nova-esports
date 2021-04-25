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
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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

  // sign up with google
  Future signUpWithGoogle(
      final AppUser appUser, final GlobalKey<ScaffoldState> scaffoldKey) async {
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
        final _appUser = appUser.copyWith(uid: _user.uid, email: _user.email);
        await AppUserProvider(user: _appUser).sendUserToFirestore();
        _userFromFirebase(_user);
        print('Success: Signing up user with name ${_user.displayName}');
      } else {
        DialogProvider(context).showWarningDialog(
          'Oops !',
          'User with that email already exist! Please login.',
          () {},
        );
        logOut();
        return null;
      }
      return _user;
    } catch (e) {
      print(e);
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
          'Unexpected error occurred! Please try again later.',
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
