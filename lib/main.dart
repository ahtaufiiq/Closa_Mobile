import 'package:flutter/material.dart';
import 'screens/activity/ActivityScreen.dart';
import 'screens/home/HomeScreen.dart';
import 'screens/profile/ProfileScreen.dart';
import './helpers/CustomScrolling.dart';
import 'package:firebase_core/firebase_core.dart';

void main() => runApp(MyApp());

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

        // // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            theme: new ThemeData(scaffoldBackgroundColor: Colors.white),
            home: ScrollConfiguration(
              behavior: MyBehavior(),
              child: Home(),
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

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ActivityScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text(''),
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Color(0xff777777),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
