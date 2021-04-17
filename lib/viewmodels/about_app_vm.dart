import 'package:flutter/material.dart';
import 'package:peaman/helpers/dialog_provider.dart';
import 'package:peaman/models/app_models/app_config.dart';
import 'package:peaman/services/database_services/user_provider.dart';

class AboutAppVm extends ChangeNotifier {
  final BuildContext context;
  AboutAppVm(this.context);

  TextEditingController _aboutController = TextEditingController();
  TextEditingController _appLinkController = TextEditingController();

  TextEditingController get aboutController => _aboutController;
  TextEditingController get appLinkController => _appLinkController;

  // init function
  onInit(final AppConfig appConfig) {
    if (appConfig != null) {
      _initializeValue(appConfig);
    }
  }

  // initialize values
  _initializeValue(final AppConfig appConfig) {
    _aboutController.text = appConfig.aboutApp;
    _appLinkController.text = appConfig.appLink;
  }

  // save about app
  saveAboutApp(final AppConfig appConfig) {
    DialogProvider(context).showEditAboutDialog(
      _aboutController,
      _appLinkController,
      () async {
        final _appConfig = appConfig.copyWith(
          appLink: _appLinkController.text.trim(),
          aboutApp: _aboutController.text.trim(),
        );
        await AppUserProvider().updateAppConfig(_appConfig);
      },
    );
  }
}
