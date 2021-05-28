import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/enums/online_status.dart';
import 'package:peaman/models/app_models/chat_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/user_provider.dart';
import 'package:peaman/services/messaging_services/firebase_messaging_provider.dart';
import 'package:peaman/viewmodels/home_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/screens/explore_tab.dart';
import 'package:peaman/views/screens/notif_tab.dart';
import 'package:peaman/views/screens/profile_tab.dart';
import 'package:peaman/views/screens/watch_and_earn_tab.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final String uid;
  HomeScreen(this.uid);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: 1,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
        await AppUserProvider(uid: widget.uid)
            .setUserActiveStatus(onlineStatus: OnlineStatus.away);
        break;
      case AppLifecycleState.resumed:
        await AppUserProvider(uid: widget.uid)
            .setUserActiveStatus(onlineStatus: OnlineStatus.active);
        break;
      case AppLifecycleState.inactive:
        await AppUserProvider(uid: widget.uid)
            .setUserActiveStatus(onlineStatus: OnlineStatus.away);
        break;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    return _appUser == null
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
        : ViewmodelProvider(
            vm: HomeVm(
              context: context,
            ),
            onInit: (vm) async {
              FirebaseMessagingProvider(context: context, uid: _appUser.uid)
                  .saveDevice();
              AppUserProvider(uid: _appUser.uid)
                  .setUserActiveStatus(onlineStatus: OnlineStatus.active);
              _tabController.addListener(() {
                setState(() {});
              });

              final _lastTaskDoneAt = DateTime.fromMillisecondsSinceEpoch(
                  _appUser.lastTaskDoneAt ??
                      DateTime.now().millisecondsSinceEpoch);
              final _nextDay = DateTime(
                _lastTaskDoneAt.add(Duration(days: 1)).year,
                _lastTaskDoneAt.add(Duration(days: 1)).month,
                _lastTaskDoneAt.add(Duration(days: 1)).day,
              );
              final _currentDay = DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day);
              if (_currentDay.isAtSameMomentAs(_nextDay) ||
                  _currentDay.isAfter(_nextDay)) {
                await AppUserProvider(uid: _appUser.uid).updateUserDetail(
                  data: {
                    'completed_tasks': 0,
                  },
                );
              }
            },
            builder: (context, vm, appVm, appUser) {
              return Scaffold(
                backgroundColor: Color(0xffF3F5F8),
                body: Container(
                  child: Column(
                    children: <Widget>[
                      _tabViewBuilder(appUser),
                      _tabsBuilder(appUser),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget _tabViewBuilder(final AppUser appUser) {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: <Widget>[
          WatchAndEarn(),
          ExploreTab(_tabController),
          NotificationTab(),
          ProfileTab(),
        ],
      ),
    );
  }

  Widget _tabsBuilder(final AppUser appUser) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, -2.0),
            blurRadius: 5.0,
          ),
        ],
        color: Color(0xffF3F5F8),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.transparent,
        tabs: _getTab(appUser),
        onTap: (index) {
          if (index == 2) {
            AppUserProvider(uid: appUser.uid).updateUserDetail(data: {
              'new_notif': false,
            });
          }
        },
      ),
    );
  }

  List<Widget> _getTab(final AppUser appUser) {
    final _chats = Provider.of<List<Chat>>(context) ?? [];

    int _chatCount = 0;

    for (var chat in _chats) {
      if (!(chat.firstUserRef == AppUser().getUserRef(appUser.uid) &&
          chat.secondUserRef == AppUser().getUserRef(appUser.uid))) {
        if (chat.firstUserRef == AppUser().getUserRef(appUser.uid)) {
          if (chat.firstUserUnreadMessagesCount > 0) {
            _chatCount++;
          }
        } else {
          if (chat.secondUserUnreadMessagesCount > 0) {
            _chatCount++;
          }
        }
      }
    }

    List<Tab> _tabsList = [
      Tab(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SvgPicture.asset(
              'assets/images/svgs/watch_n_earn_tab.svg',
              color:
                  _tabController.index == 0 ? Colors.blue : Color(0xffD2DAF3),
              width: 27.0,
              height: 27.0,
            ),
            if (_chatCount > 0) _countBuilder(_chatCount)
          ],
        ),
      ),
      Tab(
        child: SvgPicture.asset(
          'assets/images/svgs/home_tab.svg',
          color: _tabController.index == 1 ? Colors.blue : null,
        ),
      ),
      Tab(
        child: Stack(
          overflow: Overflow.visible,
          children: [
            SvgPicture.asset(
              'assets/images/svgs/notification_tab.svg',
              color: _tabController.index == 2 ? Colors.blue : null,
            ),
            if (appUser.newNotif)
              Positioned(
                right: 0.0,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 4.0,
                ),
              ),
          ],
        ),
      ),
      Tab(
        child: SvgPicture.asset(
          'assets/images/svgs/profile_tab.svg',
          color: _tabController.index == 3 ? Colors.blue : null,
        ),
      ),
    ];
    return _tabsList;
  }

  Widget _countBuilder(final int count) {
    return Positioned(
      right: -5.0,
      top: -5.0,
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            count > 9 ? '9+' : '$count',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 8.0,
            ),
          ),
        ),
      ),
    );
  }
}
