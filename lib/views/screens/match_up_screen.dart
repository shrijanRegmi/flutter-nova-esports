import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:peaman/models/app_models/app_config.dart';
import 'package:peaman/models/app_models/team_model.dart';
import 'package:peaman/viewmodels/app_vm.dart';
import 'package:peaman/viewmodels/match_up_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/screens/add_team_screen.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:peaman/views/widgets/matchup_widgets/lobbies_list.dart';
import 'package:provider/provider.dart';

class MatchUpScreen extends StatefulWidget {
  final Team team;
  MatchUpScreen(this.team);

  @override
  _MatchUpScreenState createState() => _MatchUpScreenState();
}

class _MatchUpScreenState extends State<MatchUpScreen> {
  int _selectedRound = 1;

  BannerAd _bannerAd;
  bool _isLoadedAd = false;

  @override
  void initState() {
    super.initState();
    final _appVm = Provider.of<AppVm>(context, listen: false);
    setState(() {
      _selectedRound = _appVm.selectedTournament.activeRound;
    });
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
        onAdLoaded: (ad) => setState(() => _isLoadedAd = true),
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    final _appVm = Provider.of<AppVm>(context);
    return ViewmodelProvider<MatchUpVm>(
      vm: MatchUpVm(context),
      onInit: (vm) => vm.onInit(_appVm.selectedTournament),
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: CommonAppbar(
              title: Text(
                'Match Ups',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Color(0xff3D4A5A),
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _roundSelectionBuilder(),
                  LobbiesList(
                    vm,
                    vm.thisTournament,
                    widget.team,
                    _selectedRound,
                  ),
                ],
              ),
            ),
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
          floatingActionButton: !appUser.admin
              ? null
              : Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                  child: _addTeamBuilder(context, vm),
                ),
        );
      },
    );
  }

  Widget _roundSelectionBuilder() {
    final _items = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: DropdownButton(
        items: _items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  'Round $e',
                ),
              ),
            )
            .toList(),
        underline: Container(),
        value: _selectedRound,
        onChanged: (val) => setState(() => _selectedRound = val),
      ),
    );
  }

  Widget _addTeamBuilder(final BuildContext context, final MatchUpVm vm) {
    return Material(
      borderRadius: BorderRadius.circular(100.0),
      elevation: 2.0,
      color: Colors.blue,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddTeamScreen(vm.thisTournament),
            ),
          );
        },
        borderRadius: BorderRadius.circular(100.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          color: Colors.transparent,
          child: Text(
            'Add Team',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
