import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/feed_model.dart';
import 'package:peaman/views/screens/friends_feed_viewer_screen.dart';
import 'package:peaman/views/screens/view_post_screen.dart';
import 'package:peaman/views/widgets/friends_profile_widgets/featured_posts_list_item.dart';

class FeaturedPostList extends StatelessWidget {
  final List<Feed> feeds;
  FeaturedPostList(this.feeds);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _featuredPostTextBuilder(context),
        SizedBox(
          height: 10.0,
        ),
        _featuredPostListBuilder(),
      ],
    );
  }

  Widget _featuredPostTextBuilder(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Featured Posts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Color(0xff3D4A5A),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FriendsFeedViewerScreen(
                  'Featured Posts',
                  feeds,
                  isFeaturedPosts: true,
                ),
              ),
            );
          },
          child: Container(
            color: Colors.transparent,
            child: Row(
              children: [
                Text(
                  'View All',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blue,
                  size: 14.0,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _featuredPostListBuilder() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: feeds.length <= 6 ? feeds.length : 6,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ViewFeedScreen('View Featured Post', feeds[index]),
              ),
            );
          },
          child: FeaturedPostListItem(
            feeds[index].photos[feeds[index].photos.length ~/ 3],
            feeds[index].photos.length,
          ),
        );
      },
    );
  }
}
