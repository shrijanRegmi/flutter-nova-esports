import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peaman/models/app_models/feed_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/feed_provider.dart';
import 'package:peaman/services/storage_services/feed_storage_service.dart';
import 'package:peaman/viewmodels/app_vm.dart';

class CreatePostVm extends ChangeNotifier {
  BuildContext context;
  CreatePostVm(this.context);

  List<File> _photos = [];
  TextEditingController _captionController = TextEditingController();
  bool _isLoading = false;
  bool _isFeatured = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<File> get photos => _photos;
  TextEditingController get captionController => _captionController;
  bool get isLoading => _isLoading;
  bool get isFeatured => _isFeatured;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  // create post
  createPost(final AppUser _appUser, final AppVm appVm,
      final TabController tabController) async {
    if (_photos.isNotEmpty) {
      _updateIsLoading(true);

      final _photosString =
          await FeedStorage(uid: _appUser.uid).uploadFeedImages(_photos);
      if (_photosString != null) {
        final _feed = Feed(
          ownerId: _appUser.uid,
          ownerRef: AppUser().getUserRef(_appUser.uid),
          photos: _photosString,
          caption: _captionController.text.trim(),
          updatedAt: DateTime.now().millisecondsSinceEpoch,
          isFeatured: _isFeatured,
          owner: _appUser,
        );

        final _result =
            await FeedProvider(feed: _feed, appUser: _appUser).createPost();

        if (_result != null) {
          final _tempFeed = _result.copyWith(owner: _appUser);
          final _myExistingFeeds = appVm.myFeeds;
          final _myExistingFeaturedFeeds = appVm.myFeaturedfeeds ?? [];
          _myExistingFeeds.insert(0, _tempFeed);
          appVm.updateMyFeedsList(_myExistingFeeds);

          if (_isFeatured) {
            _myExistingFeaturedFeeds.insert(0, _tempFeed);
            appVm.updateMyFeaturedFeedsList(_myExistingFeaturedFeeds);
          }

          Navigator.pop(context);
          tabController.animateTo(3, duration: Duration(milliseconds: 1000));
          await FeedProvider(feed: _result, appUser: _appUser)
              .sendToTimelines();
        } else {
          _updateIsLoading(false);
        }
      }
    }
  }

  // upload photo
  uploadPhoto() async {
    if (_photos.length < 5) {
      final _pickedImg =
          await ImagePicker().getImage(source: ImageSource.gallery);
      final _img = _pickedImg != null ? File(_pickedImg.path) : null;
      if (_img != null) {
        _photos.add(_img);
      }
      notifyListeners();
    } else {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            'You can only upload maximum of 5 images',
          ),
        ),
      );
    }
  }

  // remove photo
  removePhoto(final File myPhoto) async {
    _photos.remove(myPhoto);

    notifyListeners();
  }

  // update value of is loading
  _updateIsLoading(final bool newVal) {
    _isLoading = newVal;
    notifyListeners();
  }

  // update value of is featured
  updateIsFeatured(final bool newVal) {
    _isFeatured = newVal;
    notifyListeners();
  }
}
