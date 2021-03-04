import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final DocumentReference firstUserRef;
  final DocumentReference secondUserRef;
  final DocumentReference lastMsgRef;
  final bool firstUserTyping;
  final bool secondUserTyping;
  final String id;
  final bool firstUserPinnedSecondUser;
  final bool secondUserPinnedFirstUser;
  final int firstUserUnreadMessagesCount;
  final int secondUserUnreadMessagesCount;

  Chat({
    this.firstUserRef,
    this.secondUserRef,
    this.firstUserTyping,
    this.secondUserTyping,
    this.lastMsgRef,
    this.id,
    this.firstUserPinnedSecondUser,
    this.secondUserPinnedFirstUser,
    this.firstUserUnreadMessagesCount,
    this.secondUserUnreadMessagesCount,
  });

  static Map<String, dynamic> toJson(Chat chat) {
    return {
      'first_user_ref': chat.firstUserRef,
      'second_user_ref': chat.secondUserRef,
      'first_user_typing': chat.firstUserTyping,
      'second_user_typing': chat.secondUserTyping,
      'last_msg_ref': chat.lastMsgRef,
      'id': chat.id,
      'first_user_pinned_second_user': chat.firstUserPinnedSecondUser,
      'second_user_pinned_first_user': chat.secondUserPinnedFirstUser,
    };
  }

  static Chat fromJson(Map<String, dynamic> data) {
    return Chat(
      firstUserRef: data['first_user_ref'],
      secondUserRef: data['second_user_ref'],
      firstUserTyping: data['first_user_typing'] ?? false,
      secondUserTyping: data['second_user_typing'] ?? false,
      lastMsgRef: data['last_msg_ref'],
      id: data['id'],
      firstUserPinnedSecondUser: data['first_user_pinned_second_user'] ?? false,
      secondUserPinnedFirstUser: data['second_user_pinned_first_user'] ?? false,
      firstUserUnreadMessagesCount: data['first_user_unread_messages_count'] ?? 0,
      secondUserUnreadMessagesCount: data['second_user_unread_messages_count'] ?? 0,
    );
  }
}
