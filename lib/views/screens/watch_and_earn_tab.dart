import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/app_config.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/viewmodels/watch_and_earn_vm.dart';
import 'package:peaman/views/widgets/common_widgets/filled_btn.dart';
import 'package:peaman/views/widgets/create_tournament_widgets/new_tournament_field.dart';
import 'package:provider/provider.dart';

class WatchAndEarn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _appConfig = Provider.of<AppConfig>(context);
    final _appUser = Provider.of<AppUser>(context);
    return _appConfig == null
        ? Scaffold()
        : ViewmodelProvider<WatchAndEarnVm>(
            vm: WatchAndEarnVm(context),
            onInit: (vm) => vm.onInit(_appConfig, _appUser),
            builder: (context, vm, appVm, appUser) {
              return Scaffold(
                key: vm.scaffoldKey,
                body: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Container(
                    color: Colors.transparent,
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _subHeaderBuilder(),
                          SizedBox(
                            height: 30.0,
                          ),
                          _completedTaskBuilder(vm, _appConfig),
                          SizedBox(
                            height: 30.0,
                          ),
                          _howToBuilder(),
                          SizedBox(
                            height: 50.0,
                          ),
                          FilledBtn(
                            title: vm.adFailed
                                ? 'Failed to Load! Try Again'
                                : vm.onPressedWatch
                                    ? 'Please Wait...'
                                    : vm.onTimerStart
                                        ? 'New video in ${vm.counter}'
                                        : 'Watch Now',
                            color: Color(0xff3D4A5A),
                            onPressed: vm.rewardedCount >=
                                    (_appConfig?.maxAdViews ?? 5)
                                ? null
                                : () => vm.watchAd(_appConfig),
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          Text(
                            'Note: You can only watch videos ${_appConfig?.maxAdViews} times per day',
                            style: TextStyle(
                              color: Color(0xff3D4A5A),
                            ),
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          if (appUser.admin)
                            _updateConfigBuilder(vm, _appConfig),
                          if (appUser.admin)
                            SizedBox(
                              height: 50.0,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }

  Widget _subHeaderBuilder() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff3D4A5A),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(
                height: 10.0,
              ),
              Icon(
                Icons.video_collection_rounded,
                size: 100.0,
                color: Colors.white,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Watch more to earn more'.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
              Text(
                'Watch video to earn reward everyday !',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _completedTaskBuilder(
      final WatchAndEarnVm vm, final AppConfig appConfig) {
    return Column(
      children: [
        Text(
          'Completed task'.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
            color: Color(0xff3D4A5A),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: Color(0xff3D4A5A),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Text(
            '${vm.rewardedCount} / ${appConfig?.maxAdViews}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
              color: Color(0xff3D4A5A),
            ),
          ),
        ),
      ],
    );
  }

  Widget _howToBuilder() {
    return Column(
      children: [
        Text(
          'How does reward work ?'.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Color(0xff3D4A5A),
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _howToItemBuilder('Watch Video', Icons.video_collection),
            Icon(
              Icons.keyboard_arrow_right,
              size: 30.0,
              color: Color(0xff3D4A5A),
            ),
            _howToItemBuilder('Get Reward', Icons.emoji_events),
            Icon(
              Icons.keyboard_arrow_right,
              size: 30.0,
              color: Color(0xff3D4A5A),
            ),
            _howToItemBuilder('Join Match', Icons.sports_esports),
          ],
        ),
      ],
    );
  }

  Widget _howToItemBuilder(final String title, final IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: 30.0,
          color: Color(0xff3D4A5A),
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(
          '$title',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff3D4A5A),
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }

  Widget _updateConfigBuilder(
      final WatchAndEarnVm vm, final AppConfig appConfig) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.0,
          ),
          Text(
            'Update ads config'.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff3D4A5A),
              fontSize: 14.0,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          NewTournamentField(
            hintText: 'Reward coins',
            controller: vm.rewardCoinsController,
            textInputType: TextInputType.number,
          ),
          SizedBox(
            height: 10.0,
          ),
          NewTournamentField(
            hintText: 'Max ads per day',
            controller: vm.maxViewsController,
            textInputType: TextInputType.number,
          ),
          SizedBox(
            height: 10.0,
          ),
          NewTournamentField(
            hintText: 'Ad show timer',
            controller: vm.timerController,
            textInputType: TextInputType.number,
          ),
          SizedBox(
            height: 10.0,
          ),
          Divider(),
          SizedBox(
            height: 10.0,
          ),
          NewTournamentField(
            hintText: 'Banner ID',
            controller: vm.bannerController,
            textInputType: TextInputType.number,
          ),
          SizedBox(
            height: 10.0,
          ),
          NewTournamentField(
            hintText: 'Interstitial ID',
            controller: vm.interstitialController,
            textInputType: TextInputType.number,
          ),
          SizedBox(
            height: 10.0,
          ),
          NewTournamentField(
            hintText: 'Rewarded ID',
            controller: vm.rewardedController,
            textInputType: TextInputType.number,
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: () => vm.updateConfig(appConfig),
                color: Color(0xff5C49E0),
                child: Text(
                  'Update',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
