// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

// Default [FirebaseOptions] for use with your Firebase apps.
//
// Example:
// ```dart
// import 'firebase_options.dart';
// // ...
// await Firebase.initializeApp(
//   options: DefaultFirebaseOptions.currentPlatform,
// );
// ```

mixin DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // ignore: missing_enum_constant_in_switch

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC8K3HJw20NLwessB9UogKQxRNHPz0c_mo',
    appId: '1:158482024099:web:f4799a2bbcd46bb5f1a116',
    messagingSenderId: '158482024099',
    projectId: 'words-app-1',
    authDomain: 'words-app-1.firebaseapp.com',
    storageBucket: 'words-app-1.appspot.com',
  );

}
