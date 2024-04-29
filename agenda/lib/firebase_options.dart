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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCf0dKWg8S4w2XFmSIbnrfkzY8MC53ESBw',
    appId: '1:419976547622:web:ed0929837081baabcd05e7',
    messagingSenderId: '419976547622',
    projectId: 'agenda-9c298',
    authDomain: 'agenda-9c298.firebaseapp.com',
    storageBucket: 'agenda-9c298.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD6F3R7HOSaHb0znWHGW1guZRXp--c7m7A',
    appId: '1:419976547622:android:4d0c827556343d08cd05e7',
    messagingSenderId: '419976547622',
    projectId: 'agenda-9c298',
    storageBucket: 'agenda-9c298.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDM2fxZJfLdUakztVMk5C21-rhbT4uhA7I',
    appId: '1:419976547622:ios:ed988010930bf3b3cd05e7',
    messagingSenderId: '419976547622',
    projectId: 'agenda-9c298',
    storageBucket: 'agenda-9c298.appspot.com',
    iosBundleId: 'com.example.agenda',
  );
}
