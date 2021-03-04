import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peaman/models/app_models/follow_request_model.dart';
import 'package:peaman/models/app_models/user_model.dart';

class FriendProvider {
  final AppUser appUser;
  final AppUser user;
  final FollowRequest followRequest;
  FriendProvider({this.appUser, this.user, this.followRequest});

  // follow friend
  Future follow() async {
    try {
      final _friendRef = user.appUserRef;
      final _requestRef = _friendRef.collection('requests').doc(appUser.uid);

      final _data = {
        'id': appUser.uid,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      };

      await _requestRef.set(_data);
      print('Success: Following ${user.uid}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Following ${user.uid}');
    }
  }

  // accept follow request
  Future acceptFollow() async {
    try {
      final _userRef = appUser.appUserRef;
      final _requestRef = _userRef.collection('requests').doc(user.uid);
      final _followRequestRef =
          _userRef.collection('follow_requests').doc(followRequest.id);

      await _followRequestRef.update({
        'is_accepted': true,
      });
      await _requestRef.delete();
      print('Success: Deleting request doc with id ${user.uid}');

      _addFollower();

      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Deleting request doc with id ${user.uid}');
      return null;
    }
  }

  // follow back
  Future followBack() async {
    try {
      final _friendRef = user.appUserRef;
      final _userRef = appUser.appUserRef;
      final _followReqRef =
          appUser.appUserRef.collection('follow_requests').doc(followRequest.id);

      final _friendFollowersRef =
          _friendRef.collection('followers').doc(appUser.uid);
      final _userFollowingRef = _userRef.collection('following').doc(user.uid);

      final _milli = DateTime.now().millisecondsSinceEpoch;

      await _friendFollowersRef.set({
        'id': appUser.uid,
        'updated_at': _milli,
      });
      await _userFollowingRef.set({
        'id': appUser.uid,
        'updated_at': _milli,
      });

      await _friendRef.update({
        'followers': FieldValue.increment(1),
      });
      await _userRef.update({
        'following': FieldValue.increment(1),
      });

      await _followReqRef.delete();

      print('Success: Following back ${user.uid}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Following back ${user.uid}');
      return null;
    }
  }

  // cancle follow
  Future cancleFollow() async {
    try {
      final _userRef = appUser.appUserRef;
      final _requestRef = _userRef.collection('requests').doc(user.uid);
      final _followReqRef =
          _userRef.collection('follow_requests').doc(followRequest.id);

      await _requestRef.delete();
      await _followReqRef.delete();
      print('Success: Deleting request doc with id ${user.uid}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Deleting request doc with id ${user.uid}');
      return null;
    }
  }

  // add follower
  Future _addFollower() async {
    try {
      final _userRef = appUser.appUserRef;
      final _friendRef = user.appUserRef;

      final _userFollowersRef = _userRef.collection('followers').doc(user.uid);
      final _friendFollowingRef =
          _friendRef.collection('following').doc(appUser.uid);

      final _milli = DateTime.now().millisecondsSinceEpoch;

      await _userFollowersRef.set({
        'id': user.uid,
        'updated_at': _milli,
      });
      await _friendFollowingRef.set({
        'id': appUser.uid,
        'updated_at': _milli,
      });

      await _userRef.update({
        'followers': FieldValue.increment(1),
      });
      await _friendRef.update({
        'following': FieldValue.increment(1),
      });

      print('Success: Adding follower ${user.uid}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Adding follower ${user.uid}');
      return null;
    }
  }
}
