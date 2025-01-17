// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDuxavuKWexqwazO-o2n-LgzlwwUFJ0iYA',
    appId: '1:170013918155:web:5d133d6fa450c9a9c8ac4e',
    messagingSenderId: '170013918155',
    projectId: 'ngchat-b43ff',
    authDomain: 'ngchat-b43ff.firebaseapp.com',
    storageBucket: 'ngchat-b43ff.firebasestorage.app',
    measurementId: 'G-1RELB142DQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBOBzmiu8MLt8kHNo5oQDbhzeDT164M6ms',
    appId: '1:170013918155:android:15f56c80e47606dbc8ac4e',
    messagingSenderId: '170013918155',
    projectId: 'ngchat-b43ff',
    storageBucket: 'ngchat-b43ff.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBV3pHLw13jCjfjDSAK0pAFW_0v2vgwRuM',
    appId: '1:170013918155:ios:b8273635d7331930c8ac4e',
    messagingSenderId: '170013918155',
    projectId: 'ngchat-b43ff',
    storageBucket: 'ngchat-b43ff.firebasestorage.app',
    iosBundleId: 'com.tadafuq.naham',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBV3pHLw13jCjfjDSAK0pAFW_0v2vgwRuM',
    appId: '1:170013918155:ios:b8273635d7331930c8ac4e',
    messagingSenderId: '170013918155',
    projectId: 'ngchat-b43ff',
    storageBucket: 'ngchat-b43ff.firebasestorage.app',
    iosBundleId: 'com.tadafuq.naham',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDuxavuKWexqwazO-o2n-LgzlwwUFJ0iYA',
    appId: '1:170013918155:web:e124b3c72f38cdfbc8ac4e',
    messagingSenderId: '170013918155',
    projectId: 'ngchat-b43ff',
    authDomain: 'ngchat-b43ff.firebaseapp.com',
    storageBucket: 'ngchat-b43ff.firebasestorage.app',
    measurementId: 'G-1Z7B0GB62W',
  );

}