import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/views/widgets/active_and_workers_widgets/users_list_item.dart';

class UsersList extends StatelessWidget {
  final List<AppUser> users;
  final Axis axis;
  final String title;
  UsersList(
    this.users, {
    this.axis = Axis.vertical,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: _titleBuilder(),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          height: axis == Axis.horizontal ? 90.0 : null,
          child: ListView.builder(
            shrinkWrap: axis == Axis.horizontal ? false : true,
            itemCount: users.length,
            scrollDirection: axis,
            physics: axis == Axis.horizontal
                ? AlwaysScrollableScrollPhysics()
                : NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final _user = users[index];
              final _widget = UsersListItem(_user, axis);
              if (index == 0 && axis == Axis.horizontal) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: _widget,
                );
              }
              return _widget;
            },
          ),
        ),
      ],
    );
  }

  Widget _titleBuilder() {
    return Row(
      children: [
        Text(
          '$title',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff3D4A5A),
            fontSize: 18.0,
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Divider(),
        ),
      ],
    );
  }
}
