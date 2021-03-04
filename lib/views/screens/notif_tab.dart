import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/enums/notification_type.dart';
import 'package:peaman/models/app_models/follow_request_model.dart';
import 'package:peaman/viewmodels/notification_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/screens/follow_requests_screen.dart';
import 'package:peaman/views/widgets/common_widgets/avatar_builder.dart';
import 'package:peaman/views/widgets/notification_widgets/notifications_lists.dart';

class NotificationTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider<NotificationVm>(
      vm: NotificationVm(context),
      builder: (context, vm, appVm, appUser) {
        return Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _topSectionBuilder(context),
                vm.notifications == null
                    ? Center(
                        child: Lottie.asset(
                          'assets/lottie/loader.json',
                          width: MediaQuery.of(context).size.width - 100.0,
                          height: MediaQuery.of(context).size.width - 100.0,
                        ),
                      )
                    : Column(
                        children: [
                          if (vm.followRequests != null)
                            _followRequestBuilder(context, vm.followRequests),
                          if (vm.followRequests != null &&
                              vm.followRequests.isNotEmpty)
                            Divider(),
                          NotificationsList(
                            vm.notifications
                                .where((element) =>
                                    element.type !=
                                    NotificationType.followRequest)
                                .toList(),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _topSectionBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            children: <Widget>[
              // messages text
              Text(
                'Notifications',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: Color(0xff3D4A5A)),
              ),
              SizedBox(
                width: 10.0,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _followRequestBuilder(
      final BuildContext context, final List<FollowRequest> followNotifs) {
    return followNotifs.isEmpty
        ? Container()
        : InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FollowRequestScreen(followNotifs),
                ),
              );
            },
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Row(
                  children: <Widget>[
                    // user image
                    AvatarBuilder(
                      imgUrl: followNotifs[0].sender.photoUrl,
                      radius: 22.0,
                      count: followNotifs.length,
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Follow requests",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Color(0xff3D4A5A),
                          ),
                        ),
                        Text(
                          'Accept or ignore requests',
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            color: Colors.black38,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
