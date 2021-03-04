import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/follow_request_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/friend_provider.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/common_widgets/avatar_builder.dart';
import 'package:timeago/timeago.dart' as timeago;

class FollowRequestListItem extends StatelessWidget {
  final FollowRequest followRequest;
  FollowRequestListItem(this.followRequest);

  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider<FollowRequestItemVm>(
      vm: FollowRequestItemVm(),
      onInit: (vm) {
        if (followRequest.isAccepted) {
          vm.updateBtnText('Follow back');
        }
      },
      builder: (context, vm, appVm, appUser) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: _followNotifBuilder(vm, appUser),
        );
      },
    );
  }

  Widget _followNotifBuilder(
      final FollowRequestItemVm vm, final AppUser appUser) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: <Widget>[
              // user image
              AvatarBuilder(
                imgUrl: followRequest.sender.photoUrl,
                radius: 22.0,
              ),
              SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontFamily: 'Nunito',
                        ),
                        children: [
                          TextSpan(
                            text: '${followRequest.sender.name}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' wants to follow you.',
                          ),
                        ],
                      ),
                    ),
                    Text(
                      timeago.format(DateTime.fromMillisecondsSinceEpoch(
                          followRequest.updatedAt)),
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () => vm.onClickPositiveBtn(
                  appUser, followRequest.sender.uid, followRequest),
              height: 30.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(4.0),
                ),
              ),
              child: Text(
                '${vm.btnText}',
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            if (vm.btnText == 'Follow' && !followRequest.isAccepted)
              Container(
                width: 30.0,
                height: 30.0,
                child: FloatingActionButton(
                  heroTag: followRequest.id,
                  backgroundColor: Colors.red,
                  onPressed: () => vm.ignoreRequest(
                      appUser, followRequest, followRequest.sender.uid),
                  child: Icon(
                    Icons.close,
                    size: 15.0,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class FollowRequestItemVm extends ChangeNotifier {
  String _btnText = 'Accept';

  String get btnText => _btnText;

  // on click positive btn
  onClickPositiveBtn(final AppUser appUser, final String userId,
      final FollowRequest followRequest) {
    if (_btnText == 'Accept') {
      _acceptFollow(appUser, userId, followRequest);
    } else if (_btnText == 'Follow back') {
      _followBack(appUser, userId, followRequest);
    }
  }

  // accept follow
  _acceptFollow(final AppUser appUser, final String userId,
      final FollowRequest followRequest) {
    updateBtnText('Follow back');

    final _user = AppUser(
      uid: userId,
      appUserRef: AppUser().getUserRef(userId),
    );
    FriendProvider(appUser: appUser, user: _user, followRequest: followRequest)
        .acceptFollow();
  }

  // follow back user
  _followBack(final AppUser appUser, final String userId,
      final FollowRequest followRequest) {
    updateBtnText('Following');

    final _user = AppUser(
      uid: userId,
      appUserRef: AppUser().getUserRef(userId),
    );
    FriendProvider(appUser: appUser, user: _user, followRequest: followRequest)
        .followBack();
  }

  // ignore request
  ignoreRequest(final AppUser appUser, final FollowRequest followRequest,
      final String userId) {
    final _user = AppUser(
      uid: userId,
      appUserRef: AppUser().getUserRef(userId),
    );
    FriendProvider(appUser: appUser, followRequest: followRequest, user: _user)
        .cancleFollow();
  }

  // update value of btn text
  updateBtnText(final String newBtnText) {
    _btnText = newBtnText;

    notifyListeners();
  }
}
