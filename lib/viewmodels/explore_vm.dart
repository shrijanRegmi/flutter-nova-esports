import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/user_model.dart';
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
  onInit(AppVm appVm, AppUser appUser) {}
}
