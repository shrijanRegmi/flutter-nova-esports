import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/feed_model.dart';
import 'package:peaman/models/app_models/user_model.dart';

class PeopleWhoReacted extends StatelessWidget {
  final Feed feed;
  final AppUser appUser;
  PeopleWhoReacted(
    this.feed,
    this.appUser,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: feed.reactorsPhoto.isNotEmpty ? 28.0 : 0.0,
      child: Row(
        children: [
          if (feed.reactorsPhoto.isNotEmpty)
            Container(
              width: feed.reactorsPhoto.length == 3
                  ? 60.0
                  : feed.reactorsPhoto.length == 2
                      ? 45.0
                      : 30.0,
              child: Stack(
                children: _getChildren(),
              ),
            ),
          if (feed.reactionCount != null)
            Expanded(
              child: Text(
                feed.isReacted
                    ? feed.reactionCount == 1 || feed.reactionCount == 0
                        ? 'Reacted by You'
                        : 'Reacted by You and ${feed.reactionCount - 1} ${feed.reactionCount >= 3 ? 'others' : 'other'}'
                    : feed.initialReactor == null ||
                            (feed.initialReactor != null &&
                                feed.initialReactor.uid == appUser.uid)
                        ? 'Reacted by ${feed.reactionCount} ${feed.reactionCount >= 2 ? 'others' : 'other'}'
                        : feed.reactionCount <= 1
                            ? 'Reacted by ${feed.initialReactor.name}'
                            : 'Reacted by ${feed.initialReactor.name} and ${feed.reactionCount - 1} ${feed.reactionCount >= 3 ? 'others' : 'other'}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  color: Color(0xff3D4A5A),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _getChildren() {
    List<Widget> _list = [];
    for (int i = 0; i < feed.reactorsPhoto.length; i++) {
      final _pos = i * 14;
      _list.add(
        Positioned(
          left: _pos.toDouble(),
          child: Container(
            width: 27.0,
            height: 27.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Color(0xffF3F5F8),
                width: 3.0,
              ),
            ),
            child: Center(
              child: Container(
                width: 27.0,
                height: 27.0,
                decoration: BoxDecoration(
                  color: Color(0xff3D4A5A).withOpacity(0.1),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      feed.reactorsPhoto[i],
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return _list;
  }
}
