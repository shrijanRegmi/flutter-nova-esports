import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FeedStorage {
  final String uid;
  FeedStorage({this.uid});

  // upload feed image
  uploadFeedImages(final List<File> photos) async {
    List<String> _downloadUrls = [];
    try {
      for (final photo in photos) {
        final _path = 'feed_imgs/$uid/${DateTime.now().millisecondsSinceEpoch}';
        final _ref = FirebaseStorage.instance.ref().child(_path);
        final _uploadTask = _ref.putFile(photo);
        await _uploadTask.whenComplete(() => null);
        print('Upload Completed!!!');
        final _downloadUrl = await _ref.getDownloadURL();
        _downloadUrls.add(_downloadUrl);
        print('Success: Uploading feed image');
      }

      return _downloadUrls;
    } catch (e) {
      print(e);
      print('Error!!!: Uploading feed image');
      return null;
    }
  }

  // upload moment image
  Future<String> uploadMomentImage(final File photo) async {
    try {
      final _path = 'moment_images/$uid/${DateTime.now().millisecondsSinceEpoch}';
      final _ref = FirebaseStorage.instance.ref().child(_path);
      final _uploadTask = _ref.putFile(photo);
      await _uploadTask.whenComplete(() => null);
      print('Success: Uploading moment image');
      final _downloadUrl = await _ref.getDownloadURL();
      return _downloadUrl;
    } catch (e) {
      print(e);
      print('Error!!!: Uploading moment image');
      return null;
    }
  }
}
