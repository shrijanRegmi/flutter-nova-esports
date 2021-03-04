import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/models/app_models/follow_request_model.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:peaman/views/widgets/notification_widgets/follow_request_list.dart';

class FollowRequestScreen extends StatelessWidget {
  final List<FollowRequest> followNotifs;
  FollowRequestScreen(this.followNotifs);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3F5F8),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: SafeArea(
          child: CommonAppbar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Color(0xff3D4A5A),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Row(
              children: <Widget>[
                Text(
                  'Follow Requests',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Color(0xff3D4A5A),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: followNotifs == null
              ? Center(
                  child: Lottie.asset(
                    'assets/lottie/loader.json',
                    width: MediaQuery.of(context).size.width - 100.0,
                    height: MediaQuery.of(context).size.width - 100.0,
                  ),
                )
              : FollowRequestList(followNotifs),
        ),
      ),
    );
  }
}
