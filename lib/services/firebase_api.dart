
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNofications() async {
    await _firebaseMessaging.requestPermission();
    

  }
}