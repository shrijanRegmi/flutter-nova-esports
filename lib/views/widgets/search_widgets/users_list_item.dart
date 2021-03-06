import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:peaman/enums/online_status.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/views/widgets/common_widgets/avatar_builder.dart';

class UserListItem extends StatelessWidget {
  final AppUser friend;
  UserListItem({this.friend});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => FriendProfileScreen(
        //       friend,
        //       fromSearch: true,
        //     ),
        //   ),
        // );
      },
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  // user image
                  AvatarBuilder(
                    imgUrl: friend?.photoUrl,
                    radius: 25.0,
                    isOnline: friend.onlineStatus == OnlineStatus.active,
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  _textBuilder(context, friend),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textBuilder(BuildContext context, final AppUser friend) {
    final _scrSize = MediaQuery.of(context).size.width;

    return Container(
      width: _scrSize / 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // user name
          AutoSizeText(
            "${friend?.name}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            minFontSize: 16.0,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Color(0xff3D4A5A),
            ),
          ),
          SizedBox(
            height: 3.0,
          ),
          // user status
          AutoSizeText(
            "${friend?.profileStatus}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            minFontSize: 12.0,
            style: TextStyle(
              fontSize: 12.0,
              color: Color(0xff3D4A5A),
            ),
          ),
        ],
      ),
    );
  }
}
