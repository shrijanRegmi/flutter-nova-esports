import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/settings_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/views/widgets/profile_tab_widgets/settings_item.dart';

class GeneralSettingsList extends StatelessWidget {
  final AppUser appUser;
  GeneralSettingsList({this.appUser});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: generalSettings.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return SettingsItem(
          appUser: appUser,
          index: index,
          settings: generalSettings[index],
        );
      },
      separatorBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Divider(),
        );
      },
    );
  }
}
