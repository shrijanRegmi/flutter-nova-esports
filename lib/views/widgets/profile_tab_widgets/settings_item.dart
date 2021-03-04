import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peaman/enums/online_status.dart';
import 'package:peaman/models/app_models/settings_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/auth_services/auth_provider.dart';
import 'package:peaman/services/database_services/user_provider.dart';
import 'package:peaman/views/screens/personal_info_screen.dart';

class SettingsItem extends StatelessWidget {
  final AppUser appUser;
  final int index;
  final SettingModel settings;
  SettingsItem({this.appUser, this.index, this.settings});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigate(context),
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            children: <Widget>[
              _iconBuilder(),
              SizedBox(
                width: 20.0,
              ),
              _titleBuilder(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconBuilder() {
    return Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xff3D4A5A).withOpacity(0.1),
      ),
      child: Center(
        child: SvgPicture.asset(settings.imgPath),
      ),
    );
  }

  Widget _titleBuilder() {
    return Text(
      '${settings.title}',
      style: TextStyle(fontSize: 16.0, color: Color(0xff3D4A5A)),
    );
  }

  void _navigate(BuildContext context) {
    Widget _screen;
    switch (index) {
      case 0:
        _screen = PersonalInfoScreen(
          uid: appUser.uid,
          imgUrl: appUser.photoUrl,
          name: appUser.name,
          email: appUser.email,
          status: appUser.profileStatus,
        );
        break;
      default:
        AuthProvider().logOut();
        AppUserProvider(uid: appUser.uid)
            .setUserActiveStatus(onlineStatus: OnlineStatus.away);
    }
    if (_screen != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => _screen),
      );
    }
  }
}
