import 'package:flutter/material.dart';
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
    final String chatId,
    final Message message,
  }) {
    return MessageProvider(chatId: chatId).sendMessage(message: message);
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
}
