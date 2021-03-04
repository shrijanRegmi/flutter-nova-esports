import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class UserStorage {
  // upload user image to storage;
  Future uploadUserImage({@required final File imgFile}) async {
    try {
      final _uniqueId = Uuid();
      final _path =
          'profile_imgs/${DateTime.now().millisecondsSinceEpoch}_${_uniqueId.v1()}';

      final _ref = FirebaseStorage.instance.ref().child(_path);
      final _uploadTask = _ref.putFile(imgFile);
      await _uploadTask.whenComplete(() => null);
      print('Upload completed!!!!');
      final _downloadUrl = await _ref.getDownloadURL();
      print('Success: Uploading image to firebase storage');
      return _downloadUrl;
    } catch (e) {
      print(e);
      print('Error!!!: Uploading image to firebase storage');
      return null;
    }
  }
}
