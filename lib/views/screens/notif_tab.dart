import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/models/app_models/notification_model.dart';
import 'package:peaman/services/database_services/notif_provider.dart';
import 'package:peaman/viewmodels/notification_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/create_tournament_widgets/new_tournament_field.dart';
import 'package:peaman/views/widgets/notification_widgets/notifications_lists.dart';

class NotificationTab extends StatefulWidget {
  @override
  _NotificationTabState createState() => _NotificationTabState();
}

class _NotificationTabState extends State<NotificationTab> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ViewmodelProvider<NotificationVm>(
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
                            if (appUser.admin) _sendNotifBuilder(),
                            if (appUser.admin)
                              SizedBox(
                                height: 20.0,
                              ),
                            NotificationsList(vm.notifications),
                          ],
                        ),
                ],
              ),
            ),
          );
        },
      ),
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

  Widget _sendNotifBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          NewTournamentField(
            hintText: 'Noification title',
            controller: _titleController,
          ),
          SizedBox(
            height: 10.0,
          ),
          NewTournamentField(
            hintText: 'Noification body',
            controller: _bodyController,
            requiredCapitalization: false,
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: () async {
                  if (_titleController.text.trim() != '' &&
                      _bodyController.text.trim() != '') {
                    FocusScope.of(context).unfocus();
                    final _title = _titleController.text.trim();
                    final _body = _bodyController.text.trim();

                    final _notif = Notifications(
                      notifTitle: _title,
                      notifBody: _body,
                      updatedAt: DateTime.now().millisecondsSinceEpoch,
                    );
                    _titleController.clear();
                    _bodyController.clear();
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text('Sending...')),
                    );
                    final _result =
                        await NotificationProvider(notification: _notif)
                            .sendCustomNotif();
                    if (_result != null) {
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                            content: Text('Notification sent successfully')),
                      );
                    } else {
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(content: Text('Unexpected error occured !')),
                      );
                    }
                  }
                },
                color: Color(0xff5C49E0),
                child: Text(
                  'Send',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
