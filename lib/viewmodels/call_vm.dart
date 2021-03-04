import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:peaman/helpers/chat_helper.dart';
import 'package:peaman/models/app_models/call_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/call_provider.dart';
import 'package:peaman/utils/agora_settings.dart';
import 'package:peaman/views/screens/video_call_screen.dart';

class CallVm extends ChangeNotifier {
  final BuildContext context;
  CallVm(this.context);

  bool _isMuted = false;
  bool _isCameraOff = false;
  Timer _durationTimer;
  int _counter = 0;
  bool _isBtnsHidden = false;
  Call _thisCall;
  bool _isChannelLeft = false;

  bool get isCameraOff => _isCameraOff;
  bool get isMuted => _isMuted;
  Timer get durationTimer => _durationTimer;
  int get counter => _counter;
  bool get isBtnsHidden => _isBtnsHidden;
  Call get thisCall => _thisCall;
  bool get isChannelLeft => _isChannelLeft;

  // init function
  onInit(final AppUser appUser, final AppUser friend, final String channelName,
      final ClientRole role) {
    _initializeAgora(role, channelName, appUser.uid.hashCode);
    _durationTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      if (_durationTimer.isActive) {
        _updateCounter(timer.tick);
      }
    });
  }

  // dispose function video call screen
  onDisVideoCall(final AppUser appUser, final AppUser friend) {
    _deleteCall(appUser, friend);
    _durationTimer?.cancel();
    _destroyAgora();
  }

  // dispose function for call overlay screen
  onDisCallOverlay(final AppUser appUser, final AppUser friend) {
    _deleteCall(appUser, friend);
  }

  // call friend
  callFriend(final AppUser appUser, final AppUser friend) async {
    final _call = Call(
      id: ChatHelper().getChatId(myId: appUser.uid, friendId: friend.uid),
      caller: appUser,
      receiver: friend,
      hasExpired: false,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    _thisCall = _call;
    notifyListeners();

    await CallProvider(appUser: appUser, friend: friend, call: _call)
        .callFriend();
  }

  // cancel call
  cancelCall(final AppUser appUser, final AppUser friend,
      final bool isReceiving, final bool fromAgora) async {
    if (!isReceiving) {
      Navigator.pop(context);
    }

    if (fromAgora && isReceiving) {
      Navigator.pop(context);
    }

    if (isReceiving) {
      final _call = Call(
        id: ChatHelper().getChatId(myId: appUser.uid, friendId: friend.uid),
        caller: friend,
        receiver: appUser,
        hasExpired: false,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
      await CallProvider(appUser: friend, friend: appUser, call: _call)
          .endCall();
    } else {
      final _call = Call(
        id: ChatHelper().getChatId(myId: appUser.uid, friendId: friend.uid),
        caller: appUser,
        receiver: friend,
        hasExpired: false,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
      await CallProvider(appUser: appUser, friend: friend, call: _call)
          .endCall();
    }
  }

  // pick call
  pickCall(final AppUser appUser, final AppUser friend) async {
    final _call = Call(
      id: ChatHelper().getChatId(myId: appUser.uid, friendId: friend.uid),
      caller: friend,
      receiver: appUser,
      hasExpired: false,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoCallScreen(
          friend: friend,
          channelId: _call.id,
          role: ClientRole.Broadcaster,
          isReceiving: true,
        ),
      ),
    );
    await CallProvider(appUser: friend, friend: appUser, call: _call)
        .pickCall();
  }

  // on press mic
  onPressedMic() {
    AgoraRtcEngine.muteLocalAudioStream(!_isMuted);
    _updateIsMuted(!_isMuted);
  }

  // on press camera
  onPressedCamera() {
    AgoraRtcEngine.muteLocalVideoStream(!_isCameraOff);
    _updateIsCameraOff(!_isCameraOff);
  }

  // on press camera
  onPressedFlip() {
    AgoraRtcEngine.switchCamera();
  }

  // initialize agora
  Future<void> _initializeAgora(
      final ClientRole role, final String channelName, final int uid) async {
    await AgoraRtcEngine.create(APP_ID);
    await AgoraRtcEngine.enableVideo();
    await AgoraRtcEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await AgoraRtcEngine.setClientRole(role);

    _agoraEventsHandler();

    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = Size(1920, 1080);
    await AgoraRtcEngine.setVideoEncoderConfiguration(configuration);
    await AgoraRtcEngine.joinChannel(null, channelName, null, uid);
  }

  // agora events handler
  _agoraEventsHandler() async {
    AgoraRtcEngine.onError = (dynamic code) {
      print('INFO: The error is ::: $code');
    };

    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      print('INFO: $uid joined the channel $channel');
    };

    AgoraRtcEngine.onLeaveChannel = () {
      print('INFO: Channel was left');
      _updateIsChannelLeft(true);
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      print('INFO: User $uid joined the channel');
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      print('INFO: User $uid is offline');
      _updateIsChannelLeft(true);
    };
  }

  // destroy agora
  _destroyAgora() {
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
  }

  // delete call
  _deleteCall(final AppUser appUser, final AppUser friend) async {
    final _call = Call(
      id: ChatHelper().getChatId(myId: appUser.uid, friendId: friend.uid),
      caller: appUser,
      receiver: friend,
      hasExpired: false,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await CallProvider(appUser: appUser, friend: friend, call: _call)
        .deleteCall();
  }

  // update value of is muted
  _updateIsMuted(final bool newVal) {
    _isMuted = newVal;
    notifyListeners();
  }

  // update value of is camera off
  _updateIsCameraOff(final bool newVal) {
    _isCameraOff = newVal;
    notifyListeners();
  }

  // update value of counter
  _updateCounter(final int newVal) {
    _counter = newVal;
    notifyListeners();
  }

  // update value of btns hidden
  updateIsBtnsHidden(final bool newVal) {
    _isBtnsHidden = newVal;
    notifyListeners();
  }

  // update value of is channel left hidden
  _updateIsChannelLeft(final bool newVal) {
    _isChannelLeft = newVal;
    notifyListeners();
  }
}
