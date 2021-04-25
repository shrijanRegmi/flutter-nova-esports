import 'package:flutter/material.dart';
import 'package:peaman/helpers/dialog_provider.dart';
import 'package:peaman/models/app_models/app_config.dart';
import 'package:peaman/models/app_models/social_links_model.dart';
import 'package:peaman/services/database_services/user_provider.dart';
import 'package:peaman/services/storage_services/app_storage_service.dart';

class AboutAppVm extends ChangeNotifier {
  final BuildContext context;
  AboutAppVm(this.context);

  TextEditingController _aboutController = TextEditingController();
  TextEditingController _appLinkController = TextEditingController();
  TextEditingController _socialLinkController = TextEditingController();
  TextEditingController _imgUrlController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController get aboutController => _aboutController;
  TextEditingController get appLinkController => _appLinkController;
  TextEditingController get socialLinkController => _socialLinkController;
  TextEditingController get imgUrlController => _imgUrlController;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

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

  // save social link
  saveSocialLink(final AppConfig appConfig) {
    DialogProvider(context).showAddSocialLinksDialog(
      linkController: _socialLinkController,
      onPressed: (img) async {
        if (_socialLinkController.text.trim() != '' && img != null) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Uploading the social link..."),
          ));
          final _imgUrl = await AppStorage().uploadSocialLink(imgFile: img);
          if (_imgUrl != null) {
            final _socialLink = SocialLink(
              socialLink: _socialLinkController.text.trim(),
              imgUrl: _imgUrl,
            );
            final _appConfig = appConfig.copyWith(
              socialLinks: [...appConfig.socialLinks, _socialLink],
            );
            final _result = await AppUserProvider().updateAppConfig(_appConfig);

            if (_result != null) {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text("Uploaded the social link"),
              ));
            } else {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text("Unexpected error occured"),
              ));
            }
          } else {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Unexpected error occured"),
            ));
          }
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              "You must select an image and enter the link to continue !",
            ),
          ));
        }
      },
    );
  }
}
