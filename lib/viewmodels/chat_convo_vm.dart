import 'package:flutter/material.dart';
import 'package:peaman/helpers/chat_helper.dart';
import 'package:peaman/models/app_models/chat_model.dart';
import 'package:peaman/models/app_models/message_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/message_provider.dart';
import 'package:provider/provider.dart';

class ChatConvoVm extends ChangeNotifier {
  final BuildContext context;
  ChatConvoVm({@required this.context});

  AppUser get appUser => Provider.of<AppUser>(context);
  List<Chat> get chats => Provider.of<List<Chat>>(context) ?? [];

  bool _isTyping = false;

  bool get isTyping => _isTyping;

  // send message to friend
  Future sendMessage({
    @required final String myId,
    @required final String friendId,
    @required final Message message,
  }) {
    final _chatId = ChatHelper().getChatId(myId: myId, friendId: friendId);
    return MessageProvider(chatId: _chatId).sendMessage(message: message);
  }

  // update is typing value
  void updateTypingValue(final bool newTyping) {
    _isTyping = newTyping;
    notifyListeners();
  }

  // pin the chat
  Future pinChat(
      {final String chatId,
      final String myId,
      final String friendId,
      final bool isPinned}) {
    return MessageProvider(chatId: chatId)
        .setPinnedStatus(isPinned: isPinned, myId: myId, friendId: friendId);
  }

  Future updateChatData(Map<String, dynamic> data, final String chatId) async {
    data.forEach((key, value) {
      if (value == null) {
        data = data.remove(key);
      }
    });
    return await MessageProvider(chatId: chatId).updateChatData(data);
  }

  Future readMessages(final String chatId) async {
    return await MessageProvider(chatId: chatId).readChatMessage();
  }

  // update typing state of the chat
  Future updateChatTyping(final bool typingVal, final String chatId,
      final AppUser appUser, final AppUser friend) async {
    final bool _isAppUserFirstUser = ChatHelper()
        .isAppUserFirstUser(myId: appUser.uid, friendId: friend.uid);

    Map<String, dynamic> _data;
    if (_isAppUserFirstUser) {
      _data = {
        'first_user_typing': typingVal,
      };
    } else {
      _data = {
        'second_user_typing': typingVal,
      };
    }

    if (_data != null) {
      await MessageProvider(chatId: chatId).updateChatData(_data);
    }
  }
}
