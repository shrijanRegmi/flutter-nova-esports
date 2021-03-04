import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/enums/online_status.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/auth_services/auth_provider.dart';
import 'package:peaman/services/database_services/user_provider.dart';
import 'package:peaman/viewmodels/app_vm.dart';
import 'package:peaman/viewmodels/friend_profile_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/screens/view_saved_screen.dart';
import 'package:peaman/views/widgets/common_widgets/scroll_appbar.dart';
import 'package:peaman/views/widgets/friends_profile_widgets/featured_posts_list.dart';
import 'package:peaman/views/widgets/friends_profile_widgets/friend_btns.dart';
import 'package:peaman/views/widgets/friends_profile_widgets/friends_status.dart';
import 'package:peaman/views/widgets/friends_profile_widgets/posts_list.dart';
import 'package:provider/provider.dart';

class FriendProfileScreen extends StatelessWidget {
  final AppUser user;
  final bool fromSearch;
  FriendProfileScreen(this.user, {this.fromSearch = false});

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    final _appVm = Provider.of<AppVm>(context);
    return ViewmodelProvider<FriendProfileVm>(
      vm: FriendProfileVm(),
      onInit: (vm) => vm.onInit(_appUser, user, _appVm),
      builder: (context, vm, appVm, appUser) {
        bool _isAppUser = user.uid == appUser.uid;
        final AppUser _user = _isAppUser ? appUser : vm.thisUser;
        return Scaffold(
          backgroundColor: Color(0xffF3F5F8),
          body: SafeArea(
            child: vm.isLoading
                ? Center(
                    child: Lottie.asset(
                      'assets/lottie/loader.json',
                      width: MediaQuery.of(context).size.width - 100.0,
                      height: MediaQuery.of(context).size.width - 100.0,
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        if (_isAppUser)
                          SizedBox(
                            height: 20.0,
                          ),
                        if (!_isAppUser) ScrollAppbar(),
                        if (_isAppUser)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _savedBuilder(context),
                              _logoutBuilder(appVm, appUser),
                            ],
                          ),
                        _userDetailBuilder(context),
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!_isAppUser)
                                FriendBtns(
                                  vm: vm,
                                  appUser: appUser,
                                  user: _user,
                                  fromSearch: fromSearch,
                                ),
                              SizedBox(
                                height: !_isAppUser ? 40.0 : 30.0,
                              ),
                              FriendStatus(_user),
                              SizedBox(
                                height: 50.0,
                              ),
                              vm.isLoadingFeeds
                                  ? Center(
                                      child: Lottie.asset(
                                        'assets/lottie/loader.json',
                                        width:
                                            MediaQuery.of(context).size.width -
                                                100.0,
                                        height:
                                            MediaQuery.of(context).size.width -
                                                100.0,
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        if (vm.feeds != null &&
                                            vm.feeds.isEmpty)
                                          _emptyBuilder(_isAppUser),
                                        if (vm.feeds != null &&
                                            vm.feeds.isNotEmpty)
                                          PostsList(vm.feeds),
                                        SizedBox(
                                          height: 50.0,
                                        ),
                                        if (vm.featuredFeeds != null &&
                                            vm.featuredFeeds.isNotEmpty)
                                          FeaturedPostList(vm.featuredFeeds),
                                      ],
                                    ),
                              SizedBox(
                                height: 100.0,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _logoutBuilder(final AppVm vm, final AppUser appUser) {
    return GestureDetector(
      onTap: () async {
        vm.updateFeedsList(null);
        vm.updateMomentsList(null);
        await AppUserProvider(uid: appUser.uid)
            .setUserActiveStatus(onlineStatus: OnlineStatus.away);
        AuthProvider().logOut();
      },
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _titleBuilder('Log out'),
              SizedBox(
                width: 20.0,
              ),
              _iconBuilder(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconBuilder() {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xff3D4A5A).withOpacity(0.1),
      ),
      child: Center(
        child: RotatedBox(
          quarterTurns: 90,
          child: SvgPicture.asset('assets/images/svgs/logout.svg'),
        ),
      ),
    );
  }

  Widget _savedBuilder(final BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ViewSavedScreen(),
          ),
        );
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            SizedBox(
              width: 20.0,
            ),
            Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff3D4A5A).withOpacity(0.1),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/svgs/bookmark_filled.svg',
                  color: Color(0xff3D4A5A),
                  width: 18.0,
                  height: 18.0,
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            _titleBuilder('Saved'),
          ],
        ),
      ),
    );
  }

  Widget _titleBuilder(final String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 16.0, color: Color(0xff3D4A5A)),
    );
  }

  Widget _emptyBuilder(final bool isAppUser) {
    return Container(
      height: 100.0,
      child: Center(
        child: Text(
          isAppUser
              ? "You haven't posted in a while"
              : "${user.name} hasn't posted in a while",
          style: TextStyle(
            // fontWeight: FontWeight.bold,
            fontSize: 14.0,
            color: Color(0xff3D4A5A),
          ),
        ),
      ),
    );
  }

  Widget _userDetailBuilder(BuildContext context) {
    final _width = MediaQuery.of(context).size.width * 0.50;
    return Column(
      children: <Widget>[
        Container(
          width: _width,
          height: _width,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 10.0,
            ),
            boxShadow: [
              BoxShadow(
                  offset: Offset(2.0, 10.0),
                  blurRadius: 20.0,
                  color: Colors.black12)
            ],
            image: DecorationImage(
              image: CachedNetworkImageProvider(user.photoUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          '${user.name}',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
              color: Color(0xff3D4A5A)),
        ),
        Text(
          '${user.profileStatus}',
          style: TextStyle(
            fontSize: 14.0,
            color: Color(0xff3D4A5A),
          ),
        ),
      ],
    );
  }
}
