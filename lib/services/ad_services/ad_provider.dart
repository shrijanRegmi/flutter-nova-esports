import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:peaman/models/app_models/app_config.dart';
import 'package:provider/provider.dart';

class AdProvider {
  static void init() {
    FacebookAudienceNetwork.init(
      testingId: "059c4ef8-0035-4c32-864d-b739b6dd8bc6", //optional
    );
  }

  static Widget banner(final BuildContext context) {
    final _appConfig = Provider.of<AppConfig>(context, listen: false);

    return FacebookBannerAd(
      placementId: '${_appConfig.bannerId}',
      bannerSize: BannerSize.STANDARD,
      listener: (result, value) {
        switch (result) {
          case BannerAdResult.ERROR:
            print("Error: $value");
            break;
          case BannerAdResult.LOADED:
            print("Loaded: $value");
            break;
          case BannerAdResult.CLICKED:
            print("Clicked: $value");
            break;
          case BannerAdResult.LOGGING_IMPRESSION:
            print("Logging Impression: $value");
            break;
        }
      },
    );
  }

  static void loadInterstitial(final BuildContext context) {
    final _appConfig = Provider.of<AppConfig>(context, listen: false);
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: "${_appConfig.interstitialId}",
      listener: (result, value) {
        if (result == InterstitialAdResult.ERROR) print("The error is: $value");
        if (result == InterstitialAdResult.LOADED)
          FacebookInterstitialAd.showInterstitialAd(delay: 100);
      },
    );
  }

  static void loadRewarded(final BuildContext context,
      final Function onVideoFailed, final Function onVideoComplete) {
    final _appConfig = Provider.of<AppConfig>(context, listen: false);

    FacebookRewardedVideoAd.loadRewardedVideoAd(
      placementId: "${_appConfig.rewardId}",
      listener: (result, value) {
        if (result == RewardedVideoAdResult.LOADED)
          FacebookRewardedVideoAd.showRewardedVideoAd();
        if (result == RewardedVideoAdResult.VIDEO_COMPLETE) onVideoComplete();
        if (result == RewardedVideoAdResult.ERROR) {
          print(value);
          onVideoFailed();
        }
      },
    );
  }
}
