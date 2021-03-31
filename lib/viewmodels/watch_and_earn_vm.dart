import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:peaman/helpers/dialog_provider.dart';
import 'package:peaman/models/app_models/app_config.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/user_provider.dart';
import 'package:provider/provider.dart';

class WatchAndEarnVm extends ChangeNotifier {
  final BuildContext context;
  WatchAndEarnVm(this.context);

  Timer _timer;
  int _counter = 5;
  int _rewardedCount = 0;
  bool _onPressedWatch = false;
  bool _adFailed = false;
  TextEditingController _maxViewsController = TextEditingController();
  TextEditingController _rewardCoinsController = TextEditingController();
  TextEditingController _timerController = TextEditingController();
  TextEditingController _interstitialController = TextEditingController();
  TextEditingController _bannerController = TextEditingController();
  TextEditingController _rewardedController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int get counter => _counter;
  bool get onPressedWatch => _onPressedWatch;
  bool get adFailed => _adFailed;
  int get rewardedCount => _rewardedCount;
  TextEditingController get maxViewsController => _maxViewsController;
  TextEditingController get rewardCoinsController => _rewardCoinsController;
  TextEditingController get timerController => _timerController;
  TextEditingController get interstitialController => _interstitialController;
  TextEditingController get bannerController => _bannerController;
  TextEditingController get rewardedController => _rewardedController;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  RewardedAd _rewardedAd;
  AdListener _listener;

  RewardedAd get rewardedAd => _rewardedAd;

  // init function
  onInit(final AppConfig config, final AppUser appUser) async {
    if (config != null && appUser != null) {
      _updateCounter(config.adShowTimer ?? 5);
      _initializeValues(config, appUser);
      _handleRewarded(config);
    }
  }

  // dispose function
  onDis() {
    _timer?.cancel();
    _rewardedAd?.dispose();
  }

  // initialize values
  _initializeValues(final AppConfig config, final AppUser appUser) {
    _maxViewsController.text = '${config.maxAdViews}' ?? '5';
    _timerController.text = '${config.adShowTimer}' ?? '5';
    _rewardCoinsController.text = '${config.rewardCoins}' ?? '5';
    _bannerController.text = '${config.bannerId}';
    _interstitialController.text = '${config.interstitialId}';
    _rewardedController.text = '${config.rewardId}';
    _rewardedCount = appUser.completedTasks;

    notifyListeners();
  }

  // initialize rewarded
  _handleRewarded(final AppConfig appConfig) async {
    _listener = AdListener(
      onAdLoaded: (Ad ad) async {
        print('Ad loaded.');
        notifyListeners();
      },
      onAdFailedToLoad: (Ad ad, LoadAdError error) async {
        ad.dispose();
        print('Ad failed to load: $error');
        _updateAdFailed(true);
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
        _onRewarded();
      },
    );
    _rewardedAd = RewardedAd(
      adUnitId: '${appConfig.rewardId}',
      request: AdRequest(),
      listener: _listener,
    );
    await _rewardedAd.load();
    notifyListeners();
  }

  // when user receives reward
  _onRewarded() async {
    final _appUser = Provider.of<AppUser>(context, listen: false);
    _updateRewardedCount(_rewardedCount + 1);
    await _rewardedAd.load();
    notifyListeners();
    await AppUserProvider(uid: _appUser.uid).updateUserDetail(
      data: {
        'completed_tasks': _rewardedCount,
        'last_task_done_at': DateTime.now().millisecondsSinceEpoch,
      },
    );
    if (_rewardedCount >= int.parse(_maxViewsController.text.trim())) {
      DialogProvider(context).showCoinsEarnDialog(
        int.parse(_rewardCoinsController.text.trim()),
        () {},
      );
      await AppUserProvider(uid: _appUser.uid).updateUserDetail(
        data: {
          'coins': int.parse(_rewardCoinsController.text.trim()),
        },
      );
    }
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

  // on pressed watch
  watchAd(final AppConfig appConfig) {
    _updateCounter(appConfig?.adShowTimer ?? 5);
    _updateOnPressedWatch(true);
    _updateAdFailed(false);
    _timer = Timer.periodic(
      Duration(milliseconds: 1000),
      (timer) {
        if (_counter <= 0) {
          timer.cancel();
          showAd();
          _updateCounter(appConfig?.adShowTimer ?? 5);
          _updateOnPressedWatch(false);
        } else {
          _updateCounter(_counter - 1);
        }
      },
    );
  }

  // update configs
  updateConfig(final AppConfig appConfig) async {
    final _condition = _maxViewsController.text.trim() != '' &&
        _timerController.text.trim() != '' &&
        _rewardCoinsController.text.trim() != '' &&
        _bannerController.text.trim() != '' &&
        _interstitialController.text.trim() != '' &&
        _rewardedController.text.trim() != '';

    if (_condition) {
      final _appConfig = appConfig.copyWith(
        maxAdViews: int.parse(_maxViewsController.text.trim()),
        adShowTimer: int.parse(_timerController.text.trim()),
        rewardCoins: int.parse(_rewardCoinsController.text.trim()),
        bannerId: _bannerController.text.trim(),
        interstitialId: _interstitialController.text.trim(),
        rewardId: _rewardedController.text.trim(),
      );
      FocusScope.of(context).unfocus();
      final _result = await AppUserProvider().updateAppConfig(_appConfig);
      if (_result != null) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Configs Updated !'),
          ),
        );
      } else {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Unexpected error occured! Try again.'),
          ),
        );
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please fill up all the fields.'),
        ),
      );
    }
  }

  // update value of counter
  _updateCounter(final int newVal) {
    _counter = newVal;
    notifyListeners();
  }

  // update value of rewarded count
  _updateRewardedCount(final int newVal) {
    _rewardedCount = newVal;
    notifyListeners();
  }

  // update value of on pressed watch
  _updateOnPressedWatch(final bool newVal) {
    _onPressedWatch = newVal;
    notifyListeners();
  }

  // update value of ad failed
  _updateAdFailed(final bool newVal) {
    _adFailed = newVal;
    notifyListeners();
  }
}
