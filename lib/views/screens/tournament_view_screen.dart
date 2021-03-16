import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/helpers/date_time_helper.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/tournament_view_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/screens/enter_team_code_screen.dart';
import 'package:peaman/views/screens/match_up_screen.dart';
import 'package:peaman/views/screens/register_screen.dart';
import 'package:peaman/views/widgets/tournament_widgets/join_team.dart';
import 'package:peaman/views/widgets/tournament_widgets/updates_list.dart';
import 'package:provider/provider.dart';

class TournamentViewScreen extends StatelessWidget {
  final Tournament tournament;
  TournamentViewScreen(this.tournament);

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    return ViewmodelProvider<TournamentViewVm>(
      vm: TournamentViewVm(context),
      onInit: (vm) => vm.onInit(tournament, _appUser),
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          body: vm.isLoading
              ? Center(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        bottom: 100.0,
                        child: Lottie.asset(
                          'assets/lottie/game_loader.json',
                          width: MediaQuery.of(context).size.width - 100.0,
                          height: MediaQuery.of(context).size.width - 100.0,
                        ),
                      ),
                      Positioned.fill(
                        top: 100.0,
                        child: Center(
                          child: Text(
                            'Loading...',
                            style: TextStyle(
                              color: Color(0xff3D4A5A),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _headerBuilder(context, vm, appUser),
                      SizedBox(
                        height: 50.0,
                      ),
                      if (vm.thisTournament.users.contains(appUser.uid))
                        JoinTeam(vm.thisTournament, vm),
                      if (vm.thisTournament.users.contains(appUser.uid))
                        SizedBox(
                          height: 20.0,
                        ),
                      UpdatesList(vm.team),
                    ],
                  ),
                ),
          bottomNavigationBar: vm.isLoading
              ? null
              : Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: _playBtnBuilder(context, appUser, vm),
                ),
          floatingActionButton:
              vm.isLoading || vm.thisTournament.users.contains(appUser.uid)
                  ? null
                  : _enterTeamCodeBtnBuilder(context, appUser, vm),
        );
      },
    );
  }

  Widget _headerBuilder(
    final BuildContext context,
    final TournamentViewVm vm,
    final AppUser appUser,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _imgBuilder(vm),
        Positioned(
          bottom: -33.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _actionBtnBuilder(context, vm, appUser),
            ],
          ),
        ),
      ],
    );
  }

  Widget _imgBuilder(final TournamentViewVm vm) {
    return Stack(
      children: [
        Container(
          height: 200.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(vm.thisTournament.imgUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 200.0,
          decoration: BoxDecoration(
            color: Colors.black45,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _liveBuilder(),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  '${vm.thisTournament.title}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${DateTimeHelper().getFormattedDate(DateTime.fromMillisecondsSinceEpoch(vm.thisTournament.date))} ${vm.thisTournament.time}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionBtnBuilder(
    final BuildContext context,
    final TournamentViewVm vm,
    final AppUser appUser,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            offset: Offset(0.0, 3.0),
            blurRadius: 10.0,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: [
          _btnBuilder(Icons.assignment, 'Details', () {}),
          Container(
            height: 40.0,
            width: 2.0,
            color: Colors.grey[300],
          ),
          _btnBuilder(
            Icons.mediation,
            'Match-ups',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MatchUpScreen(vm.thisTournament, vm.team),
                ),
              );
            },
            isEnabled: vm.team != null && vm.team.users.length > 1,
          ),
          Container(
            height: 40.0,
            width: 2.0,
            color: Colors.grey[300],
          ),
          _btnBuilder(
            Icons.chat,
            'Chat',
            () {
              vm.navigateToChats(appUser);
            },
            isEnabled: vm.team != null && vm.team.users.length > 1,
          ),
        ],
      ),
    );
  }

  Widget _btnBuilder(
      final IconData icon, final String title, final Function onPressed,
      {final bool isEnabled = true}) {
    return GestureDetector(
      onTap: isEnabled ? onPressed : () {},
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Icon(
                icon,
                color: isEnabled ? Colors.black : Colors.grey,
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                '$title',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  color: isEnabled ? Colors.black : Colors.grey,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _liveBuilder() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.circle,
                color: Colors.white,
                size: 10.0,
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                'Live',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _playBtnBuilder(final BuildContext context, final AppUser appUser,
      final TournamentViewVm vm) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: MaterialButton(
        onPressed: vm.thisTournament.users.contains(appUser.uid)
            ? null
            : () {
                if (!vm.thisTournament.users.contains(appUser.uid))
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RegisterScreen(vm.thisTournament, vm),
                    ),
                  );
              },
        color: Color(0xffdc8843),
        disabledColor: Colors.grey,
        disabledTextColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(
              vm.thisTournament.users.contains(appUser.uid) ? 23.0 : 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                vm.thisTournament.users.contains(appUser.uid)
                    ? 'PLAY'
                    : 'REGISTER',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (!vm.thisTournament.users.contains(appUser.uid))
                SizedBox(
                  width: 30.0,
                ),
              if (!vm.thisTournament.users.contains(appUser.uid))
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/svgs/coin.svg',
                      width: 30.0,
                      height: 30.0,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      '${vm.thisTournament.entryCost}',
                      style: TextStyle(
                        // color: Color(0xffdc8843),
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _enterTeamCodeBtnBuilder(final BuildContext context,
      final AppUser appUser, final TournamentViewVm vm) {
    return Material(
      borderRadius: BorderRadius.circular(100.0),
      elevation: 2.0,
      color: Colors.blue,
      child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EnterTeamCodeScreen(vm.thisTournament, vm),
              ),
            );
          },
          borderRadius: BorderRadius.circular(100.0),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            color: Colors.transparent,
            child: Text(
              'Enter Team Code',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          )),
    );
  }
}
