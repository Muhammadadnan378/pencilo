import 'package:firebase_messaging/firebase_messaging.dart';

import '../data/consts/const_import.dart';

class FcmService {
  static void firebaseInit() {
    FirebaseMessaging.onMessage.listen(
      (message) {
        debugPrint(message.notification!.title);
        debugPrint(message.notification!.body);
      },
    );
  }
}
