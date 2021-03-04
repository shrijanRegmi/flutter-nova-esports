import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/feed_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/app_vm.dart';
import 'package:peaman/viewmodels/friend_feed_viewer_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/feed_loader.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/feeds_list.dart';
import 'package:provider/provider.dart';

class FriendsFeedViewerScreen extends StatelessWidget {
  final String title;
  final List<Feed> feeds;
  final bool isFeaturedPosts;
  FriendsFeedViewerScreen(
    this.title,
    this.feeds, {
    this.isFeaturedPosts = false,
  });

  @override
  Widget build(BuildContext context) {
    final _appVm = Provider.of<AppVm>(context);
    final _appUser = Provider.of<AppUser>(context);

    return ViewmodelProvider<FriendFeedViewerVm>(
      vm: FriendFeedViewerVm(),
      onInit: (vm) {
        vm.onInit(
          _appVm,
          _appUser,
          feeds,
          feeds[0].owner,
          isFeaturedPosts,
        );
      },
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          backgroundColor: Color(0xffF3F5F8),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: CommonAppbar(
              title: Text(
                '$title',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Color(0xff3D4A5A),
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              controller: vm.scrollController,
              child: Column(
                children: [
                  FeedsList(vm.thisFeeds),
                  if (appVm.isLoadingOldFeeds)
                    FeedLoader(
                      count: 1,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
