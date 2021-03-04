import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/feed_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/feed_provider.dart';
import 'package:peaman/services/database_services/friend_provider.dart';
import 'package:peaman/services/database_services/user_provider.dart';
import 'package:peaman/viewmodels/app_vm.dart';

class FriendProfileVm extends ChangeNotifier {
  List<Feed> _feeds;
  List<Feed> _featuredFeeds;
  bool _isLoading = false;
  bool _isLoadingFeeds = false;
  String _btnText = 'Follow';
  AppUser _thisUser;

  List<Feed> get feeds => _feeds;
  List<Feed> get featuredFeeds => _featuredFeeds;
  bool get isLoading => _isLoading;
  bool get isLoadingFeeds => _isLoadingFeeds;
  String get btnText => _btnText;
  AppUser get thisUser => _thisUser;

  // init function
  onInit(final AppUser appUser, final AppUser user, final AppVm appVm) async {
    _updateIsLoading(true, true);
    if (appUser.uid != user.uid) {
      final _appUser = await AppUserProvider(uid: user.uid).getUserById();
      _updateThisUser(_appUser);
      await _getInitialBtnText(appUser, user);
      _updateIsLoading(false, true);
      await _getPosts(appUser, user);
    } else {
      _updateFeeds(appVm.myFeeds);
      _updateFeaturedFeeds(appVm.myFeaturedfeeds);
    }
    _updateIsLoading(false, false);
  }

  // follow user
  Future followUser(final AppUser appUser, final AppUser user) async {
    _updateBtnText('Cancle Follow');
    await FriendProvider(appUser: appUser, user: user).follow();
  }

  // accept follow
  Future acceptFollow(final AppUser appUser, final AppUser user) async {
    _updateBtnText('Follow Back');
    await FriendProvider(appUser: appUser, user: user).acceptFollow();
  }

  // followback
  Future followBack(final AppUser appUser, final AppUser user) async {
    _updateBtnText('Following');
    await FriendProvider(appUser: appUser, user: user).followBack();
  }

  // cancle follow
  Future cancleFollow(final AppUser appUser, final AppUser user) async {
    _updateBtnText('Follow');
    await FriendProvider(appUser: appUser, user: user).cancleFollow();
  }

  // get posts
  Future _getPosts(final AppUser appUser, final AppUser user) async {
    final _result =
        await FeedProvider(appUser: appUser, user: user).getPostsById();
    final _featuredResult =
        await FeedProvider(appUser: appUser, user: user).getFeaturedPostsById();
    _updateFeeds(_result);
    _updateFeaturedFeeds(_featuredResult);
  }

  // get initial btn text
  Future _getInitialBtnText(final AppUser appUser, final AppUser user) async {
    try {
      final _friendRef = user.appUserRef;
      final _userRef = appUser.appUserRef;

      final _friendRequestsRef =
          _friendRef.collection('requests').doc(appUser.uid);
      final _userRequestsRef = _userRef.collection('requests').doc(user.uid);
      final _friendFollowersRef =
          _friendRef.collection('followers').doc(appUser.uid);
      final _userFollowersRef = _userRef.collection('followers').doc(user.uid);

      final _friendRequestsSnap = await _friendRequestsRef.get();
      final _userRequestsSnap = await _userRequestsRef.get();
      final _friendFollowersSnap = await _friendFollowersRef.get();
      final _userFollowersSnap = await _userFollowersRef.get();

      if (_friendRequestsSnap.exists) {
        _updateBtnText('Cancle Follow');
      }

      if (_userRequestsSnap.exists) {
        _updateBtnText('Accept Follow');
      }

      if (_userFollowersSnap.exists && !_friendFollowersSnap.exists) {
        _updateBtnText('Follow Back');
      }

      if (_friendFollowersSnap.exists) {
        _updateBtnText('Following');
      }

      print('Success: Getting initial btn text $_btnText');
    } catch (e) {
      print('Error!!!: Getting initial btn text');
    }
  }

  // update value of feeds
  _updateFeeds(final List<Feed> newFeeds) {
    _feeds = newFeeds;
    notifyListeners();
  }

  // update value of featured feeds
  _updateFeaturedFeeds(final List<Feed> newFeeds) {
    _featuredFeeds = newFeeds;
    notifyListeners();
  }

  // update value of is loading
  _updateIsLoading(final bool isLoading, final bool isLoadingFeeds) {
    _isLoading = isLoading;
    _isLoadingFeeds = isLoadingFeeds;
    notifyListeners();
  }

  // update value of btn text
  _updateBtnText(final String newBtnText) {
    _btnText = newBtnText;
    notifyListeners();
  }

  // update value of this user
  _updateThisUser(final AppUser newAppUser) {
    _thisUser = newAppUser;
    notifyListeners();
  }
}
