import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/models/moment_model.dart';
import 'package:peaman/views/screens/moment_view_screen.dart';
import 'package:peaman/views/widgets/common_widgets/avatar_builder.dart';

class MomentsListItem extends StatelessWidget {
  final Moment moment;
  final List<Moment> moments;
  final AppUser appUser;
  MomentsListItem(
    this.moment,
    this.moments,
    this.appUser,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MomentViewScreen(
                moments,
                moments.indexOf(moment),
              ),
            ),
          );
        },
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    maxRadius: 31.0,
                    backgroundColor: (moment.isSeen ?? false)
                        ? Colors.grey[400]
                        : Colors.pink,
                  ),
                  Positioned.fill(
                    child: Center(
                      child: AvatarBuilder(
                        imgUrl: moment.owner.photoUrl,
                        radius: 28.0,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                moment.owner.uid == appUser.uid
                    ? 'You'
                    : moment.owner.name.split(' ').first,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  color: (moment.isSeen ?? false)
                      ? Colors.grey
                      : Color(0xff3D4A5A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
