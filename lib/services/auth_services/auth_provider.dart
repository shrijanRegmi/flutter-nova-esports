import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:peaman/enums/age.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/user_provider.dart';

class AuthProvider {
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // create account with email and password
  Future signUpWithEmailAndPassword({
    final String photoUrl,
    final Age age,
    final String name,
    final String email,
    final String password,
  }) async {
    try {
      final _result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      final AppUser _user = AppUser(
        uid: _result.user.uid,
        photoUrl: photoUrl,
        email: email,
        name: name,
      );

      await AppUserProvider(user: _user).sendUserToFirestore();

      _userFromFirebase(_result.user);
      print('Success: Creating user with name $name');
      return _result;
    } catch (e) {
      print(e);
      print('Error!!!: Creating user with name $name');
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
      print('Error!!!: Logging in user with email $email');
      return null;
    }
  }

  // login with google
  Future loginWithGoogle(
      final GlobalKey<ScaffoldState> scaffoldKey) async {
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
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
              'User with that email does not exist! Please create an account first.'),
        ));
      } else {
        _userFromFirebase(_user);
        print('Success: Logging in user with name ${_user.displayName}');
      }
      return _user;
    } catch (e) {
      print(e);
      print('Error!!!: Signing up with google');
      return null;
    }
  }

  // sign up with google
  Future signUpWithGoogle(final AppUser appUser,
      final GlobalKey<ScaffoldState> scaffoldKey) async {
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
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('User with that email already exist! Please login.'),
        ));
      }
      return _user;
    } catch (e) {
      print(e);
      print('Error!!!: Signing up with google');
      return null;
    }
  }

  // log out user
  Future logOut() async {
    print('Success: Logging out user');
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }

  // user from firebase
  AppUser _userFromFirebase(User user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  // stream of user
  Stream<AppUser> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }
}
