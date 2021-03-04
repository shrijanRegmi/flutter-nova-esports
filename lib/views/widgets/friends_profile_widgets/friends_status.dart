import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/user_model.dart';

class FriendStatus extends StatelessWidget {
  final AppUser user;
  FriendStatus(this.user);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _itemBuilder(user.photos, 'Photos'),
        _itemBuilder(user.followers, 'Followers'),
        _itemBuilder(user.following, 'Following'),
      ],
    );
  }

  Widget _itemBuilder(final int _count, final String _title) {
    return Column(
      children: [
        Text(
          '$_count',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Color(0xff3D4A5A),
          ),
        ),
        Text(
          '$_title',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
