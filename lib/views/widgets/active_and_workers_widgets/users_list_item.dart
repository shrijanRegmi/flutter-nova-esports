import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/views/screens/user_view_screen.dart';
import 'package:provider/provider.dart';

class UsersListItem extends StatelessWidget {
  final AppUser user;
  final Axis axis;
  UsersListItem(this.user, this.axis);

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);

    return axis == Axis.horizontal
        ? _horizontalBuilder(context, _appUser)
        : ListTile(
            leading: _imgBuilder(),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            onTap: () {
              if (_appUser.admin) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserViewScreen(user),
                  ),
                );
              }
            },
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${user.name}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff3D4A5A),
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    _userStatusBuilder(),
                  ],
                ),
                Text(
                  '${user.inGameName}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          );
  }

  Widget _imgBuilder({final double radius = 50.0}) {
    return Container(
      height: radius,
      width: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: user.photoUrl == null
            ? null
            : DecorationImage(
                image: CachedNetworkImageProvider('${user.photoUrl}'),
                fit: BoxFit.cover,
              ),
      ),
      child: user.photoUrl == null
          ? SvgPicture.asset(
              'assets/images/svgs/upload_img.svg',
              color: Colors.grey,
            )
          : Container(),
    );
  }

  Widget _horizontalBuilder(final BuildContext context, final AppUser appUser) {
    return GestureDetector(
      onTap: () {
        if (appUser.admin)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UserViewScreen(user),
            ),
          );
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    _imgBuilder(radius: 60.0),
                    Positioned(
                      bottom: 3.0,
                      right: 3.0,
                      child: CircleAvatar(
                        radius: 6.0,
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  '${user.name}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff3D4A5A),
                      fontSize: 12.0),
                ),
              ],
            ),
            SizedBox(
              width: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _userStatusBuilder() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (user.worker) _userStatusItem(title: 'Worker', color: Colors.green),
        if (user.admin)
          SizedBox(
            width: 5.0,
          ),
        if (user.admin) _userStatusItem(title: 'Admin', color: Colors.red),
      ],
    );
  }

  Widget _userStatusItem({
    final String title,
    final Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: color,
      ),
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
      child: Text(
        '$title',
        style: TextStyle(
          fontSize: 10.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
