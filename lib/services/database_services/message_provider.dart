import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peaman/helpers/chat_helper.dart';
import 'package:peaman/models/app_models/chat_model.dart';
import 'package:peaman/models/app_models/message_model.dart';

class MessageProvider {
  final String chatId;
  final DocumentReference messageRef;
  final String appUserId;
  MessageProvider({this.chatId, this.messageRef, this.appUserId});

  final _ref = FirebaseFirestore.instance;

  // send message
  Future sendMessage({@required final Message message}) async {
    try {
      final _message = Message.toJson(message);
      final _messagesRef =
          _ref.collection('chats').doc(chatId).collection('messages');
      final _chatRef = _ref.collection('chats').doc(chatId);

      final _messagesDocs = await _messagesRef.limit(2).get();

      if (_messagesDocs.docs.length == 0) {
        await _chatRef.set({'id': chatId});
      }

      final _lastMsgRef = await _messagesRef.add(_message);

      _chatRef.update({'last_updated': DateTime.now()});
      _chatRef.update({'last_msg_ref': _lastMsgRef});
      print('Success: Sending message to ${message.receiverId}');
    } catch (e) {
      print(e);
      print('Error: Sending message to ${message.receiverId}');
      return null;
    }
  }

  // set pinned status
  Future setPinnedStatus(
      {@required final bool isPinned,
      @required final String myId,
      @required final String friendId}) async {
    try {
      final _isAppUserFirstUser = ChatHelper().isAppUserFirstUser(
        myId: myId,
        friendId: friendId,
      );

      final _chatRef = _ref.collection('chats').doc(chatId);

      Map<String, dynamic> _data;

      if (_isAppUserFirstUser) {
        _data = {
          'first_user_pinned_second_user': isPinned,
        };
      } else {
        _data = {
          'second_user_pinned_first_user': isPinned,
        };
      }

      await _chatRef.update(_data);
      print('Success: Pinned user with id $friendId');
      return 'Sucess';
    } catch (e) {
      print(e);
      print('Error!!!: Pinned user with id $friendId');
      return null;
    }
  }

  // update chat data
  Future updateChatData(final Map<String, dynamic> data) async {
    try {
      final _chatRef = _ref.collection('chats').doc(chatId);
      await _chatRef.update(data);
      print('Success: Updating chat data having chatId $chatId');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Updating chat data having chatId $chatId');
      return null;
    }
  }

  // read chat message
  Future readChatMessage() async {
    try {
      final _chatRef = _ref.collection('chats').doc(chatId);
      await _chatRef.update({});
      print('Success: Reading message by user');
    } catch (e) {
      print(e);
      print('Error: Reading message by user');
    }
  }

  // message from firebase
  List<Message> _messageFromFirebase(QuerySnapshot snap) {
    return snap.docs.map((doc) {
      return Message.fromJson(doc.data());
    }).toList();
  }

  // message from firebase
  Message _singleMessageFrom(DocumentSnapshot snap) {
    return Message.fromJson(snap.data());
  }

  // chats from firebase
  List<Chat> _chatsFromFirebase(QuerySnapshot snap) {
    return snap.docs.map((doc) {
      return Chat.fromJson(doc.data());
    }).toList();
  }

  // stream of messages;
  Stream<List<Message>> get messagesList {
    return _ref
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('milliseconds', descending: true)
        .limit(50)
        .snapshots()
        .map(_messageFromFirebase);
  }

  // stream of chats
  Stream<List<Chat>> get chatList {
    return _ref
        .collection('chats')
        .where('users', arrayContains: appUserId)
        .orderBy('last_updated', descending: true)
        .snapshots()
        .map(_chatsFromFirebase);
  }

  // stream of message from a particular reference
  Stream<Message> get messageFromRef {
    return messageRef.snapshots().map(_singleMessageFrom);
  }
}
