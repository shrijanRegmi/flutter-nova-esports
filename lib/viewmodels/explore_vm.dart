import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/models/app_models/video_stream_model.dart';
import 'package:peaman/viewmodels/app_vm.dart';
import 'package:provider/provider.dart';

class ExploreVm extends ChangeNotifier {
  BuildContext context;
  ExploreVm(this.context);

  bool _showLoader = false;
  ScrollController _scrollController = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController get scrollController => _scrollController;
  bool get showLoader => _showLoader;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  List<Tournament> get tournaments => Provider.of<List<Tournament>>(context);
  List<VideoStream> get videoStreams => Provider.of<List<VideoStream>>(context);

  List<Tournament> get liveTournaments =>
      (tournaments ?? []).where((element) => element.isLive).toList();
  List<Tournament> get otherTournaments =>
      (tournaments ?? []).where((element) => !element.isLive).toList();

  // init function
  onInit(AppVm appVm, AppUser appUser) {}

  // show loader
  showFullLoader() async {
    _updateShowLoader(true);
    await Future.delayed(Duration(milliseconds: 2000));
    _updateShowLoader(false);
  }

  // update value of show loader
  _updateShowLoader(final bool newVal) {
    _showLoader = newVal;
    notifyListeners();
  }
}
