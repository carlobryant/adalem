import 'dart:io';
import 'package:adalem/components/loader_md.dart';
import 'package:adalem/features/auth/presentation/view_login.dart';
import 'package:adalem/core/config/firebase_options.dart';
import 'package:adalem/shell.dart';
import 'package:adalem/core/theme/dark_mode.dart';
import 'package:adalem/core/theme/light_mode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ADALEM',

      theme: lightMode,
      darkTheme: darkMode,
      
      //home: SmallLoader(),
      home: Platform.isAndroid ? LoginView() : Shell(), //Add view: ADALEM is only available on Android
      //view for new user/tutorial

      routes: {
        '/home': (context) => const Shell(),
      }
    );
  }
}

//Try debug paint

