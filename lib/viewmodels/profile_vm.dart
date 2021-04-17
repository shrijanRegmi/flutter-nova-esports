import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:peaman/models/app_models/app_config.dart';

class ProfileVm extends ChangeNotifier {
  RewardedAd _rewardedAd;
  AdListener _listener;

  RewardedAd get rewardedAd => _rewardedAd;
  TextEditingController _appLinkController = TextEditingController();
  TextEditingController get appLinkController => _appLinkController;

  // init function
  onInit(final AppConfig appConfig) async {
    _handleRewarded();
    if (appConfig != null) {
      _initializeValues(appConfig);
    }
  }

  // initialize values
  _initializeValues(final AppConfig appConfig) {
    _appLinkController.text = appConfig.appLink;
  }

  // initialize rewarded
  _handleRewarded() async {
    _listener = AdListener(
      onAdLoaded: (Ad ad) async {
        print('Ad loaded.');
        notifyListeners();
      },
      onAdFailedToLoad: (Ad ad, LoadAdError error) async {
        ad.dispose();
        print('Ad failed to load: $error');
      },
      onAdOpened: (Ad ad) => print('Ad opened.'),
      onAdClosed: (Ad ad) async {
        ad.dispose();
        print('Ad closed.');
        await _rewardedAd.load();
        notifyListeners();
      },
      onApplicationExit: (Ad ad) => print('Left application.'),
      onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) async {
        print('Reward earned: $reward');
        await _rewardedAd.load();
        notifyListeners();
      },
    );
    _rewardedAd = RewardedAd(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917',
      request: AdRequest(),
      listener: _listener,
    );
    await _rewardedAd.load();
    notifyListeners();
  }

  // show rewarded ad
  showAd() async {
    if (await _rewardedAd.isLoaded()) {
      _rewardedAd.show();
    } else {
      _rewardedAd.load();
      _rewardedAd.show();
    }
  }
}
