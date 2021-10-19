import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/chat_model.dart';
import 'package:peaman/models/app_models/video_stream_model.dart';
import 'package:peaman/services/database_services/game_provider.dart';
import 'package:peaman/services/database_services/message_provider.dart';
import 'package:peaman/services/database_services/notif_provider.dart';
import 'package:peaman/services/database_services/tournament_provider.dart';
import 'package:peaman/services/database_services/user_provider.dart';
import 'package:peaman/viewmodels/temp_img_vm.dart';
import 'package:provider/provider.dart';
import 'package:peaman/models/app_models/notification_model.dart';
import 'models/app_models/level_model.dart';
import 'models/app_models/tournament_model.dart';
import 'models/app_models/user_model.dart';

class WrapperBuilder extends StatelessWidget {
  final Function(BuildContext context, AppUser appUser) builder;
  WrapperBuilder({@required this.builder});

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AppUser>(context);
    if (_user != null) {
      return MultiProvider(
        providers: [
          StreamProvider<AppUser>.value(
            value: AppUserProvider(uid: _user?.uid).appUser,
          ),
          StreamProvider<List<AppUser>>.value(
            value: AppUserProvider(uid: _user.uid).allUsers,
          ),
          StreamProvider<List<Chat>>.value(
            value: MessageProvider(appUserId: _user.uid).chatList,
          ),
          StreamProvider<List<Notifications>>.value(
            value: NotificationProvider(appUser: _user).notificationsList,
          ),
          ChangeNotifierProvider<TempImgVm>(
            create: (_) => TempImgVm(),
          ),
          StreamProvider<List<Tournament>>.value(
            value: TournamentProvider().tournamentsList,
          ),
          StreamProvider<List<VideoStream>>.value(
            value: TournamentProvider().videoStreamsList,
          ),
          StreamProvider<List<Level>>.value(
            value: GameProvider().levelsList,
          ),
        ],
        child: builder(context, _user),
      );
    } else {
      return builder(context, _user);
    }
  }
}
