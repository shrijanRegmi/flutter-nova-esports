import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/feed_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/feed_provider.dart';

class SavedVm extends ChangeNotifier {
  List<Feed> _feeds;
  bool _isLoading;

  List<Feed> get feeds => _feeds;
  bool get isLoading => _isLoading;

  // get saved feeds
  getSavedFeeds(final AppUser appUser) async {
    updateIsLoading(true);
    final _result = await FeedProvider(appUser: appUser).getSavedPosts();
    updateIsLoading(false);
    _feeds = _result;
    notifyListeners();
  }

  // update is loading
  updateIsLoading(final bool newIsLoading) {
    _isLoading = newIsLoading;

    notifyListeners();
  }
}
