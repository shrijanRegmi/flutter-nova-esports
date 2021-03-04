import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/follow_request_model.dart';
import 'package:peaman/models/app_models/notification_model.dart';
import 'package:provider/provider.dart';

class NotificationVm extends ChangeNotifier {
  final BuildContext context;
  NotificationVm(this.context);

  List<Notifications> get notifications =>
      Provider.of<List<Notifications>>(context);
  List<FollowRequest> get followRequests =>
      Provider.of<List<FollowRequest>>(context);
}
