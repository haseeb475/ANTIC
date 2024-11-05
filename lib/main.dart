import 'dart:io';
import 'dart:math';

import 'package:antic/controller/ImageController.dart';
import 'package:antic/view/signIn.dart';
import 'package:clipboard/clipboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'const/const.dart';
import 'firebase_options.dart';
import 'model/services/authServices.dart';
import 'model/services/profileInfoServices.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) {
    Get.put(AuthServices());
    Get.put(ProfileInfoServices());
  });
  runApp(const MyApp());
}

const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(_blackPrimaryValue),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);
const int _blackPrimaryValue = 0xFF000000;

const MaterialColor primarywhite = MaterialColor(
  _whitePrimaryValue,
  <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(_blackPrimaryValue),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);
const int _whitePrimaryValue = 0xFFFFFFFF;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
        title: 'ANTIC',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarColor: Colors.transparent),
            backgroundColor: Colors.white,
            elevation: 0,
            titleTextStyle:
                GoogleFonts.poppins(fontSize: 20, color: Colors.black),
          ),
          primarySwatch: primaryBlack,
          primaryColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          bottomAppBarTheme: BottomAppBarTheme(color: Colors.grey),
          // brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          appBarTheme: AppBarTheme(
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarColor: Colors.transparent),
            elevation: 0,
            color: Colors.grey[850],
          ),
          brightness: Brightness.dark,
          primarySwatch: primarywhite,
          primaryColor: Colors.white,
          /* dark theme settings */
        ),
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            height: context.height,
            width: context.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'A N T I C',
                  style: GoogleFonts.montserrat(
                      color: purpleColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w200),
                ),
                SizedBox(height: 10),
                CupertinoActivityIndicator(
                  color: purpleColor,
                ),
              ],
            ),
          ),
        ));
  }
}
