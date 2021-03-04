import 'dart:io';

import 'package:flutter/material.dart';
import 'package:peaman/services/database_services/user_provider.dart';
import 'package:peaman/services/storage_services/user_storage_service.dart';

class ProfileInfoVm extends ChangeNotifier {
  // update users data
  Future updateUsersData({
    final String uid,
    final File imgFile,
    final Map<String, dynamic> data,
  }) async {
    var _result;

    if (imgFile != null) {
      final _imgResult = await UserStorage().uploadUserImage(imgFile: imgFile);
      if (_imgResult != null) {
        _result = await AppUserProvider(uid: uid).updateUserDetail(
          data: {
            'photoUrl': _imgResult,
          },
        );
      }
    }

    if (data.isNotEmpty) {
      _result = await AppUserProvider(uid: uid).updateUserDetail(data: data);
    }

    return _result;
  }
}
