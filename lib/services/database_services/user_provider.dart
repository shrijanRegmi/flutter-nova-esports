import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peaman/enums/online_status.dart';
import 'package:peaman/models/app_models/app_config.dart';
import 'package:peaman/models/app_models/user_model.dart';

class AppUserProvider {
  final String uid;
  final String searchKey;
  final DocumentReference userRef;
  final AppUser user;
  AppUserProvider({
    this.uid,
    this.userRef,
    this.searchKey,
    this.user,
  });
  final _ref = FirebaseFirestore.instance;

  // set user active status
  Future setUserActiveStatus({@required OnlineStatus onlineStatus}) async {
    try {
      final _userRef = _ref.collection('users').doc(uid);
      final _status = {
        'active_status': onlineStatus.index,
      };
      await _userRef.update(_status);
      print(
          'Success: Setting activity status of user $uid to ${onlineStatus.index}');
      return 'Success';
    } catch (e) {
      print(
          'Error!!!: Setting activity status of user $uid to ${onlineStatus.index}');
      print(e);
      return null;
    }
  }

  // send user to firestore
  Future sendUserToFirestore() async {
    try {
      final _userRef = _ref.collection('users').doc(user.uid);

      print('Success: Sending user data to firestore');
      await _userRef.set(AppUser.toJson(user));
    } catch (e) {
      print(e);
      print('Error!!!: Sending user data to firestore');
      return null;
    }
  }

  // update user details
  Future updateUserDetail({@required final Map<String, dynamic> data}) async {
    try {
      final _userRef = _ref.collection('users').doc(uid);

      await _userRef.update(data);

      print('Success: Updating personal info of user $uid');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Updating personal info of user $uid');
      return null;
    }
  }

  // appuser from firebase;
  AppUser _appUserFromFirebase(DocumentSnapshot snap) {
    return AppUser.fromJson(snap.data());
  }

  // get appuser by id
  Future<AppUser> getUserById() async {
    AppUser _appUser;

    try {
      final _appUserRef = _ref.collection('users').doc(uid);
      final _appUserSnap = await _appUserRef.get();
      if (_appUserSnap.exists) {
        final _appUserData = _appUserSnap.data();
        _appUser = AppUser.fromJson(_appUserData);
      }
    } catch (e) {
      print(e);
      print('Error!!!: Getting user from id $uid');
    }

    return _appUser;
  }

  // search user
  Future<AppUser> searchedUser(
    final TextEditingController searchController, {
    final bool onlyNameSearch = false,
  }) async {
    AppUser _appUser;
    try {
      final _text = searchController.text.trim();

      final _usersRefByName =
          _ref.collection('users').where('name', isEqualTo: _text).limit(1);
      final _usersRefByEmail =
          _ref.collection('users').where('email', isEqualTo: _text).limit(1);
      final _usersRefByInGameId = _ref
          .collection('users')
          .where('in_game_id', isEqualTo: _text)
          .limit(1);
      final _usersRefByInGameName = _ref
          .collection('users')
          .where('in_game_name', isEqualTo: _text)
          .limit(1);

      // name
      var _usersRefSnap = await _usersRefByName.get();
      if (_usersRefSnap.docs.isNotEmpty) {
        final _userData = _usersRefSnap.docs.first.data();
        if (_userData != null) {
          _appUser = AppUser.fromJson(_userData);
        }
      } else if (!onlyNameSearch) {
        // email
        var _usersRefSnap = await _usersRefByEmail.get();
        if (_usersRefSnap.docs.isNotEmpty) {
          final _userData = _usersRefSnap.docs.first.data();
          if (_userData != null) {
            _appUser = AppUser.fromJson(_userData);
          }
        } else {
          // in game id
          _usersRefSnap = await _usersRefByInGameId.get();
          if (_usersRefSnap.docs.isNotEmpty) {
            final _userData = _usersRefSnap.docs.first.data();
            if (_userData != null) {
              _appUser = AppUser.fromJson(_userData);
            }
          } else {
            // in game name
            _usersRefSnap = await _usersRefByInGameName.get();
            if (_usersRefSnap.docs.isNotEmpty) {
              final _userData = _usersRefSnap.docs.first.data();
              if (_userData != null) {
                _appUser = AppUser.fromJson(_userData);
              }
            }
          }
        }
      }
    } catch (e) {
      print(e);
      print('Error!!!: Searching for user');
    }
    return _appUser;
  }

  // list of users;
  List<AppUser> _usersFromFirebase(QuerySnapshot snap) {
    return snap.docs.map((doc) {
      return AppUser.fromJson(doc.data());
    }).toList();
  }

  // get old search results
  Future<List<AppUser>> getOldSearchResults() async {
    List<AppUser> _searchResults = [];

    try {
      final _searchRef = _ref
          .collection('users')
          .where('search_key', arrayContains: searchKey)
          .orderBy('name')
          .startAfter([user.name]).limit(10);
      final _searchSnap = await _searchRef.get();
      if (_searchSnap.docs.isNotEmpty) {
        for (final doc in _searchSnap.docs) {
          final _userData = doc.data();
          final _appUser = AppUser.fromJson(_userData);

          _searchResults.add(_appUser);
        }
      }
      print('Success: Getting old search results with key $searchKey');
    } catch (e) {
      print(e);
      print('Error!!!: Getting old search results with key $searchKey');
    }

    return _searchResults;
  }

  // update app config
  Future updateAppConfig(final AppConfig appConfig) async {
    try {
      final _configRef = _ref.collection('configs').doc('shrijan_regmi');
      await _configRef.update(appConfig.toJson());
      print('Success: Updating app config');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Updating app config');
      return null;
    }
  }

  // app config from firebase
  AppConfig _appConfigFromFirebase(final DocumentSnapshot snap) {
    return AppConfig.fromJson(snap.data());
  }

  // stream of appuser;
  Stream<AppUser> get appUser {
    return _ref
        .collection('users')
        .doc(uid)
        .snapshots()
        .map(_appUserFromFirebase);
  }

  // stream of app user from ref
  Stream<AppUser> get appUserFromRef {
    return userRef?.snapshots()?.map(_appUserFromFirebase);
  }

  // stream of users from search key
  Stream<List<AppUser>> get appUserFromKey {
    return _ref
        .collection('users')
        .where('search_keys', arrayContains: searchKey)
        .limit(10)
        .snapshots()
        .map(_usersFromFirebase);
  }

  // stream of list of users;
  Stream<List<AppUser>> get allUsers {
    return _ref
        .collection('users')
        .limit(10)
        .snapshots()
        .map(_usersFromFirebase);
  }

  // stream of app config from firebase
  Stream<AppConfig> get appConfig {
    return _ref
        .collection('configs')
        .doc('shrijan_regmi')
        .snapshots()
        .map(_appConfigFromFirebase);
  }

  // stream of active users
  Stream<List<AppUser>> get activeUsers {
    return _ref
        .collection('users')
        .where('active_status', isEqualTo: 1)
        .where('worker', isEqualTo: true)
        .snapshots()
        .map(_usersFromFirebase);
  }

  // stream of workers
  Stream<List<AppUser>> get workerUsers {
    return _ref
        .collection('users')
        .where('worker', isEqualTo: true)
        .snapshots()
        .map(_usersFromFirebase);
  }
}
