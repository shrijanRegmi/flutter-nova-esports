import 'package:peaman/enums/message_types.dart';

class Message {
  String text;
  final String senderId;
  final String receiverId;
  final int milliseconds;
  final MessageType type;
  Message({
    this.text,
    this.senderId,
    this.receiverId,
    this.milliseconds,
    this.type,
  });

  static Map<String, dynamic> toJson(Message message) {
    return {
      'text': message.text,
      'senderId': message.senderId,
      'receiverId': message.receiverId,
      'milliseconds': message.milliseconds,
      'type': message.type.index,
    };
  }

  static Message fromJson(Map<String, dynamic> data) {
    if (data['type'] == MessageType.Image.index) {
      return ImageMessage(
        text: data['text'],
        senderId: data['senderId'],
        receiverId: data['receiverId'],
        milliseconds: data['milliseconds'],
        type: MessageType.Image,
      );
    }
    return TextMessage(
      text: data['text'],
      senderId: data['senderId'],
      receiverId: data['receiverId'],
      milliseconds: data['milliseconds'],
      type: MessageType.Text,
    );
  }
}

class TextMessage extends Message {
  String text;
  final String senderId;
  final String receiverId;
  final int milliseconds;
  final MessageType type;

  TextMessage({
    this.text,
    this.senderId,
    this.receiverId,
    this.milliseconds,
    this.type,
  }) : super(
          text: text,
          senderId: senderId,
          receiverId: receiverId,
          milliseconds: milliseconds,
          type: MessageType.Text,
        );
}
class ImageMessage extends Message {
  String text;
  final String senderId;
  final String receiverId;
  final int milliseconds;
  final MessageType type;

  ImageMessage({
    this.text,
    this.senderId,
    this.receiverId,
    this.milliseconds,
    this.type,
  }) : super(
          text: text,
          senderId: senderId,
          receiverId: receiverId,
          milliseconds: milliseconds,
          type: MessageType.Image,
        );
}
