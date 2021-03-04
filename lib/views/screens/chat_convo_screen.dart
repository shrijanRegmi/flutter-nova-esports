import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:peaman/enums/online_status.dart';
import 'package:peaman/helpers/chat_helper.dart';
import 'package:peaman/models/app_models/chat_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/user_provider.dart';
import 'package:peaman/viewmodels/chat_convo_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/screens/call_overlay_screen.dart';
import 'package:peaman/views/widgets/chat_convo_widgets/chat_compose_area.dart';
import 'package:peaman/views/widgets/chat_convo_widgets/chat_convo_list.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:provider/provider.dart';

class ChatConvoScreen extends StatefulWidget {
  final AppUser friend;
  final bool fromSearch;
  final Chat chat;
  ChatConvoScreen({this.friend, this.fromSearch = false, this.chat});

  @override
  _ChatConvoScreenState createState() => _ChatConvoScreenState();
}

class _ChatConvoScreenState extends State<ChatConvoScreen> {
  final FocusNode _focusNode = FocusNode();

  bool _isPinned;

  final _scaffolKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    return ViewmodelProvider<ChatConvoVm>(
      vm: ChatConvoVm(
        context: context,
      ),
      onInit: (ChatConvoVm vm) {
        final bool _isAppUserFirstUser = ChatHelper().isAppUserFirstUser(
            myId: vm.appUser.uid, friendId: widget.friend.uid);
        if (_isAppUserFirstUser) {
          _isPinned = widget.chat?.firstUserPinnedSecondUser;
        } else {
          _isPinned = widget.chat?.secondUserPinnedFirstUser;
        }
      },
      onDispose: (vm) {
        vm.updateChatTyping(
          false,
          widget.chat.id,
          _appUser,
          widget.friend,
        );
      },
      builder: (context, vm, appVm, appUser) {
        final _appUser = vm.appUser;
        final bool _isAppUserFirstUser = ChatHelper().isAppUserFirstUser(
            myId: vm.appUser.uid, friendId: widget.friend.uid);

        final _thisChat = vm.chats.firstWhere(
            (element) => element.id == widget.chat?.id,
            orElse: () => null);

        bool _isSeen = false;
        bool _isTyping = false;
        bool _isCurrentUserTyping = false;

        if (_thisChat != null) {
          Map<String, dynamic> _data = {};
          int _unreadMessagesCount;

          if (_isAppUserFirstUser) {
            _unreadMessagesCount = _thisChat.firstUserUnreadMessagesCount;
            _isSeen = _thisChat.secondUserUnreadMessagesCount == 0;
            _isTyping = _thisChat.secondUserTyping;
            _isCurrentUserTyping = _thisChat.firstUserTyping;
            _data.addAll({
              'first_user_unread_messages_count': 0,
            });
          } else {
            _unreadMessagesCount = _thisChat.secondUserUnreadMessagesCount;
            _isSeen = _thisChat.firstUserUnreadMessagesCount == 0;
            _isTyping = _thisChat.firstUserTyping;
            _isCurrentUserTyping = _thisChat.secondUserTyping;
            _data.addAll({
              'second_user_unread_messages_count': 0,
            });
          }

          if (_unreadMessagesCount != 0) {
            vm.updateChatData(_data, _thisChat.id);
          }
        }

        if (vm.receivingCall != null) {
          return CallOverlayScreen(
            vm.receivingCall.caller,
            isReceiving: true,
            call: vm.receivingCall,
          );
        }

        return Scaffold(
          backgroundColor: Color(0xffF3F5F8),
          key: _scaffolKey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: SafeArea(
              child: CommonAppbar(
                leading: widget.fromSearch
                    ? IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        color: Color(0xff3D4A5A),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      )
                    : null,
                title: Row(
                  children: <Widget>[
                    Text(
                      widget.friend.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Color(0xff3D4A5A),
                      ),
                    ),
                    StreamBuilder<AppUser>(
                      stream: AppUserProvider(uid: widget.friend.uid).appUser,
                      builder: (context, snap) {
                        if (snap.hasData) {
                          final _friend = snap.data;
                          return Row(
                            children: [
                              if (_friend.onlineStatus == OnlineStatus.active)
                                SizedBox(
                                  width: 10.0,
                                ),
                              if (_friend.onlineStatus == OnlineStatus.active)
                                CircleAvatar(
                                  maxRadius: 4.0,
                                  backgroundColor: Colors.pink,
                                )
                            ],
                          );
                        }
                        // return Row(
                        //   children: [
                        //     if (widget.friend.onlineStatus ==
                        //         OnlineStatus.active)
                        //       SizedBox(
                        //         width: 10.0,
                        //       ),
                        //     if (widget.friend.onlineStatus ==
                        //         OnlineStatus.active)
                        //       CircleAvatar(
                        //         maxRadius: 4.0,
                        //         backgroundColor: Colors.pink,
                        //       )
                        //   ],
                        // );
                        return Container();
                      },
                    ),
                  ],
                ),
                actions: widget.fromSearch
                    ? null
                    : <Widget>[
                        IconButton(
                          icon: Icon(Icons.star),
                          color: _isPinned ?? false
                              ? Colors.blue
                              : Colors.black12,
                          iconSize: 30.0,
                          onPressed: () {
                            vm.pinChat(
                              chatId: widget.chat.id,
                              myId: _appUser.uid,
                              friendId: widget.friend.uid,
                              isPinned: !_isPinned,
                            );
                            setState(() {
                              _isPinned = !_isPinned;
                            });
                            Fluttertoast.showToast(
                              msg: _isPinned
                                  ? '"Pinned chat with ${widget.friend.name}"'
                                  : '"Unpinned chat with ${widget.friend.name}"',
                              backgroundColor: Colors.white,
                              fontSize: 10.0,
                              textColor: Colors.black,
                            );
                          },
                        )
                      ],
              ),
            ),
          ),
          bottomNavigationBar: vm.isTyping
              ? Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: ChatComposeArea(
                    chatId: widget.chat?.id,
                    sendMessage: vm.sendMessage,
                    appUser: vm.appUser,
                    friend: widget.friend,
                    updateIsTyping: vm.updateTypingValue,
                    isTypingActive: vm.isTyping,
                    focusNode: _focusNode,
                    scaffoldKey: _scaffolKey,
                    updateChatTyping: vm.updateChatTyping,
                    isCurrentUserTyping: _isCurrentUserTyping,
                  ),
                )
              : null,
          floatingActionButton: !vm.isTyping
              ? ChatComposeArea(
                  chatId: widget.chat?.id,
                  sendMessage: vm.sendMessage,
                  appUser: vm.appUser,
                  friend: widget.friend,
                  updateIsTyping: vm.updateTypingValue,
                  isTypingActive: vm.isTyping,
                  focusNode: _focusNode,
                  scaffoldKey: _scaffolKey,
                  updateChatTyping: vm.updateChatTyping,
                  isCurrentUserTyping: _isCurrentUserTyping,
                )
              : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: SafeArea(
            child: GestureDetector(
              onTap: () {
                _focusNode.unfocus();
                vm.updateTypingValue(false);
              },
              child: Container(
                color: Color(0xffF3F5F8),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ChatConvoList(
                          isTypingActive: vm.isTyping,
                          friend: widget.friend,
                          appUser: vm.appUser,
                          isSeen: _isSeen,
                          isTyping: _isTyping,
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
}
