import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AppStorage {
  Future uploadSocialLink({@required final File imgFile}) async {
    try {
      final _uniqueId = Uuid();
      final _path =
          'social_links/${DateTime.now().millisecondsSinceEpoch}_${_uniqueId.v1()}';

      final _ref = FirebaseStorage.instance.ref().child(_path);
      final _uploadTask = _ref.putFile(imgFile);
      await _uploadTask.whenComplete(() => null);
      print('Upload completed!!!!');
      final _downloadUrl = await _ref.getDownloadURL();
      print('Success: Uploading social links to firebase storage');
      return _downloadUrl;
    } catch (e) {
      print(e);
      print('Error!!!: Uploading social links to firebase storage');
      return null;
    }
  }
}
