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
    apiKey: 'AIzaSyD8w3NqcRySxXY9IQyexJBUfSOYhcnUncg',
    appId: '1:186895787525:web:61451997c33c379fa05e6c',
    messagingSenderId: '186895787525',
    projectId: 'naham-83039',
    authDomain: 'naham-83039.firebaseapp.com',
    storageBucket: 'naham-83039.appspot.com',
    measurementId: 'G-LJ2GBR14BX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBw73OC7lXYsKxeexicwuO3gT8kyn3NfWo',
    appId: '1:186895787525:android:2895a3f04ce29c59a05e6c',
    messagingSenderId: '186895787525',
    projectId: 'naham-83039',
    storageBucket: 'naham-83039.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCWBVRKAnGlX-fks8EBwsKsPgcLAuuMQY4',
    appId: '1:186895787525:ios:65b6afe0c97aac17a05e6c',
    messagingSenderId: '186895787525',
    projectId: 'naham-83039',
    storageBucket: 'naham-83039.appspot.com',
    iosBundleId: 'com.tadafuq.naham',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCWBVRKAnGlX-fks8EBwsKsPgcLAuuMQY4',
    appId: '1:186895787525:ios:65b6afe0c97aac17a05e6c',
    messagingSenderId: '186895787525',
    projectId: 'naham-83039',
    storageBucket: 'naham-83039.appspot.com',
    iosBundleId: 'com.tadafuq.naham',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD8w3NqcRySxXY9IQyexJBUfSOYhcnUncg',
    appId: '1:186895787525:web:bf60fef1aee8ce05a05e6c',
    messagingSenderId: '186895787525',
    projectId: 'naham-83039',
    authDomain: 'naham-83039.firebaseapp.com',
    storageBucket: 'naham-83039.appspot.com',
    measurementId: 'G-RVH30T0L29',
  );
}
