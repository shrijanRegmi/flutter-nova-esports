import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/app_vm.dart';
import 'package:peaman/viewmodels/explore_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/screens/active_and_woker_users_view_screen.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/live_tournament_list.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/tournament_list.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/video_carousel.dart';
import 'package:provider/provider.dart';

import 'create_tournament_screen.dart';

class ExploreTab extends StatefulWidget {
  final TabController tabController;
  ExploreTab(this.tabController);

  @override
  _ExploreTabState createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  BannerAd _bannerAd;
  bool _isLoadedAd = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _handleBanner();
  // }

  // _handleBanner() async {
  //   _bannerAd = BannerAd(
  //     adUnitId: 'ca-app-pub-3940256099942544/6300978111',
  //     size: AdSize.banner,
  //     request: AdRequest(),
  //     listener: AdListener(
  //       onAdLoaded: (ad) => setState(() => _isLoadedAd = true),
  //     ),
  //   )..load();
  // }

  // @override
  // void dispose() {
  //   _bannerAd?.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final _appVm = Provider.of<AppVm>(context);
    final _appUser = Provider.of<AppUser>(context);

    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          child: ViewmodelProvider<ExploreVm>(
              vm: ExploreVm(context),
              onInit: (vm) => vm.onInit(_appVm, _appUser),
              builder: (context, vm, appVm, appUser) {
                return Scaffold(
                  key: vm.scaffoldKey,
                  backgroundColor: Color(0xffF3F5F8),
                  body: RefreshIndicator(
                    onRefresh: () async {
                      vm.showFullLoader();
                    },
                    backgroundColor: Colors.blue,
                    color: Colors.white,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        controller: vm.scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 15.0,
                            ),
                            _topSectionBuilder(context, appUser),
                            SizedBox(
                              height: 5.0,
                            ),
                            Divider(),
                            vm.showLoader
                                ? Center(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            bottom: 250.0,
                                            child: Lottie.asset(
                                              'assets/lottie/game_loader.json',
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  100.0,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  100.0,
                                            ),
                                          ),
                                          Positioned.fill(
                                            bottom: 20.0,
                                            child: Center(
                                              child: Text(
                                                'Loading...',
                                                style: TextStyle(
                                                  color: Color(0xff3D4A5A),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      if (vm.videoStreams != null)
                                        VideoCarousel(vm.videoStreams, appUser),
                                      if (vm.videoStreams != null &&
                                          vm.videoStreams.isNotEmpty)
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                      if (vm.videoStreams != null &&
                                          vm.videoStreams.isNotEmpty)
                                        Divider(
                                          color: Color(0xff3D4A5A)
                                              .withOpacity(0.2),
                                        ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      if (vm.tournaments != null &&
                                          vm.liveTournaments.isNotEmpty)
                                        LiveTournamentList(vm.liveTournaments),
                                      if (vm.tournaments != null &&
                                          vm.liveTournaments.isNotEmpty)
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                      if (vm.tournaments != null &&
                                          vm.otherTournaments.isNotEmpty)
                                        TournamentList(vm.otherTournaments),
                                      SizedBox(
                                        height: 100.0,
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  floatingActionButton: appUser.admin
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FloatingActionButton(
                              backgroundColor: Colors.blue,
                              heroTag: 'create',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CreateTournamentScreen(),
                                  ),
                                );
                              },
                              child: Icon(Icons.add),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            FloatingActionButton(
                              backgroundColor: Colors.blue,
                              onPressed: vm.searchUser,
                              heroTag: 'search',
                              child: Icon(Icons.search),
                            ),
                          ],
                        )
                      : Container(),
                );
              }),
        ),
        if (_isLoadedAd)
          Positioned(
            bottom: 5.0,
            child: Center(
              child: Container(
                height: 50.0,
                width: MediaQuery.of(context).size.width,
                child: AdWidget(
                  ad: _bannerAd,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _topSectionBuilder(BuildContext context, final AppUser appUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (appUser.admin) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ActiveAndWorkerViewScreen(),
                  ),
                );
              }
            },
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5.0, right: 10.0),
                child: SvgPicture.asset(
                  'assets/images/svgs/home_tab.svg',
                  color: Color(0xff3D4A5A),
                ),
              ),
            ),
          ),
          // messages text
          Text(
            'Explore Tab',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                color: Color(0xff3D4A5A)),
          ),
          Image.asset(
            'assets/images/logo.png',
            width: 35.0,
            height: 35.0,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
