import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/feed_model.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/feeds_list_item.dart';

class FeedsList extends StatelessWidget {
  final List<Feed> feeds;
  FeedsList(this.feeds);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: feeds.length,
      itemBuilder: (context, index) {
        return FeedsListItem(feeds[index]);
      },
    );
  }
}
