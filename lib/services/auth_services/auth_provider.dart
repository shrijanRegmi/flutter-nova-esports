import 'package:firebase_auth/firebase_auth.dart';
import 'package:peaman/enums/age.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/functions_services/user_functions.dart';

class AuthProvider {
  final _auth = FirebaseAuth.instance;

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
        age: age.index,
        email: email,
        name: name,
      );

      await UserFunctions().sendUserToFunctions(_user);

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

  // log out user
  Future logOut() async {
    print('Success: Logging out user');
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
