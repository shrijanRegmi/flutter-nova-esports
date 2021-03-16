import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/message_model.dart';
import 'package:uuid/uuid.dart';

class ChatStorage {
  final String chatId;
  final Message message;
  final Function sendMsgCallback;
  ChatStorage({
    this.chatId,
    this.message,
    this.sendMsgCallback,
  });
  // upload chat image to storage;
  Future uploadChatImage({@required final File imgFile}) async {
    try {
      final _uniqueId = Uuid();
      final _path =
          'chat_imgs/$chatId/${DateTime.now().millisecondsSinceEpoch}_${_uniqueId.v1()}_${message.senderId}';

      final _ref = FirebaseStorage.instance.ref().child(_path);
      final _uploadTask = _ref.putFile(imgFile);
      await _uploadTask.whenComplete(() => null);
      print('Upload completed!!!!');
      final _downloadUrl = await _ref.getDownloadURL();
      print('Success: Uploading image to firebase storage');

      final _message = message;
      _message.text = _downloadUrl;

      sendMsgCallback(
        chatId: chatId,
        message: _message,
      );

      return _downloadUrl;
    } catch (e) {
      print(e);
      print('Error!!!: Uploading image to firebase storage');
      return null;
    }
  }
}
