import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/user_provider.dart';
import 'package:peaman/views/widgets/active_and_workers_widgets/users_list.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';

class ActiveAndWorkerViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: CommonAppbar(
          title: Text(
            'View Users',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Color(0xff3D4A5A),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _streamBuilder(
              'Active Workers',
              AppUserProvider().activeUsers,
              Axis.horizontal,
            ),
            SizedBox(
              height: 40.0,
            ),
            _streamBuilder(
              'Admins and Workers',
              AppUserProvider().workerUsers,
              Axis.vertical,
              extraStream: AppUserProvider().adminUsers,
            ),
          ],
        ),
      ),
    );
  }

  Widget _streamBuilder(
    final String title,
    final Stream stream,
    final Axis axis, {
    final Stream extraStream,
  }) {
    _streamBuilder(final List<AppUser> moreUsers) =>
        StreamBuilder<List<AppUser>>(
          stream: stream,
          builder:
              (BuildContext context, AsyncSnapshot<List<AppUser>> snapshot) {
            if (snapshot.hasData) {
              final _users = snapshot.data ?? [];

              moreUsers.forEach((element) {
                final _existingUserIds = _users.map((e) => e.uid).toList();
                final _alreadyContains = _existingUserIds.contains(element.uid);

                if (!_alreadyContains) {
                  _users.insert(0, element);
                }
              });

              return UsersList(
                _users,
                axis: axis,
                title: title,
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          },
        );

    if (extraStream != null) {
      return StreamBuilder<List<AppUser>>(
        stream: extraStream,
        builder: (BuildContext context, AsyncSnapshot<List<AppUser>> snapshot) {
          if (snapshot.hasData) {
            final _users = snapshot.data ?? [];
            return _streamBuilder(_users);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Container();
        },
      );
    }

    return _streamBuilder(<AppUser>[]);
  }
}
