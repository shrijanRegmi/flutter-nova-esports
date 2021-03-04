import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/call_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:provider/provider.dart';

class VideoCallScreen extends StatelessWidget {
  final AppUser friend;
  final ClientRole role;
  final String channelId;
  final bool isReceiving;
  VideoCallScreen({
    this.friend,
    this.role,
    this.channelId,
    this.isReceiving = false,
  });

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);

    return ViewmodelProvider<CallVm>(
      vm: CallVm(context),
      onInit: (vm) => vm.onInit(_appUser, friend, channelId, role),
      onDispose: (vm) => vm.onDisVideoCall(_appUser, friend),
      builder: (context, vm, appVm, appUser) {
        if (vm.isChannelLeft && isReceiving) {
          Navigator.pop(context);
        }
        return Scaffold(
          body: SafeArea(
            child: GestureDetector(
              onTap: () {
                vm.updateIsBtnsHidden(!vm.isBtnsHidden);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(friend.photoUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.8),
                  child: Stack(
                    children: [
                      AgoraRenderWidget(
                        friend.uid.hashCode,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: Colors.transparent,
                        child: !vm.isBtnsHidden
                            ? Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _friendInfoBuilder(vm),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      if (!vm.isCameraOff)
                                        _myImgBuilder(appUser),
                                      _actionBtnBuilder(vm, appUser),
                                    ],
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (!vm.isCameraOff) _myImgBuilder(appUser),
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _friendInfoBuilder(final CallVm vm) {
    return Container(
      padding: const EdgeInsets.only(
          top: 20.0, left: 20.0, bottom: 50.0, right: 20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black87, Colors.black54, Colors.transparent],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${friend.name}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26.0,
                  color: Colors.white,
                ),
              ),
              Text(
                'Duration: ${vm.counter} sec',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(
            width: 50.0,
            height: 50.0,
            child: FloatingActionButton(
              onPressed: vm.onPressedFlip,
              heroTag: 'flip',
              backgroundColor: Color(0xff40434b),
              child: Icon(Icons.flip_camera_android_sharp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionBtnBuilder(final CallVm vm, final AppUser appUser) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black87, Colors.black54, Colors.transparent],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 50.0,
              height: 50.0,
              child: FloatingActionButton(
                onPressed: vm.onPressedMic,
                heroTag: 'mute',
                backgroundColor: Color(0xff40434b),
                child: Icon(vm.isMuted ? Icons.mic_off : Icons.mic),
              ),
            ),
            Container(
              width: 70.0,
              height: 70.0,
              child: FloatingActionButton(
                onPressed: () =>
                    vm.cancelCall(appUser, friend, isReceiving, true),
                heroTag: 'call',
                backgroundColor: Colors.red,
                child: Icon(Icons.call_end),
              ),
            ),
            Container(
              width: 50.0,
              height: 50.0,
              child: FloatingActionButton(
                onPressed: vm.onPressedCamera,
                heroTag: 'video',
                backgroundColor: Color(0xff40434b),
                child: Icon(vm.isCameraOff
                    ? Icons.videocam_off_rounded
                    : Icons.videocam_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _myImgBuilder(final AppUser appUser) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Container(
        width: 150.0,
        height: 200.0,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(20.0),
        //   border: Border.all(
        //     color: Colors.white,
        //     width: 3.0,
        //   ),
        // ),
        child: AgoraRenderWidget(
          appUser.uid.hashCode,
          local: true,
          preview: true,
        ),
      ),
    );
  }
}
