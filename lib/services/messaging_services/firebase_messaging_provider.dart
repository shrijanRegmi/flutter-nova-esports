import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseMessagingProvider {
  final String uid;
  final BuildContext context;
  FirebaseMessagingProvider({this.uid, this.context});

  final _ref = FirebaseFirestore.instance;
  final _firebaseMessaging = FirebaseMessaging();

  Future configureMessaging() async {
    _firebaseMessaging.configure(
      onLaunch: (message) {
        print('ON LAUNCH: $message');
        return null;
      },
      onResume: (message) {
        print('ON RESUME: $message');
        return null;
      },
    );
  }

  Future saveDevice() async {
    try {
      final _deviceInfo = DeviceInfoPlugin();
      final _androidInfo = await _deviceInfo.androidInfo;

      final _deviceRef = _ref
          .collection('users')
          .doc(uid)
          .collection('devices')
          .doc(_androidInfo.androidId);

      final _token = await _firebaseMessaging.getToken();
      print('Success: saving device info to firestore');
      await _deviceRef.set({'token': _token});
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!! saving device info to firestore');
      return null;
    }
  }

  Future removeDevice() async {
    try {
      final _deviceInfo = DeviceInfoPlugin();
      final _androidInfo = await _deviceInfo.androidInfo;

      final _deviceRef = _ref
          .collection('users')
          .doc(uid)
          .collection('devices')
          .doc(_androidInfo.androidId);

      print(
          'Success: Deleting device ${_androidInfo.androidId} info from firestore');
      await _deviceRef.delete();
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!! Deleting device info from firestore');
      return null;
    }
  }
}
