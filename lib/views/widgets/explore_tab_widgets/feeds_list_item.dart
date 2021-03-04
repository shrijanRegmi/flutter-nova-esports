import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peaman/enums/online_status.dart';
import 'package:peaman/models/app_models/feed_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/feed_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/screens/friend_profile_screen.dart';
import 'package:peaman/views/widgets/common_widgets/avatar_builder.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/feed_comments_list.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/feed_img_carousel.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/people_who_reacted.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedsListItem extends StatelessWidget {
  final Feed feed;
  FeedsListItem(this.feed);

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    
    return ViewmodelProvider<FeedVm>(
      vm: FeedVm(context: context),
      onInit: (vm) => vm.onInit(_appUser, feed, null),
      builder: (context, vm, appVm, appUser) {
        return Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            right: 10.0,
            left: 10.0,
            bottom: 40.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerBuilder(context, appUser),
              SizedBox(
                height: 10.0,
              ),
              FeedImageCarousel(feed.photos, vm.reactPost, appUser),
              SizedBox(
                height: 15.0,
              ),
              _actionButtonBuilder(context, appUser, vm),
              SizedBox(
                height: 15.0,
              ),
              PeopleWhoReacted(
                vm.thisFeed,
                appUser,
              ),
              if (vm.thisFeed.caption != '')
                SizedBox(
                  height: 10.0,
                ),
              if (vm.thisFeed.caption != '') _descriptionBuilder(vm),
            ],
          ),
        );
      },
    );
  }

  Widget _headerBuilder(BuildContext context, AppUser appUser) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FriendProfileScreen(feed.owner),
              ),
            );
          },
          child: Container(
            color: Colors.transparent,
            child: Row(
              children: [
                AvatarBuilder(
                  imgUrl: feed.owner.photoUrl,
                  isOnline: feed.owner.onlineStatus == OnlineStatus.active,
                  radius: 20.0,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feed.owner.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Color(0xff3D4A5A),
                      ),
                    ),
                    Text(
                      timeago.format(
                          DateTime.fromMillisecondsSinceEpoch(feed.updatedAt)),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionButtonBuilder(
      final BuildContext context, final AppUser appUser, final FeedVm vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => vm.unReactPost(appUser),
                child: Container(
                  color: Colors.transparent,
                  child: SvgPicture.asset(
                    vm.thisFeed.isReacted
                        ? 'assets/images/svgs/heart_filled.svg'
                        : 'assets/images/svgs/heart_blank.svg',
                    width: 27.0,
                    height: 27.0,
                    color:
                        vm.thisFeed.isReacted ? Colors.pink : Color(0xff3D4A5A),
                  ),
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FeedCommentScreen(feed),
                    ),
                  );
                },
                child: Container(
                  color: Colors.transparent,
                  child: SvgPicture.asset(
                    'assets/images/svgs/comment.svg',
                    width: 27.0,
                    height: 27.0,
                    color: Color(0xff3D4A5A),
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => vm.savePost(appUser),
            child: Container(
              color: Colors.transparent,
              child: SvgPicture.asset(
                vm.thisFeed.isSaved
                    ? 'assets/images/svgs/bookmark_filled.svg'
                    : 'assets/images/svgs/bookmark_blank.svg',
                width: 24.0,
                height: 24.0,
                color: Color(0xff3D4A5A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _descriptionBuilder(final FeedVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              // fontWeight: FontWeight.bold,
              fontFamily: 'Nunito',
              fontSize: 12.0,
              color: Colors.grey,
            ),
            children: [
              TextSpan(
                text: '${feed.owner.name} ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3D4A5A),
                ),
              ),
              TextSpan(
                text: vm.showFullDesc
                    ? feed.caption
                    : feed.caption.length > 150
                        ? '${feed.caption.substring(0, 150)}...'
                        : feed.caption,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        if (feed.caption.length > 150)
          GestureDetector(
            onTap: () => vm.updateFullDesc(!vm.showFullDesc),
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    vm.showFullDesc ? 'Read Less' : 'Read More',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 3.0,
                  ),
                  Icon(
                    vm.showFullDesc
                        ? Icons.arrow_upward_sharp
                        : Icons.arrow_downward_sharp,
                    color: Colors.blue,
                    size: 15.0,
                  )
                ],
              ),
            ),
          ),
      ],
    );
  }
}
