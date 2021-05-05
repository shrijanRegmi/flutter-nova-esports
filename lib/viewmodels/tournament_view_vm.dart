import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:peaman/enums/tournament_type.dart';
import 'package:peaman/helpers/dialog_provider.dart';
import 'package:peaman/models/app_models/app_config.dart';
import 'package:peaman/models/app_models/chat_model.dart';
import 'package:peaman/models/app_models/team_model.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/tournament_provider.dart';
import 'package:peaman/views/screens/chat_convo_screen.dart';
import 'package:peaman/views/screens/match_up_screen.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class TournamentViewVm extends ChangeNotifier {
  final BuildContext context;
  TournamentViewVm(this.context);

  Team _team;
  bool _isLoading = false;
  TextEditingController _teamCodeController = TextEditingController();
  Tournament _thisTournament;
  bool _isShowingDetails = false;
  TextEditingController _passController = TextEditingController();
  InterstitialAd _interstitialAd;
  AdListener _adListener;
  bool _isCopied = false;

  Team get team => _team;
  bool get isLoading => _isLoading;
  TextEditingController get teamCodeController => _teamCodeController;
  Tournament get thisTournament => _thisTournament;
  bool get isShowingDetails => _isShowingDetails;
  bool get isCopied => _isCopied;

  // init function
  onInit(final Tournament tournament, final AppUser appUser,
      final AppConfig appConfig) async {
    if (tournament != null) {
      updateTournament(tournament);
      _updateIsLoading(true);
      if (tournament.users.contains(appUser.uid)) {
        await getTeam(tournament, appUser);
        await Future.delayed(Duration(milliseconds: 1000));
      } else {
        updateIsShowingDetails(true);
        await Future.delayed(Duration(milliseconds: 2000));
      }
      _updateIsLoading(false);
    }

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

  // get team
  getTeam(final Tournament tournament, final AppUser appUser) async {
    final _team =
        await TournamentProvider(tournament: tournament, appUser: appUser)
            .getTeam();
    _updateTeam(_team);
  }

  // share link
  shareTeamCode(final Tournament tournament) async {
    await Share.share(
      '${tournament.title}: ${_team.id}',
      subject: 'Here is our team code. Join my team in NOVA ESPORTS.',
    );
  }

  // copy password
  copyPassword() async {
    await Clipboard.setData(ClipboardData(text: '${_thisTournament.id}'));
    _isCopied = true;
    notifyListeners();
  }

  // join team
  joinTeam(final Tournament tournament, final AppUser appUser,
      final TournamentViewVm vm) async {
    if (_teamCodeController.text.trim() != '') {
      if (appUser.coins >= tournament.entryCost) {
        if (await _interstitialAd.isLoaded()) _interstitialAd.show();
        _updateIsLoading(true);
        await Future.delayed(Duration(milliseconds: 1300));
        final _result = await TournamentProvider(
          context: context,
          appUser: appUser,
          tournament: tournament,
        ).joinTournament(_teamCodeController.text.trim(), vm);
        if (_result == null) {
          _updateIsLoading(false);
        }
      } else {
        await DialogProvider(context).showWarningDialog(
          'Insufficient Coins',
          "You don't have enough coins to join team in this tournament. Please check our watch and earn tab to watch videos and earn coins.",
          () {},
        );
      }
    }
  }

  // navigate to chats
  navigateToChats(final AppUser appUser) {
    final _chats = Provider.of<List<Chat>>(context, listen: false) ?? [];
    final _thisChat =
        _chats.firstWhere((chat) => chat.id == _team.id, orElse: () => null);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatConvoScreen(
          friend: null,
          chat: _thisChat,
          team: _team,
        ),
      ),
    );
  }

  // start tournament
  startTournament() async {
    await DialogProvider(context).showConfirmationDialog(
      'Are you sure you want to start the tournament ?',
      () async {
        await TournamentProvider(tournament: _thisTournament).updateTournament(
          data: {
            'is_live': true,
          },
        );
        final _newTournament = _thisTournament.copyWith(
          isLive: true,
        );
        updateTournament(_newTournament);
      },
    );
  }

  // stop tournament
  stopTournament() async {
    await DialogProvider(context).showConfirmationDialog(
      'Are you sure you want to stop the tournament ?',
      () async {
        await TournamentProvider(tournament: _thisTournament).updateTournament(
          data: {
            'is_live': false,
          },
        );
        final _newTournament = _thisTournament.copyWith(
          isLive: false,
        );
        updateTournament(_newTournament);
      },
    );
  }

  // on pressed registered or team code
  onBtnPressed(final AppUser appUser,
      final Widget Function(Tournament, TournamentViewVm) screen) async {
    if (_thisTournament.tournamentType != TournamentType.private) {
      if (!_thisTournament.users.contains(appUser.uid)) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen(_thisTournament, this)),
        );
      } else if (_thisTournament.isLive) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MatchUpScreen(_team),
          ),
        );
      }
    } else {
      await DialogProvider(context).showPrivateTournamentDialog(
        _passController,
        () async {
          final _pass = _passController.text.trim();
          if (_pass == _thisTournament.id) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => screen(_thisTournament, this),
              ),
            );
          } else {
            await DialogProvider(context).showWarningDialog(
              'Wrong password',
              'The password you entered is not correct. Try again !',
              () {},
            );
          }
        },
      );
      _passController.clear();
    }
  }

  // update value of team
  _updateTeam(final Team newVal) {
    _team = newVal;
    notifyListeners();
  }

  // update value of is loading
  _updateIsLoading(final bool newVal) {
    _isLoading = newVal;
    notifyListeners();
  }

  // update value of tournament
  updateTournament(final Tournament newVal) {
    _thisTournament = newVal;
    notifyListeners();
  }

  // update value of is showing details
  updateIsShowingDetails(final bool newVal) {
    _isShowingDetails = newVal;
    notifyListeners();
  }
}
