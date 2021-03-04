import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/feed_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/feed_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/feed_loader.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/feeds_list_item.dart';
import 'package:provider/provider.dart';

class ViewFeedScreen extends StatelessWidget {
  final String title;
  final Feed feed;
  final String feedId;
  ViewFeedScreen(
    this.title,
    this.feed, {
    this.feedId,
  });

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);

    return ViewmodelProvider<FeedVm>(
      vm: FeedVm(context: context),
      onInit: (vm) => vm.onInit(_appUser, feed, feedId),
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
            child: vm.isLoading
                ? FeedLoader(
                    count: 1,
                  )
                : FeedsListItem(vm.thisFeed)
          ),
        );
      },
    );
  }
}
