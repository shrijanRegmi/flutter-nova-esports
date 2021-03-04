import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingProvider {
  final String uid;
  FirebaseMessagingProvider({this.uid});

  final _ref = FirebaseFirestore.instance;
  final _firebaseMessaging = FirebaseMessaging();

  // save device to firestore
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
}
