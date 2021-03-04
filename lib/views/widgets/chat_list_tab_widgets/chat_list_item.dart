import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peaman/enums/message_types.dart';
import 'package:peaman/enums/online_status.dart';
import 'package:peaman/helpers/chat_helper.dart';
import 'package:peaman/models/app_models/chat_model.dart';
import 'package:peaman/models/app_models/message_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/message_provider.dart';
import 'package:peaman/services/database_services/user_provider.dart';
import 'package:peaman/views/screens/chat_convo_screen.dart';
import 'package:peaman/views/widgets/common_widgets/avatar_builder.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatListItem extends StatelessWidget {
  final AppUser appUser;
  final Chat chat;
  ChatListItem({this.chat, this.appUser});

  @override
  Widget build(BuildContext context) {
    final _ref = FirebaseFirestore.instance;
    final _appUserRef = _ref.collection('users').doc(appUser.uid);

    DocumentReference _requiredRef;
    if (_appUserRef?.path == chat.firstUserRef?.path) {
      _requiredRef = chat.secondUserRef;
    } else {
      _requiredRef = chat.firstUserRef;
    }

    return StreamBuilder<AppUser>(
      stream: AppUserProvider(userRef: _requiredRef).appUserFromRef,
      builder: (BuildContext context, AsyncSnapshot<AppUser> snapshot) {
        if (snapshot.hasData) {
          final _friend = snapshot.data;

          final _isAppUserFirstUser = ChatHelper()
              .isAppUserFirstUser(myId: appUser.uid, friendId: _friend.uid);
          int _unreadMessagesCount;

          if (_isAppUserFirstUser) {
            _unreadMessagesCount = chat.firstUserUnreadMessagesCount;
          } else {
            _unreadMessagesCount = chat.secondUserUnreadMessagesCount;
          }

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatConvoScreen(
                    chat: chat,
                    friend: _friend,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      // user image
                      AvatarBuilder(
                        imgUrl: _friend?.photoUrl,
                        radius: 25.0,
                        isOnline: _friend.onlineStatus == OnlineStatus.active,
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      _textBuilder(context, _friend),
                    ],
                  ),
                  _messageCountBuilder(_unreadMessagesCount),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return AutoSizeText(snapshot.error.toString());
        }
        return Container();
      },
    );
  }

  Widget _textBuilder(BuildContext context, final friend) {
    final _scrSize = MediaQuery.of(context).size.width;
    return StreamBuilder<Message>(
      stream: MessageProvider(messageRef: chat.lastMsgRef).messageFromRef,
      builder: (BuildContext context, AsyncSnapshot<Message> snapshot) {
        if (snapshot.hasData) {
          final _message = snapshot.data;
          return Container(
            width: _scrSize / 2 + 50.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // user name
                AutoSizeText(
                  "${friend?.name}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 16.0,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Color(0xff3D4A5A),
                  ),
                ),
                SizedBox(
                  height: 3.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    // user message
                    AutoSizeText(
                      _getMessageText(_message),
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 12.0,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 5.0, right: 5.0, bottom: 4.0),
                      child: CircleAvatar(
                        maxRadius: 2.0,
                        backgroundColor: Colors.black12,
                      ),
                    ),
                    // message date
                    AutoSizeText(
                      _getTime(_message.milliseconds),
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.black26,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return AutoSizeText(snapshot.error.toString());
        }
        return Container();
      },
    );
  }

  Widget _messageCountBuilder(int unreadMessagesCount) {
    return unreadMessagesCount != 0
        ? CircleAvatar(
            backgroundColor: Colors.blue[600],
            maxRadius: 10.0,
            child: Center(
              child: AutoSizeText(
                unreadMessagesCount.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 10.0,
                ),
              ),
            ),
          )
        : Container();
  }

  String _getTime(final int milliseconds) {
    return timeago
        .format(
          DateTime.fromMillisecondsSinceEpoch(milliseconds),
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

  String _getMessageText(Message _message) {
    switch (_message.type) {
      case MessageType.Text:
        return _message.text.length > 20
            ? _message.senderId == appUser.uid
                ? 'You: ${_message.text.substring(0, 20)}...'
                : '${_message.text.substring(0, 20)}...'
            : _message.senderId == appUser.uid
                ? 'You: ${_message.text}'
                : _message.text;
        break;
      case MessageType.Image:
        return _message.senderId == appUser.uid
            ? 'You: Sent an image'
            : 'Sent an image';
        break;
      default:
        return _message.text.length > 20
            ? '${_message.text.substring(0, 20)}...'
            : _message.text;
    }
  }
}
