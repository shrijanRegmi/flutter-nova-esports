import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/app_vm.dart';
import 'package:peaman/viewmodels/explore_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/screens/create_post_screen.dart';
import 'package:peaman/views/screens/search_screen.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/feed_loader.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/feeds_list.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/moments_list.dart';
import 'package:provider/provider.dart';

class ExploreTab extends HookWidget {
  final TabController tabController;
  ExploreTab(this.tabController);

  @override
  Widget build(BuildContext context) {
    final _appVm = Provider.of<AppVm>(context);
    final _appUser = Provider.of<AppUser>(context);
    final _animationController = useAnimationController();

    return ViewmodelProvider<ExploreVm>(
        vm: ExploreVm(context),
        onInit: (vm) => vm.onInit(_appVm, _appUser),
        builder: (context, vm, appVm, appUser) {
          return Scaffold(
            key: vm.scaffoldKey,
            backgroundColor: Color(0xffF3F5F8),
            body: RefreshIndicator(
              onRefresh: () async {
                if (!vm.isShowingTopLoader && appVm.feeds != null) {
                  vm.getNewFeeds(appVm, appUser);
                  appVm.getMoments(appUser);
                }
              },
              backgroundColor: Colors.blue,
              color: Colors.white,
              child: SingleChildScrollView(
                controller: vm.scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15.0,
                    ),
                    _topSectionBuilder(context),
                    SizedBox(
                      height: 5.0,
                    ),
                    Divider(),
                    SizedBox(
                      height: 5.0,
                    ),
                    MomentsList(
                      moments: appVm.isLoadingMoments ? [] : appVm.moments,
                      createMoment: vm.createMoment,
                      appUser: appUser,
                      appVm: appVm,
                    ),
                    Divider(
                      color: Color(0xff3D4A5A).withOpacity(0.2),
                    ),
                    appVm.feeds == null || appVm.isLoadingFeeds
                        ? FeedLoader()
                        : Column(
                            children: [
                              if (appUser.newFeeds)
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      !vm.isShowingTopLoader
                                          ? _loadNewFeedsBuilder(
                                              vm, appVm, appUser)
                                          : Container(
                                              height: 40.0,
                                            ),
                                    ],
                                  ),
                                ),
                              appVm.feeds.isEmpty
                                  ? _emptyChat(context, _animationController)
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (appVm.isLoadingNewFeeds)
                                          FeedLoader(
                                            count: 1,
                                          ),
                                        FeedsList(appVm.feeds),
                                        if (appVm.isLoadingOldFeeds)
                                          FeedLoader(
                                            count: 1,
                                          ),
                                      ],
                                    ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            floatingActionButton: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appUser.newFeeds && vm.isShowingTopLoader
                    ? Padding(
                        padding: const EdgeInsets.only(top: 40.0, left: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _loadNewFeedsBuilder(vm, appVm, appUser),
                          ],
                        ),
                      )
                    : Container(),
                FloatingActionButton(
                  backgroundColor: Colors.blue,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CreatePostScreen(tabController),
                      ),
                    );
                  },
                  child: Icon(Icons.create),
                ),
              ],
            ),
          );
        });
  }

  Widget _loadNewFeedsBuilder(
      final ExploreVm vm, final AppVm appVm, final AppUser appUser) {
    return GestureDetector(
      onTap: () => vm.getNewFeeds(appVm, appUser),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Row(
          children: [
            Text(
              'New post',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            Icon(
              Icons.replay_outlined,
              size: 15.0,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _topSectionBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: SvgPicture.asset(
              'assets/images/svgs/home_tab.svg',
              color: Color(0xff3D4A5A),
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
          // searchbar
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SearchScreen(),
                ),
              );
            },
            child: Container(
              color: Colors.transparent,
              child: SvgPicture.asset('assets/images/svgs/search_icon.svg'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyChat(
      BuildContext context, AnimationController _animationController) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Lottie.asset(
          'assets/lottie/chat_empty.json',
          width: MediaQuery.of(context).size.width - 150.0,
          height: MediaQuery.of(context).size.width - 150.0,
          controller: _animationController,
          onLoaded: (comp) {
            _animationController
              ..duration = Duration(milliseconds: 3000)
              ..repeat();
          },
        ),
        Text(
          "Your newsline is empty.",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Color(0xff3D4A5A)),
        ),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Tap the "search" icon in top right corner and follow a user, if they accept, you will see their posts.',
            style: TextStyle(
              fontSize: 14.0,
              color: Color(0xff3D4A5A),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
