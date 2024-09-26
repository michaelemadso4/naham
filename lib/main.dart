import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naham/feutcher/Auth/Login/view/screen/LoginScreen.dart';
import 'package:naham/feutcher/SplaschScreen/view/Screens/SplaschScreen.dart';
import 'package:naham/feutcher/mainScreen/view/Screen/mainScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:naham/helper/sherdprefrence/sharedprefrenc.dart';
import 'firebase_options.dart';
import 'helper/WebRTCController.dart';
import 'routes/app_pages.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Naham',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.INTRODUCTION,
      getPages: AppPages.routes,
    );
  }
}


