import 'dart:async';

import 'package:closa_flutter/features/backlog/BacklogScreen.dart';
import 'package:closa_flutter/features/menu/MenuScreen.dart';
import 'package:closa_flutter/features/profile/ProfileScreen.dart';
import 'package:closa_flutter/helpers/sharedPref.dart';
import 'package:closa_flutter/widgets/BottomSheetEdit.dart';
import 'package:closa_flutter/widgets/CustomIcon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/Text.dart';
import '../../widgets/CardTodo.dart';
import '../../helpers/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../helpers/FormatTime.dart';
import '../../widgets/OptionsTodo.dart';
import 'package:closa_flutter/widgets/BottomSheetAdd.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskScreenCopy extends StatefulWidget {
  @override
  _TaskScreenCopyState createState() => _TaskScreenCopyState();
}

class _TaskScreenCopyState extends State<TaskScreenCopy> {
  Future<String> getValue(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString(key);
    return stringValue;
  }

  void showBottomAdd(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
          ),
        ),
        builder: (_) => BottomSheetAdd());
  }

  void showBottomEdit(context, data) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
          ),
        ),
        builder: (_) => BottomSheetEdit(
              id: data.id,
              type: data["type"],
              description: data['description'],
              time: data['timestamp'],
            ));
  }

  Stream<QuerySnapshot> getHighlight() {
    return FirebaseFirestore.instance
        .collection('todos')
        .where('userId', isEqualTo: sharedPrefs.idUser)
        .where('type', isEqualTo: 'highlight')
        .where("timestamp",
            isGreaterThanOrEqualTo: FormatTime.getTimestampToday())
        .where("timestamp", isLessThan: FormatTime.getTimestampTomorrow())
        .limit(1)
        .snapshots();
  }

  Stream<QuerySnapshot> getTodo() {
    return FirebaseFirestore.instance
        .collection('todos')
        .where('userId', isEqualTo: sharedPrefs.idUser)
        .where('status', isEqualTo: false)
        .where("timestamp",
            isGreaterThanOrEqualTo: FormatTime.getTimestampToday())
        .where("timestamp", isLessThan: FormatTime.getTimestampTomorrow())
        .snapshots();
  }

  void addTodoBottomSheet(context, {type = "default"}) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
          ),
        ),
        builder: (_) => BottomSheetAdd(
              type: type,
            ));
  }

  void openScreenProfile(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen()),
    );
  }

  void optionsBottomSheet(context, data) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
          ),
        ),
        builder: (_) => OptionsTodo(
            id: data.id,
            description: data['description'],
            time: data['timestamp']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFB),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    "assets/background/${sharedPrefs.surprisingImage}"),
                fit: BoxFit.cover)),
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 60.0,
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 24.0, right: 24.0),
                          child: StreamBuilder(
                              stream: getTodo(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: Text("loading"),
                                  );
                                }
                                if (snapshot.data.docs.length == 0) {
                                  return Container();
                                }
                                sharedPrefs.doneOthers = false;
                                Timer(Duration(seconds: 1), () {
                                  Get.offAllNamed("/task");
                                });
                                return Container();
                              }),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BacklogScreen()),
                      );
                    },
                    child: CustomIcon(type: "menu", color: Colors.white),
                  ),
                  left: 24.0,
                  bottom: 24.0),
              Positioned(
                  child: GestureDetector(
                    // onTap: () => openScreenProfile(context),
                    onTap: () {
                      openScreenProfile(context);
                    },
                    child: CustomIcon(type: "profile", color: Colors.white),
                  ),
                  right: 24.0,
                  bottom: 24.0),
              Positioned(
                child: TextSmall(
                    text: "You have done what matters today.",
                    color: Colors.white),
                bottom: 100,
              ),
              Positioned(
                child: GestureDetector(
                  onTap: () {
                    showBottomAdd(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.0),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF000000).withOpacity(0.12),
                          blurRadius: 6,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: CustomIcon(
                      type: "add",
                    ),
                  ),
                ),
                bottom: 32.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
