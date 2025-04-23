import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBbDcKALQEv_-yfaqFrElMQeqmVnxvDCxA",
        authDomain: "ems1-9dfdc.firebaseapp.com",
        projectId: "ems1-9dfdc",
        storageBucket: "ems1-9dfdc.appspot.com",
        messagingSenderId: "236280531708",
        appId: "1:236280531708:web:bb1685671c97a9f1e12579",
      ),
    );
  }
}
