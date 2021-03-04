import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/feed_model.dart';
import 'package:peaman/views/screens/friends_feed_viewer_screen.dart';
import 'package:peaman/views/screens/view_post_screen.dart';
import 'package:peaman/views/widgets/friends_profile_widgets/posts_list_item.dart';

class PostsList extends StatelessWidget {
  final List<Feed> feeds;
  PostsList(this.feeds);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _postsTextBuilder(context),
        SizedBox(
          height: 10.0,
        ),
        _postsGridBuilder(),
      ],
    );
  }

  Widget _postsTextBuilder(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Posts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Color(0xff3D4A5A),
          ),
        ),
        // if (feeds.length > 6)
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FriendsFeedViewerScreen('Posts', feeds),
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

  Widget _postsGridBuilder() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        crossAxisCount: 3,
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: feeds.length <= 6 ? feeds.length : 6,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ViewFeedScreen('View Post', feeds[index]),
              ),
            );
          },
          child: PhotosItem(
            feeds[index].photos[feeds[index].photos.length ~/ 3],
          ),
        );
      },
    );
  }
}
