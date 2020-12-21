import 'package:closa_flutter/features/login/SignUpScreen.dart';
import 'package:closa_flutter/features/login/SignUpUsername.dart';
import 'package:closa_flutter/features/profile/EditProfileScreen.dart';
import 'package:closa_flutter/features/profile/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import './helpers/CustomScrolling.dart';
import 'package:firebase_core/firebase_core.dart';

import 'features/home/TaskScreen.dart';
import 'helpers/sharedPref.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
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
            ],
            theme: new ThemeData(scaffoldBackgroundColor: Colors.white),
            home: ScrollConfiguration(
              behavior: MyBehavior(),
              child: sharedPrefs.name == "" ? SignUpScreen() : TaskScreen(),
              // child: ProfileScreen(),
            ),
          );
        }
        return MaterialApp(
          home: Center(
            child: Text("Loading"),
          ),
        );
      },
    );
  }
}
