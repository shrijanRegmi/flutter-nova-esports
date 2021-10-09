import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/enums/match_type.dart';
import 'package:peaman/enums/tournament_type.dart';
import 'package:peaman/helpers/date_time_helper.dart';
import 'package:peaman/helpers/dialog_provider.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/app_vm.dart';
import 'package:peaman/viewmodels/tournament_view_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/screens/enter_team_code_screen.dart';
import 'package:peaman/views/screens/match_up_screen.dart';
import 'package:peaman/views/screens/register_screen.dart';
import 'package:peaman/views/widgets/tournament_widgets/join_team.dart';
import 'package:peaman/views/widgets/tournament_widgets/tournament_details.dart';
import 'package:peaman/views/widgets/tournament_widgets/updates_list.dart';
import 'package:provider/provider.dart';

class TournamentViewScreen extends StatefulWidget {
  final Tournament tournament;
  TournamentViewScreen(this.tournament);

  @override
  _TournamentViewScreenState createState() => _TournamentViewScreenState();
}

class _TournamentViewScreenState extends State<TournamentViewScreen>
    with SingleTickerProviderStateMixin {
  Animation _slideAnimation;
  AnimationController _slideAnimationController;

  @override
  void initState() {
    super.initState();
    _slideAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(begin: Offset(0.65, 0), end: Offset(0, 0))
        .animate(_slideAnimationController);

    _slideAnimationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    final _appVm = Provider.of<AppVm>(context);
    return ViewmodelProvider<TournamentViewVm>(
      vm: TournamentViewVm(context),
      onInit: (vm) {
        _appVm.updateSelectedTournament(widget.tournament);
        vm.onInit(widget.tournament, _appUser, null);
      },
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
              : Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _headerBuilder(context, vm, appUser),
                            SizedBox(
                              height: 20.0,
                            ),
                            vm.isShowingDetails
                                ? TournamentDetails(vm)
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (vm.thisTournament.users
                                              .contains(appUser.uid) &&
                                          vm.thisTournament.type !=
                                              MatchType.solo)
                                        JoinTeam(vm.thisTournament, vm),
                                      if (vm.thisTournament.users
                                              .contains(appUser.uid) &&
                                          vm.thisTournament.type !=
                                              MatchType.solo)
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                      UpdatesList(vm.team),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 70.0, right: 10.0),
                          child: _actionBtnBuilder(context, vm, appUser),
                        ),
                      ),
                    ),
                  ],
                ),
          bottomNavigationBar: vm.isLoading
              ? null
              : Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: _playBtnBuilder(context, appUser, vm),
                ),
          floatingActionButton: vm.isLoading ||
                  vm.thisTournament.users.contains(appUser.uid) ||
                  vm.thisTournament.isLive ||
                  vm.thisTournament.type == MatchType.solo
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
        _imgBuilder(vm, context, appUser),
        // Positioned(
        //   bottom: -33.0,
        //   left: 0.0,
        //   right: 0.0,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       _actionBtnBuilder(context, vm, appUser),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Widget _imgBuilder(final TournamentViewVm vm, final BuildContext context,
      final AppUser appUser) {
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
                if (vm.thisTournament.isLive)
                  _liveBuilder(vm, appUser)
                else if (appUser.admin)
                  _startTournamentBtnBuilder(context, appUser, vm)
                else
                  Center(),
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
    final _currentDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final _isAlreadyRegistered = vm.thisTournament.users.contains(appUser.uid);
    final _isTeamComplete =
        (vm.team?.userIds?.length ?? 0) >= vm.thisTournament.getPlayersCount();
    final _isRegistrationExpired =
        DateTime.fromMillisecondsSinceEpoch(vm.thisTournament.registrationEnd)
            .isBefore(_currentDate);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: 'arrow',
          child: Padding(
            padding: EdgeInsets.only(
                left: _slideAnimationController.isCompleted ? 0.0 : 5.0),
            child: Icon(
              _slideAnimationController.isCompleted
                  ? Icons.arrow_forward_ios
                  : Icons.arrow_back_ios,
            ),
          ),
          onPressed: () {
            if (_slideAnimationController.isCompleted) {
              _slideAnimationController.reverse();
            } else {
              _slideAnimationController.reset();
              _slideAnimationController.forward();
            }
          },
        ),
        SizedBox(
          width: 10.0,
        ),
        Container(
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
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _btnBuilder(Icons.assignment, 'Details', () {
                _slideAnimationController.reverse();
                if (vm.team != null) {
                  vm.updateIsShowingDetails(!vm.isShowingDetails);
                }
              }),
              Container(
                height: 40.0,
                width: 2.0,
                color: Colors.grey[300],
              ),
              _btnBuilder(Icons.mediation, 'Match-ups', () {
                _slideAnimationController.reverse();
                if (appUser.admin || appUser.worker) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MatchUpScreen(vm.team),
                    ),
                  );
                } else {
                  if (!_isRegistrationExpired &&
                      !_isTeamComplete &&
                      _isAlreadyRegistered) {
                    DialogProvider(context).showWarningDialog(
                      'Team not complete',
                      "Your team does not have ${vm.thisTournament.getPlayersCount()} players to play this tournament.",
                      () {},
                    );
                  }

                  if (_isRegistrationExpired && !_isTeamComplete) {
                    DialogProvider(context).showWarningDialog(
                      'Registration period expired',
                      "The registration period for this tournament has ended. You cannot join this tournament now.",
                      () {},
                    );
                  }
                  if (!_isRegistrationExpired && _isTeamComplete) {
                    DialogProvider(context).showWarningDialog(
                      'Registration period has not ended',
                      "The registration period for this tournament is not completed yet. You will be able to view the lobbies after the registration period completes.",
                      () {},
                    );
                  }

                  if (_isRegistrationExpired && _isTeamComplete) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MatchUpScreen(vm.team),
                      ),
                    );
                  }
                }
              },
                  isEnabled: appUser.admin ||
                      appUser.worker ||
                      !((_isRegistrationExpired && !_isTeamComplete) ||
                          (!_isRegistrationExpired &&
                              !_isTeamComplete &&
                              _isAlreadyRegistered) ||
                          (!_isRegistrationExpired && _isTeamComplete))),
              Container(
                height: 40.0,
                width: 2.0,
                color: Colors.grey[300],
              ),
              _btnBuilder(
                Icons.chat,
                'Chat',
                () {
                  if (vm.team != null && vm.team.users.length > 1) {
                    _slideAnimationController.reverse();
                    vm.navigateToChats(appUser);
                  }
                },
                isEnabled: vm.team != null && vm.team.users.length > 1,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _btnBuilder(
      final IconData icon, final String title, final Function onPressed,
      {final bool isEnabled = true}) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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

  Widget _liveBuilder(final TournamentViewVm vm, final AppUser appUser) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
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
          if (appUser.admin)
            IconButton(
              iconSize: 30.0,
              icon: Icon(
                Icons.cancel,
              ),
              color: Colors.red,
              onPressed: vm.stopTournament,
            ),
        ],
      ),
    );
  }

  Widget _playBtnBuilder(final BuildContext context, final AppUser appUser,
      final TournamentViewVm vm) {
    final _currentDate = DateTime.now();
    final _registrationEndTime = TimeOfDay(
      hour: int.parse(vm.thisTournament.registrationEndTime.substring(0, 2)),
      minute: int.parse(vm.thisTournament.registrationEndTime.substring(5, 7)),
    );
    final _registrationEndDate =
        DateTime.fromMillisecondsSinceEpoch(vm.thisTournament.registrationEnd)
            .add(Duration(
      hours: vm.thisTournament.registrationEndTime.contains('PM')
          ? _registrationEndTime.hour + 12
          : _registrationEndTime.hour,
      minutes: _registrationEndTime.minute,
    ));

    final _isAlreadyRegistered = vm.thisTournament.users.contains(appUser.uid);
    final _isTeamComplete =
        (vm.team?.userIds?.length ?? 0) >= vm.thisTournament.getPlayersCount();
    final _isRegistrationExpired =
        _registrationEndDate.isBefore(_currentDate) ||
            _registrationEndDate.isAtSameMomentAs(_currentDate);
    final _notInState =
        vm.thisTournament.tournamentType == TournamentType.state &&
            (appUser.address == null ||
                !appUser.address.contains('${vm.thisTournament.state}'));

    return Padding(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () async {
          if (_notInState) {
            return DialogProvider(context).showWarningDialog(
              '${vm.thisTournament.state} Tournament',
              "This is ${vm.thisTournament.state} tournament. You cannot register in this tournament",
              () {},
            );
          }
          if (_isRegistrationExpired && !_isTeamComplete) {
            return DialogProvider(context).showWarningDialog(
              'Registration period expired',
              "The registration period for this tournament has ended. You cannot join this tournament now.",
              () {},
            );
          }
          if (!_isRegistrationExpired && _isTeamComplete) {
            return DialogProvider(context).showWarningDialog(
              'Registration period has not ended',
              "The registration period for this tournament is not completed yet. You will be able to view the lobbies after the registration period completes.",
              () {},
            );
          }

          if (!_isRegistrationExpired &&
              !_isTeamComplete &&
              _isAlreadyRegistered) {
            return DialogProvider(context).showWarningDialog(
              'Team not complete',
              "Your team does not have ${vm.thisTournament.getPlayersCount()} players to play this tournament.",
              () {},
            );
          }

          if (_isRegistrationExpired && _isTeamComplete) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MatchUpScreen(vm.team),
              ),
            );
          }
        },
        child: MaterialButton(
          onPressed: (_isRegistrationExpired && !_isTeamComplete) ||
                  (!_isRegistrationExpired &&
                      !_isTeamComplete &&
                      _isAlreadyRegistered) ||
                  (!_isRegistrationExpired && _isTeamComplete) ||
                  _notInState
              ? null
              : () {
                  if (_isTeamComplete) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MatchUpScreen(vm.team),
                      ),
                    );
                  } else {
                    vm.onBtnPressed(
                      appUser,
                      (a, b) => RegisterScreen(a, b),
                    );
                  }
                },
          color: Color(0xffdc8843),
          disabledColor: Colors.grey,
          disabledTextColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(_isAlreadyRegistered ? 23.0 : 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isAlreadyRegistered ? 'PLAY' : 'REGISTER',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (!_isAlreadyRegistered)
                  SizedBox(
                    width: 30.0,
                  ),
                if (!_isAlreadyRegistered)
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
          onTap: () => vm.onBtnPressed(
                appUser,
                (a, b) => EnterTeamCodeScreen(a, b),
              ),
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

  Widget _startTournamentBtnBuilder(final BuildContext context,
      final AppUser appUser, final TournamentViewVm vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          borderRadius: BorderRadius.circular(100.0),
          elevation: 2.0,
          color: Colors.blue,
          child: InkWell(
              onTap: () => vm.startTournament(),
              borderRadius: BorderRadius.circular(100.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                color: Colors.transparent,
                child: Text(
                  'Start Tournament',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ),
              )),
        ),
      ],
    );
  }
}
