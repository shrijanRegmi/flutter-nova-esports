import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:peaman/models/app_models/app_config.dart';
import 'package:peaman/models/app_models/team_model.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/tournament_provider.dart';
import 'package:peaman/viewmodels/tournament_view_vm.dart';

class RegisterVm extends ChangeNotifier {
  final BuildContext context;
  RegisterVm(this.context);
  final TextEditingController _teamNameController = TextEditingController();
  bool _isLoading = false;
  InterstitialAd _interstitialAd;
  AdListener _adListener;

  TextEditingController get teamNameController => _teamNameController;
  bool get isLoading => _isLoading;

  // init function
  onInit(final AppConfig appConfig) {
    if (appConfig != null) {
      _handleInterstitialAd(appConfig);
    }
  }

  // dispose function
  onDis() {
    _interstitialAd?.dispose();
  }

  // handle interstitial ad
  _handleInterstitialAd(final AppConfig appConfig) {
    _adListener = AdListener(
      onAdLoaded: (Ad ad) => print('Ad loaded.'),
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
        print('Ad failed to load: $error');
      },
      onAdOpened: (Ad ad) => print('Ad opened.'),
      onAdClosed: (Ad ad) {
        ad.dispose();
        print('Ad closed.');
      },
      onApplicationExit: (Ad ad) => print('Left application.'),
    );
    _interstitialAd = InterstitialAd(
      adUnitId: '${appConfig.interstitialId}',
      listener: _adListener,
      request: AdRequest(),
    )..load();
  }

  // register team
  registerTeam(final Tournament tournament, final AppUser appUser,
      final TournamentViewVm vm) async {
    if (_teamNameController.text.trim() != '') {
      _interstitialAd.show();
      _updateIsLoading(true);
      final _team = Team(
        users: [appUser],
        userIds: [appUser.uid],
        teamName: _teamNameController.text.trim(),
      );
      final _result = await TournamentProvider(
        tournament: tournament,
        appUser: appUser,
        team: _team,
      ).register();
      if (_result != null) {
        final _tournament = vm.thisTournament.copyWith(
          users: [...vm.thisTournament.users, appUser.uid],
        );
        vm.updateTournament(_tournament);
        vm.updateIsShowingDetails(false);
        vm.getTeam(tournament, appUser);
        Navigator.pop(context);
      } else {
        _updateIsLoading(false);
      }
    }
  }

  // update value of is loading
  _updateIsLoading(final bool newVal) {
    _isLoading = newVal;
    notifyListeners();
  }
}
