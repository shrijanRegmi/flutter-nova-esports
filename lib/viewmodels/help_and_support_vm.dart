import 'package:flutter/material.dart';
import 'package:peaman/helpers/dialog_provider.dart';
import 'package:peaman/models/app_models/app_config.dart';
import 'package:peaman/services/database_services/user_provider.dart';

class HelpAndSupportVm extends ChangeNotifier {
  final BuildContext context;
  HelpAndSupportVm(this.context);

  TextEditingController _supportEmailController = TextEditingController();
  TextEditingController get supportEmailController => _supportEmailController;

  // init function
  onInit(final AppConfig appConfig) {
    if (appConfig != null) {
      _initializeValues(appConfig);
    }
  }

  // initialize values
  _initializeValues(final AppConfig appConfig) {
    _supportEmailController.text = appConfig.supportEmail;
  }

  // save support email
  saveSupportEmail(final AppConfig appConfig) {
    DialogProvider(context).showSupportEmailDialog(
      _supportEmailController,
      () async {
        final _appConfig = appConfig.copyWith(
          supportEmail: _supportEmailController.text.trim(),
        );
        await AppUserProvider().updateAppConfig(_appConfig);
      },
    );
  }
}
