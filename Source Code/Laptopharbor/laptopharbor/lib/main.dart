// ignore_for_file: prefer_const_constructors, unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laptopharbor/Authentication/Login.dart';
import 'package:laptopharbor/Authentication/Signup.dart';
import 'package:laptopharbor/Screens/Category.dart';
import 'package:laptopharbor/Screens/Deal.dart';
import 'package:laptopharbor/Screens/Feature.dart';
import 'package:laptopharbor/Screens/Feedback.dart';
import 'package:laptopharbor/Screens/Gallery.dart';
import 'package:laptopharbor/Screens/Orderform.dart';
import 'package:laptopharbor/Screens/PaymentMethod.dart';
import 'package:laptopharbor/Screens/ProfileSetting.dart';
import 'package:laptopharbor/Screens/Sort.dart';
import 'package:laptopharbor/Screens/Trackorder.dart';
import 'package:laptopharbor/Splash/splashscreen.dart';
import 'package:laptopharbor/firebase_options.dart';
import 'package:laptopharbor/myHome.dart';
import 'package:video_player/video_player.dart';


 void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      // home : SplashScreen(),
      home : MyHome(),
    );
  }
}

