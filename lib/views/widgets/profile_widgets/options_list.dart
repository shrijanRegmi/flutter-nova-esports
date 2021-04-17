import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/app_config.dart';
import 'package:peaman/models/app_models/options_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/profile_vm.dart';
import 'package:peaman/views/widgets/profile_widgets/options_list_item.dart';
import 'package:provider/provider.dart';

class OptionsList extends StatelessWidget {
  final ProfileVm vm;
  OptionsList(this.vm);

  @override
  Widget build(BuildContext context) {
    final _appConfig = Provider.of<AppConfig>(context);
    final _appUser = Provider.of<AppUser>(context);

    return ListView.builder(
      itemCount: optionsList.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final _option = optionsList[index];
        final _isWatchAndEarn = _option.title == 'Watch and Earn';
        final _isShareApp = _option.title == 'Share App';
        final _isAboutApp = _option.title == 'About App';

        if (_isWatchAndEarn) {
          return FutureBuilder<bool>(
            future: vm.rewardedAd.isLoaded(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final _val = snapshot.data;
                if (_val) return OptionsListItem(_option);
              }
              return Container();
            },
          );
        }

        if (_isShareApp && _appConfig.appLink == '') {
          return Container();
        }

        if (_isAboutApp && _appConfig.aboutApp == '' && !_appUser.admin) {
          return Container();
        }

        return OptionsListItem(_option);
      },
    );
  }
}
