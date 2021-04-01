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
              'Active Users',
              AppUserProvider().activeUsers,
              Axis.horizontal,
            ),
            SizedBox(
              height: 40.0,
            ),
            _streamBuilder(
              'Workers',
              AppUserProvider().workerUsers,
              Axis.vertical,
            ),
          ],
        ),
      ),
    );
  }

  Widget _streamBuilder(
      final String title, final Stream stream, final Axis axis) {
    return StreamBuilder<List<AppUser>>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<List<AppUser>> snapshot) {
        if (snapshot.hasData) {
          final _users = snapshot.data ?? [];
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
  }
}
