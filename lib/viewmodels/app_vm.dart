import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/feed_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/models/moment_model.dart';
import 'package:peaman/services/database_services/feed_provider.dart';

class AppVm extends ChangeNotifier {
  final BuildContext context;
  AppVm(this.context);

  List<Feed> _feeds;
  List<Feed> _myFeeds;
  List<Feed> _myFeaturedFeeds;
  bool _isLoadingFeeds = false;
  bool _isLoadingOldFeeds = false;
  bool _isLoadingNewFeeds = false;
  bool _isLoadingMoments = false;
  List<Moment> _moments = [];

  List<Feed> get feeds => _feeds;
  List<Feed> get myFeeds => _myFeeds;
  List<Feed> get myFeaturedfeeds => _myFeaturedFeeds;
  bool get isLoadingFeeds => _isLoadingFeeds;
  bool get isLoadingOldFeeds => _isLoadingOldFeeds;
  bool get isLoadingNewFeeds => _isLoadingNewFeeds;
  bool get isLoadingMoments => _isLoadingMoments;
  List<Moment> get moments => _moments;

  // get posts
  Future getPostsById(final AppUser appUser) async {
    final _thisFeeds =
        await FeedProvider(appUser: appUser, user: appUser).getPostsById();

    updateMyFeedsList(_thisFeeds);

    final _thisFeaturedFeeds =
        await FeedProvider(appUser: appUser, user: appUser)
            .getFeaturedPostsById();

    updateMyFeaturedFeedsList(_thisFeaturedFeeds);
  }

  // get timeline
  Future getTimeline(final AppUser appUser) async {
    final _thisFeeds = await FeedProvider(appUser: appUser).getTimeline();

    updateFeedsList(_thisFeeds);

    final _thisFeaturedFeeds =
        await FeedProvider(appUser: appUser, user: appUser)
            .getFeaturedPostsById();

    updateMyFeaturedFeedsList(_thisFeaturedFeeds);
  }

  // get moments
  Future getMoments(final AppUser appUser) async {
    await Future.delayed(Duration(milliseconds: 50));
    updateIsLoadingMoments(true);
    final _myMoments = await FeedProvider(appUser: appUser).getMyMoments();
    final _othersMoments = await FeedProvider(appUser: appUser).getMoments();
    _othersMoments.shuffle();
    _othersMoments.sort((a, b) => a.isSeen ? 1 : -1);
    _moments = [..._myMoments, ..._othersMoments];
    notifyListeners();
    updateIsLoadingMoments(false);
  }

  // update value of feeds list
  updateFeedsList(final List<Feed> newFeedsList) {
    _feeds = newFeedsList;
    notifyListeners();
  }

  // update value of my feeds list
  updateMyFeedsList(final List<Feed> newFeedsList) {
    _myFeeds = newFeedsList;
    notifyListeners();
  }

  // update value of my featured feeds list
  updateMyFeaturedFeedsList(final List<Feed> newFeedsList) {
    _myFeaturedFeeds = newFeedsList;
    notifyListeners();
  }

  // update value of is loading old feeds
  updateIsLoadingOldFeeds(final bool newVal) {
    _isLoadingOldFeeds = newVal;
    notifyListeners();
  }

  // update value of is loading feeds
  updateIsLoadingFeeds(final bool newVal) {
    _isLoadingFeeds = newVal;
    notifyListeners();
  }
  
  // update value of is loading new feeds
  updateIsLoadingNewFeeds(final bool newVal) {
    _isLoadingNewFeeds = newVal;
    notifyListeners();
  }

  // update value of is loading moments
  updateIsLoadingMoments(final bool newVal) {
    _isLoadingMoments = newVal;
    notifyListeners();
  }

  // update value of moments list
  updateMomentsList(final List<Moment> newMoments) {
    _moments = newMoments;
    notifyListeners();
  }

  // update single feed value
  updateSingleFeed(final Feed feed) {
    final _index = _feeds.indexWhere((element) => element.id == feed.id);
    final _myIndex = _myFeeds.indexWhere((element) => element.id == feed.id);
    final _myFeaturedIndex =
        _myFeaturedFeeds.indexWhere((element) => element.id == feed.id);

    if (_index != -1) {
      _feeds[_index] = feed;
    }
    if (_myIndex != -1) {
      _myFeeds[_myIndex] = feed;
    }
    if (_myFeaturedIndex != -1) {
      _myFeaturedFeeds[_myFeaturedIndex] = feed;
    }
    notifyListeners();
  }

  // update single moment value
  updateSingleMoment(final Moment moment) {
    final _index = _moments.indexWhere((element) => element.id == moment.id);

    if (_index != -1) {
      _moments[_index] = moment;
      notifyListeners();
    }
  }

  // add feed to feeds list
  addToFeedList(final Feed feed) {
    _feeds.add(feed);

    notifyListeners();
  }
}
