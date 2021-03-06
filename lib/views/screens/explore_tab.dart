import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peaman/enums/match_type.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/app_vm.dart';
import 'package:peaman/viewmodels/explore_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/screens/search_screen.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/tournament_list.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/video_carousel.dart';
import 'package:provider/provider.dart';

class ExploreTab extends HookWidget {
  final TabController tabController;
  ExploreTab(this.tabController);

  @override
  Widget build(BuildContext context) {
    final _appVm = Provider.of<AppVm>(context);
    final _appUser = Provider.of<AppUser>(context);

    return ViewmodelProvider<ExploreVm>(
        vm: ExploreVm(context),
        onInit: (vm) => vm.onInit(_appVm, _appUser),
        builder: (context, vm, appVm, appUser) {
          return Scaffold(
            key: vm.scaffoldKey,
            backgroundColor: Color(0xffF3F5F8),
            body: RefreshIndicator(
              onRefresh: () async {},
              backgroundColor: Colors.blue,
              color: Colors.white,
              child: SingleChildScrollView(
                controller: vm.scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15.0,
                    ),
                    _topSectionBuilder(context),
                    SizedBox(
                      height: 5.0,
                    ),
                    Divider(),
                    SizedBox(
                      height: 10.0,
                    ),
                    VideoCarousel([
                      'orxj4f8dBRY',
                      'tWGUUlbBEN0',
                      'rQjDhp4BLPA',
                    ]),
                    SizedBox(
                      height: 10.0,
                    ),
                    Divider(
                      color: Color(0xff3D4A5A).withOpacity(0.2),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TournamentList([
                      Tournament(
                        imgUrl:
                            'https://staticg.sportskeeda.com/editor/2019/12/09b05-15764171580892-800.jpg',
                        title: 'MUNNA BHAI GAMING DAILY Solo War 3',
                        type: MatchType.solo,
                        maxPlayers: 50,
                        joinedPlayers: 20,
                        entryCost: '10',
                        isRegistered: false,
                      ),
                      Tournament(
                        imgUrl:
                            'https://play-lh.googleusercontent.com/KxIKOXKi9bJukZCQyzilpDqHL6f7WTcXgMQFo1IaJOhd6rrTdYONMvdewqnvivauTSGL',
                        title: 'OP GAMING HEADSHOT SQUAD War',
                        type: MatchType.squad,
                        maxPlayers: 48,
                        joinedPlayers: 40,
                        entryCost: '4',
                        isRegistered: true,
                      ),
                    ]),
                    SizedBox(
                      height: 100.0,
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (_) => CreatePostScreen(tabController),
                //   ),
                // );
              },
              child: Icon(Icons.create),
            ),
          );
        });
  }

  Widget _topSectionBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: SvgPicture.asset(
              'assets/images/svgs/home_tab.svg',
              color: Color(0xff3D4A5A),
            ),
          ),
          // messages text
          Text(
            'Explore Tab',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                color: Color(0xff3D4A5A)),
          ),
          // searchbar
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SearchScreen(),
                ),
              );
            },
            child: Container(
              color: Colors.transparent,
              child: SvgPicture.asset('assets/images/svgs/search_icon.svg'),
            ),
          ),
        ],
      ),
    );
  }
}
