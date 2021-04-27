import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:peaman/enums/online_status.dart';
import 'package:peaman/models/app_models/app_config.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/profile_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/profile_widgets/options_list.dart';
import 'package:peaman/views/widgets/profile_widgets/social_links_list.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  BannerAd _bannerAd;
  bool _isLoadedAd = false;

  @override
  void initState() {
    super.initState();
    _handleBanner();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  _handleBanner() async {
    final _appConfig = Provider.of<AppConfig>(context, listen: false);
    _bannerAd = BannerAd(
      adUnitId: '${_appConfig?.bannerId}',
      size: AdSize.banner,
      request: AdRequest(),
      listener: AdListener(
        onAdFailedToLoad: (ad, error) => print('AD FAILED TO LOAD : $error'),
        onAdLoaded: (ad) => setState(() => _isLoadedAd = true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _appConfig = Provider.of<AppConfig>(context);

    return Scaffold(
      body: ViewmodelProvider<ProfileVm>(
        vm: ProfileVm(),
        onInit: (vm) => vm.onInit(_appConfig),
        builder: (context, vm, appVm, appUser) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                _headerBuilder(appUser),
                SizedBox(
                  height: 20.0,
                ),
                _userDetailBuilder(context, appUser),
                SizedBox(
                  height: 40.0,
                ),
                OptionsList(vm),
                if (_appConfig != null && _appConfig.socialLinks.isNotEmpty)
                  SocialLinkList(_appConfig.socialLinks),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: _isLoadedAd
                  ? Container(
                      height: 60.0,
                      child: AdWidget(ad: _bannerAd),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userDetailBuilder(BuildContext context, AppUser appUser) {
    final _width = MediaQuery.of(context).size.width * 0.50;
    return Column(
      children: <Widget>[
        Container(
          width: _width,
          height: _width,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 10.0,
            ),
            boxShadow: [
              BoxShadow(
                offset: Offset(2.0, 10.0),
                blurRadius: 20.0,
                color: Colors.black12,
              )
            ],
            image: appUser.photoUrl == null
                ? null
                : DecorationImage(
                    image: CachedNetworkImageProvider('${appUser.photoUrl}'),
                    fit: BoxFit.cover,
                  ),
          ),
          child: appUser.photoUrl == null
              ? SvgPicture.asset(
                  'assets/images/svgs/upload_img.svg',
                  color: Colors.grey,
                )
              : Container(),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          '${appUser.name}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: Color(0xff3D4A5A),
          ),
        ),
        Text(
          '${appUser.email}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
            color: Color(0xff3D4A5A),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 4.0,
              backgroundColor: appUser.onlineStatus == OnlineStatus.active
                  ? Colors.green
                  : Color(0xff9496ab),
            ),
            SizedBox(
              width: 8.0,
            ),
            Text(
              'Active Status',
              style: TextStyle(
                fontSize: 12.0,
                color: Color(0xff3D4A5A),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _headerBuilder(final AppUser appUser) {
    return Container(
      padding: const EdgeInsets.only(left: 20.0, top: 10.0),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/images/svgs/coin.svg',
            width: 50.0,
            height: 50.0,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            '${appUser.coins} Coins',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Color(0xff3D4A5A),
            ),
          ),
        ],
      ),
    );
  }
}
