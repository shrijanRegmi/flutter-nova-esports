import 'package:flutter/material.dart';
import 'package:peaman/helpers/dialog_provider.dart';
import 'package:peaman/models/app_models/app_config.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/auth_services/auth_provider.dart';
import 'package:peaman/services/messaging_services/firebase_messaging_provider.dart';
import 'package:peaman/views/screens/about_app_screen.dart';
import 'package:peaman/views/screens/edit_profile_screen.dart';
import 'package:peaman/views/screens/help_and_support.dart';
import 'package:peaman/views/screens/registered_tournaments_screen.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class Option {
  final IconData iconData;
  final String title;
  final Function(BuildContext) onPressed;
  Option({
    this.iconData,
    this.title,
    this.onPressed,
  });
}

final optionsList = <Option>[
  Option(
    iconData: Icons.person,
    title: 'Edit Profile',
    onPressed: (final BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditProfileScreen(),
        ),
      );
    },
  ),
  Option(
    iconData: Icons.sports_esports,
    title: 'Registered Tournaments',
    onPressed: (final BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RegisteredTournamentsViewScreen(),
        ),
      );
    },
  ),
  Option(
    iconData: Icons.share,
    title: 'Share App',
    onPressed: (final BuildContext context) async {
      final _appConfig = Provider.of<AppConfig>(context, listen: false);

      if (_appConfig != null) {
        await Share.share(
          '${_appConfig.appLink}',
          subject: 'Download the best freefire tournament app.',
        );
      }
    },
  ),
  Option(
    iconData: Icons.book,
    title: 'About App',
    onPressed: (final BuildContext context) async {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AboutAppScreen(),
        ),
      );
    },
  ),
  Option(
    iconData: Icons.help,
    title: 'Help And Support',
    onPressed: (final BuildContext context) async {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HelpAndSupportScreen(),
        ),
      );
    },
  ),
  Option(
    iconData: Icons.logout,
    title: 'Log Out',
    onPressed: (final BuildContext context) async {
      final _appUser = Provider.of<AppUser>(context, listen: false);

      await DialogProvider(context).showConfirmationDialog(
        'Are you sure you want to logout ?',
        () async {
          FirebaseMessagingProvider(context: context, uid: _appUser.uid)
              .removeDevice();
          await AuthProvider().logOut();
        },
      );
    },
  ),
  // Option(
  //   iconData: Icons.video_library,
  //   title: 'Watch and Earn',
  //   onPressed: (final BuildContext context) async {
  //     final _profileVm = Provider.of<ProfileVm>(context, listen: false);
  //     await DialogProvider(context).showWarningDialog(
  //       'Watch and Earn',
  //       'Watch ads and earn coin which you can spend on joining tournaments !',
  //       () {
  //         _profileVm.showAd();
  //       },
  //     );
  //   },
  // ),
];
