import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyA4YdsQR1lvbhD5hi7thjdWalW7azySSoI",
    authDomain: "todo-list-ae91a.firebaseapp.com",
    projectId: "todo-list-ae91a",
    storageBucket: "todo-list-ae91a.firebasestorage.app",
    messagingSenderId: "192267812720",
    appId: "1:192267812720:web:4585f161b3ed3983ff59b5",
    measurementId: "G-06CL16DTSQ",
  );
}
