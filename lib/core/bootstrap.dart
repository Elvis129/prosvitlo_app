import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/firebase_status.dart';
import '../data/services/log_color.dart';
import '../firebase_options.dart';

/// App bootstrap - initialization of all dependencies before launch
Future<FirebaseStatus> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  FirebaseStatus firebaseStatus = FirebaseStatus.unavailable;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseStatus = FirebaseStatus.ready;
  } catch (e) {
    logWarning('Firebase initialization failed: $e');
    // Continue without Firebase - the app still works
  }

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  return firebaseStatus;
}
