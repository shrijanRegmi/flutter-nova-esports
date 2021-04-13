import 'package:flutter/material.dart';
import 'package:peaman/helpers/dialog_provider.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/auth_services/auth_provider.dart';
import 'package:peaman/services/messaging_services/firebase_messaging_provider.dart';
import 'package:peaman/views/screens/edit_profile_screen.dart';
import 'package:peaman/views/screens/registered_tournaments_screen.dart';
import 'package:provider/provider.dart';

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
  // Option(
  //   iconData: Icons.bookmark,
  //   title: 'Saved Tournaments',
  //   onPressed: null,
  // ),
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
