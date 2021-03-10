import 'package:flutter/material.dart';
import 'package:peaman/helpers/dialog_provider.dart';
import 'package:peaman/services/auth_services/auth_provider.dart';

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
    onPressed: null,
  ),
  Option(
    iconData: Icons.sports_esports,
    title: 'Registered Tournaments',
    onPressed: null,
  ),
  Option(
    iconData: Icons.video_library,
    title: 'Watch and Earn',
    onPressed: null,
  ),
  Option(
    iconData: Icons.bookmark,
    title: 'Saved Tournaments',
    onPressed: null,
  ),
  Option(
    iconData: Icons.logout,
    title: 'Log Out',
    onPressed: (final BuildContext context) async {
      await DialogProvider(context).showConfirmationDialog(
        'Are you sure you want to logout ?',
        () async {
          await AuthProvider().logOut();
        },
      );
    },
  ),
];
