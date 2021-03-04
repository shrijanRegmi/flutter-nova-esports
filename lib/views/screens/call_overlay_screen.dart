import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/call_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/call_provider.dart';
import 'package:peaman/viewmodels/call_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/screens/video_call_screen.dart';
import 'package:peaman/views/widgets/common_widgets/avatar_builder.dart';
import 'package:provider/provider.dart';

class CallOverlayScreen extends StatefulWidget {
  final AppUser friend;
  final bool isReceiving;
  final Call call;
  CallOverlayScreen(
    this.friend, {
    this.isReceiving = false,
    this.call,
  });

  @override
  _CallOverlayScreenState createState() => _CallOverlayScreenState();
}

class _CallOverlayScreenState extends State<CallOverlayScreen> {
  String _callState = 'Calling...';
  int _waitingTime = 15000; // 15 secs

  Timer _waitingTimer;

  @override
  void initState() {
    super.initState();
    if (widget.isReceiving)
      setState(() => _callState = 'Incoming Call');
    else
      _waitingTimer = Timer(Duration(milliseconds: _waitingTime), () {
        setState(() => _callState = 'Not Reachable');
        Future.delayed(
          Duration(milliseconds: 2000),
          () => Navigator.pop(context),
        );
      });
  }

  @override
  void dispose() {
    _waitingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);

    return ViewmodelProvider<CallVm>(
      vm: CallVm(context),
      onInit: (vm) {
        if (!widget.isReceiving) {
          vm.callFriend(_appUser, widget.friend);
        }
      },
      onDispose: (vm) {
        if (!widget.isReceiving) {
          vm.onDisCallOverlay(_appUser, widget.friend);
        }
      },
      builder: (context, vm, appVm, appUser) {
        return StreamBuilder<Call>(
            stream: CallProvider(
              appUser: widget.friend,
              call: widget.call ?? vm.thisCall,
            ).mainCall,
            builder: (context, snap) {
              if (snap.hasData) {
                final _call = snap.data;
                if (_call.hasExpired) {
                  Navigator.pop(context);
                } else if (_call.isPicked) {
                  _callState = 'Call Ended';
                  _waitingTimer.cancel();
                  return VideoCallScreen(
                    friend: widget.friend,
                    channelId:
                        widget.call != null ? widget.call.id : vm.thisCall.id,
                    role: ClientRole.Broadcaster,
                    isReceiving: widget.isReceiving,
                  );
                }
              }
              return Scaffold(
                body: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(widget.friend.photoUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(0.8),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40.0,
                        ),
                        _appbarBuilder(vm, appUser),
                        Expanded(
                          child: _bodyBuilder(),
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        if (_callState != 'Call Ended')
                          _buttonBuilder(vm, appUser),
                        SizedBox(
                          height: 50.0,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }

  Widget _appbarBuilder(final CallVm vm, final AppUser appUser) {
    return Row(
      children: [
        SizedBox(
          width: 10.0,
        ),
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () =>
              vm.cancelCall(appUser, widget.friend, widget.isReceiving, false),
        ),
      ],
    );
  }

  Widget _bodyBuilder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AvatarBuilder(
          imgUrl: widget.friend.photoUrl,
          radius: 50.0,
        ),
        Text(
          '${widget.friend.name}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40.0,
            color: Colors.white,
          ),
        ),
        Text(
          '$_callState',
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buttonBuilder(final CallVm vm, final AppUser appUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 70.0,
            height: 70.0,
            child: FloatingActionButton(
              onPressed: () => vm.cancelCall(
                  appUser, widget.friend, widget.isReceiving, false),
              heroTag: 'end',
              backgroundColor: Colors.red,
              child: Icon(Icons.call_end),
            ),
          ),
          if (widget.isReceiving)
            Container(
              width: 70.0,
              height: 70.0,
              child: FloatingActionButton(
                onPressed: () async {
                  await vm.pickCall(appUser, widget.friend);
                  setState(() {
                    _callState = 'Call Ended';
                  });
                },
                heroTag: 'call',
                backgroundColor: Colors.green,
                child: Icon(Icons.call),
              ),
            ),
        ],
      ),
    );
  }
}
