import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/models/moment_model.dart';
import 'package:peaman/services/database_services/feed_provider.dart';
import 'package:peaman/services/database_services/user_provider.dart';
import 'package:peaman/services/storage_services/feed_storage_service.dart';
import 'package:peaman/viewmodels/app_vm.dart';

class ExploreVm extends ChangeNotifier {
  BuildContext context;
  ExploreVm(this.context);

  bool _isShowingTopLoader = false;
  ScrollController _scrollController = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController get scrollController => _scrollController;
  bool get isShowingTopLoader => _isShowingTopLoader;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  // init function
  onInit(AppVm appVm, AppUser appUser) {
    _getOldFeeds(appVm, appUser);
  }

  // fetch old feeds
  _getOldFeeds(AppVm appVm, AppUser appUser) {
    _scrollController.addListener(
      () async {
        if (_scrollController.offset > 200.0) {
          if (!_isShowingTopLoader) {
            _updateTopLoader(true);
          }
        } else {
          if (_isShowingTopLoader) {
            _updateTopLoader(false);
          }
        }

        if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent - 100.0) {
          if (!appVm.isLoadingOldFeeds) {
            appVm.updateIsLoadingOldFeeds(true);
            final _oldFeeds =
                await FeedProvider(appUser: appUser, feed: appVm.feeds.last)
                    .getOldTimelinePosts(appVm);

            if (_oldFeeds != null) {
              appVm.updateIsLoadingOldFeeds(false);
            }
          }
        }
      },
    );
  }

  // fetch old feeds
  getNewFeeds(AppVm appVm, AppUser appUser) async {
    if (!appVm.isLoadingOldFeeds) {
      _scrollController.jumpTo(1);
      AppUserProvider(uid: appUser.uid).updateUserDetail(data: {
        'new_posts': false,
      });
      appVm.updateIsLoadingFeeds(true);
      final _newFeeds = appVm.feeds.isEmpty
          ? await FeedProvider(appUser: appUser).getTimeline()
          : await FeedProvider(appUser: appUser, feed: appVm.feeds.first)
              .getNewTimelinePosts();
      if (_newFeeds != null) {
        if (_newFeeds.isNotEmpty) {
          _newFeeds.removeAt(_newFeeds.length - 1);
        }

        appVm.updateFeedsList([..._newFeeds, ...appVm.feeds]);
        appVm.updateIsLoadingFeeds(false);
      }
    }
  }

  // post moments
  createMoment(final AppUser appUser, final AppVm appVm) async {
    final _pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    File _fileImage;

    if (_pickedImage != null) {
      _fileImage = File(_pickedImage.path);
    }

    if (_fileImage != null) {
      final _moment = Moment(
        photo: _fileImage.path,
        ownerId: appUser.uid,
        owner: appUser,
        ownerRef: appUser.appUserRef,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );

      final _existingMoments = appVm.moments;
      _existingMoments.insert(0, _moment);
      appVm.updateMomentsList(_existingMoments);

      final _momentImage =
          await FeedStorage(uid: appUser.uid).uploadMomentImage(_fileImage);

      if (_momentImage != null) {
        final _momentWithImg = _moment.copyWith(
          photo: _momentImage,
        );

        await FeedProvider(moment: _momentWithImg).createMoment();
      }
    }
  }

  // update value of top loader
  _updateTopLoader(final bool newVal) {
    _isShowingTopLoader = newVal;

    notifyListeners();
  }
}
