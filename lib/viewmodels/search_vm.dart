import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/user_provider.dart';
import 'package:provider/provider.dart';

class SearchVm extends ChangeNotifier {
  final BuildContext context;
  SearchVm({@required this.context});

  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  List<AppUser> _searchedNames = [];

  AppUser get appUser => Provider.of<AppUser>(context);
  ScrollController get scrollController => _scrollController;
  bool get isLoading => _isLoading;
  List<AppUser> get searchedNames => _searchedNames;

  // init function
  onInit(final AppUser appUser, final List<AppUser> searchedUsers,
      final String searchKey) {
    _scrollController.addListener(() async {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent - 100 &&
          _searchedNames.isNotEmpty) {
        _updateIsLoading(true);
        final _result = await AppUserProvider(
                user: _searchedNames.last, searchKey: searchKey)
            .getOldSearchResults();
        if (_result != null) {
          updateSearchedName([..._searchedNames, ..._result]);
        }
        _updateIsLoading(false);
      }
    });

    updateSearchedName(searchedUsers);
  }

  // update value of is loading
  _updateIsLoading(final bool newVal) {
    _isLoading = newVal;
    notifyListeners();
  }

  // update value of searched names
  updateSearchedName(final List<AppUser> newVal,
      {bool requiredSetState = true}) {
    _searchedNames = newVal;

    if (requiredSetState) notifyListeners();
  }
}
