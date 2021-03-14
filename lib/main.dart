import 'package:closa_flutter/features/login/SignUpProfile.dart';
import 'package:closa_flutter/features/task/TaskScreen.dart';
import 'package:closa_flutter/features/task/TaskScreen2.dart';
import 'package:closa_flutter/core/utils/local_notification.dart';
import 'package:closa_flutter/features/login/SignUpScreen.dart';
import 'package:closa_flutter/features/login/SignUpUsername.dart';
import 'package:closa_flutter/features/profile/EditProfileScreen.dart';
import 'package:closa_flutter/features/profile/ProfileScreen.dart';
import 'package:closa_flutter/features/setting/SettingScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import './helpers/CustomScrolling.dart';
import 'package:firebase_core/firebase_core.dart';
import './helpers/FormatTime.dart';
import 'features/backlog/BacklogScreen.dart';
import 'helpers/sharedPref.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

void main(
    {LocalNotification localNotification = const LocalNotification(),
    Widget root = const MyApp()}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  // DI setup
  runApp(root);
  if (!kIsWeb) {
    localNotification.localNotifInit();
    if (sharedPrefs.notificationStatus == true) {
      await localNotification.setDailyNotification();
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // // Check for errors
        if (snapshot.hasError) {
          return MaterialApp(
            home: Center(
              child: Text(snapshot.error),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return GetMaterialApp(
            getPages: [
              GetPage(
                name: '/task',
                page: () => TaskScreen(),
              ),
              GetPage(
                name: '/signup',
                page: () => SignUpScreen(),
              ),
              GetPage(
                name: '/profile/edit',
                page: () => EditProfile(),
              ),
              GetPage(
                name: '/profile',
                page: () => ProfileScreen(),
              ),
              GetPage(
                name: '/setting',
                page: () => SettingsScreen(),
              ),
              GetPage(
                name: '/task2',
                page: () => TaskScreenCopy(),
              ),
            ],
            theme: new ThemeData(scaffoldBackgroundColor: Colors.white),
            home: ScrollConfiguration(
              behavior: MyBehavior(),
              child: sharedPrefs.username == ""
                  ? SignUpScreen()
                  : sharedPrefs.doneHighlight &&
                          sharedPrefs.doneOthers &&
                          sharedPrefs.dateNow == FormatTime.getToday()
                      ? TaskScreenCopy()
                      : TaskScreen(),
              // child: BacklogScreen(),
            ),
          );
        }
        return MaterialApp(
          home: Scaffold(
            backgroundColor: Color(0xFFFAFAFB),
            body: SafeArea(
              child: Container(),
            ),
          ),
        );
      },
    );
  }
}
