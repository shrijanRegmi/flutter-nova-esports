import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/follow_request_model.dart';
import 'package:peaman/views/widgets/notification_widgets/follow_request_list_item.dart';

class FollowRequestList extends StatelessWidget {
  final List<FollowRequest> followRequests;
  FollowRequestList(this.followRequests);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: followRequests.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final _followReq = followRequests[index];

        return FollowRequestListItem(_followReq);
      },
    );
  }
}
