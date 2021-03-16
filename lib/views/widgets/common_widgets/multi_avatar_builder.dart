import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/views/widgets/common_widgets/avatar_builder.dart';

class MultiAvatarBuilder extends StatelessWidget {
  final List<AppUser> users;
  final double radius;
  MultiAvatarBuilder({
    @required this.users,
    this.radius = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        AvatarBuilder(
          imgUrl: users.length > 1 ? users[1].photoUrl : users[0].photoUrl,
          radius: radius,
        ),
        if (users.length >= 2)
          Positioned(
            left: 8.5,
            bottom: 8.0,
            child: Container(
              width: radius + 23.0,
              height: radius + 23.0,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xffF3F5F8),
                  width: 3.0,
                ),
                shape: BoxShape.circle,
              ),
              child: AvatarBuilder(
                imgUrl: users[0].photoUrl,
                radius: radius,
              ),
            ),
          ),
      ],
    );
  }
}
