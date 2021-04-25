import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/app_config.dart';
import 'package:peaman/models/app_models/social_links_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialLinkListItem extends StatelessWidget {
  final SocialLink socialLink;
  SocialLinkListItem(this.socialLink);

  @override
  Widget build(BuildContext context) {
    final _appConfig = Provider.of<AppConfig>(context);
    final _appUser = Provider.of<AppUser>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: GestureDetector(
        onTap: () async {
          try {
            await launch(
              socialLink.socialLink.contains('https://') ||
                      socialLink.socialLink.contains('http://')
                  ? socialLink.socialLink
                  : 'https://' + socialLink.socialLink,
            );
          } catch (e) {
            print(e);
          }
        },
        onDoubleTap: () {
          if (_appUser.admin) {
            final _list = _appConfig.socialLinks;
            _list.removeWhere((e) => e.socialLink == socialLink.socialLink);
            final _newAppConfig = _appConfig.copyWith(
              socialLinks: _list,
            );
            AppUserProvider().updateAppConfig(_newAppConfig);
          }
        },
        child: CachedNetworkImage(
          imageUrl: socialLink.imgUrl,
          width: 50.0,
          height: 50.0,
        ),
      ),
    );
  }
}
