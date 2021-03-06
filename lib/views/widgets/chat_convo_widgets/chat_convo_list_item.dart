import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peaman/enums/message_types.dart';
import 'package:peaman/models/app_models/message_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/temp_img_vm.dart';
import 'package:peaman/views/screens/photo_viewer_screen.dart';
import 'package:peaman/views/widgets/common_widgets/avatar_builder.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatConvoListItem extends StatelessWidget {
  final String chatId;
  final Message message;
  final AppUser friend;
  final Alignment alignment;
  final bool isLast;
  ChatConvoListItem(
      {this.chatId,
      this.friend,
      this.alignment,
      this.message,
      this.isLast = false});

  @override
  Widget build(BuildContext context) {
    Widget _messageWidget;
    switch (message.type) {
      case MessageType.Text:
        _messageWidget = _textMessageBuilder();
        break;
      case MessageType.Image:
        _messageWidget = _imgMessageBuilder(context);
        break;
      default:
        _messageWidget = _textMessageBuilder();
        break;
    }
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          _messageWidget,
          SizedBox(
            height: 15.0,
          ),
          _userBuilder(context),
          if (isLast) ..._tempImageListBuilder(context),
        ],
      ),
    );
  }

  Widget _textMessageBuilder() {
    return Row(
      mainAxisAlignment: alignment == Alignment.centerRight
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Align(
            alignment: alignment,
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xfff5f5f5),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10.0,
                      color: Colors.black26,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                    bottomRight: Radius.circular(
                        alignment == Alignment.centerRight ? 0.0 : 15.0),
                    bottomLeft: Radius.circular(
                        alignment == Alignment.centerLeft ? 0.0 : 15.0),
                  )),
              padding: const EdgeInsets.all(20.0),
              child: Text(
                message.text,
                style: TextStyle(
                  fontSize: 12.0,
                  color: Color(0xff3D4A5A),
                  height: 1.8,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _imgMessageBuilder(BuildContext context) {
    final _size = MediaQuery.of(context).size.width / 3;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PhotoViewerScreen(message.text),
        ),
      ),
      child: Align(
        alignment: alignment,
        child: LimitedBox(
          maxWidth: _size - 100,
          maxHeight: _size + 100,
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: 5.0,
                right: 5.0,
                child: CircularProgressIndicator(),
              ),
              CachedNetworkImage(
                imageUrl: message.text,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userBuilder(final BuildContext context, {final bool isTemp = false}) {
    return alignment == Alignment.centerLeft
        ? Row(
            children: [
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) => FriendProfileScreen(friend),
                  //   ),
                  // );
                },
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AvatarBuilder(
                        imgUrl: friend.photoUrl,
                        isOnline: false,
                        radius: 17.0,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            friend.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Color(0xff3D4A5A),
                            ),
                          ),
                          Text(
                            isTemp
                                ? 'Just now'
                                : _getTime(message.milliseconds),
                            style: TextStyle(
                              fontSize: 10.0,
                              color: Colors.black26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'Me',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Color(0xff3D4A5A),
                    ),
                  ),
                  Text(
                    isTemp ? 'Just now' : _getTime(message.milliseconds),
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.black26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 10.0,
              ),
              AvatarBuilder(
                imgUrl: friend.photoUrl,
                isOnline: false,
                radius: 17.0,
              ),
            ],
          );
  }

  String _getTime(final int milliseconds) {
    return timeago
        .format(
          DateTime.fromMillisecondsSinceEpoch(message.milliseconds),
        )
        .replaceAll('ago', '')
        .replaceAll('minutes', 'm')
        .replaceAll('hours', 'h')
        .replaceAll('days', 'd')
        .replaceAll('months', 'mon')
        .replaceAll('a day', '1 d')
        .replaceAll('a minute', '1 m')
        .replaceAll('about an hour', '1 h')
        .replaceAll('a moment', 'Just now');
  }

  List<Widget> _tempImageListBuilder(BuildContext context) {
    final _tempImagesList = Provider.of<TempImgVm>(context).tempImages;
    List<Widget> _list = [];
    for (var item in _tempImagesList) {
      if (item.chatId == chatId) {
        _list.add(_tempImageItemBuilder(context, item.imgFile));
      }
    }
    return _list;
  }

  Widget _tempImageItemBuilder(BuildContext context, File imgFile) {
    final _size = MediaQuery.of(context).size.width / 2;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            LimitedBox(
              maxWidth: _size,
              maxHeight: _size,
              child: Stack(
                children: <Widget>[
                  Image.file(
                    imgFile,
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Me',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Color(0xff3D4A5A),
                      ),
                    ),
                    Text(
                      'Just now',
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.black26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10.0,
                ),
                AvatarBuilder(
                  imgUrl: friend.photoUrl,
                  isOnline: false,
                  radius: 17.0,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
