import 'dart:async';
import 'package:closa_flutter/core/storage/device_token.dart';
import 'package:closa_flutter/core/utils/fcm_util.dart';
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

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  bool doneHighlight = false;
  bool doneOthers = true;
  bool emptyTodo = false;
  bool emptyHighlight = true;
  @override
  void initState() {
    if (sharedPrefs.dateNow != FormatTime.getToday()) {
      sharedPrefs.dateNow = FormatTime.getToday();
      sharedPrefs.doneHighlight = false;
      sharedPrefs.doneOthers = true;
    }
    super.initState();
  }

  void saveValue(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

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
      body: SafeArea(
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
                      Padding(
                        padding: EdgeInsets.only(left: 24.0, top: 28.0),
                        child: TextDescription(
                          text: "Task",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: 16.0, left: 24.0, right: 24.0),
                        child: TextHeader(text: FormatTime.getToday()),
                      ),
                      Container(
                        child: StreamBuilder(
                            stream: getHighlight(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: Text("loading"),
                                );
                              }
                              if (snapshot.data.docs.length == 0) {
                                return Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 24.0, right: 24.0),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.wb_sunny_outlined,
                                            color: Colors.grey,
                                            size: 16.0,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 4.0),
                                          ),
                                          TextDescription(
                                            text: "Highlight",
                                            color: CustomColor.Grey,
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: 24.0, right: 24.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            addTodoBottomSheet(context,
                                                type: "highlight");
                                          },
                                          child: Card(
                                            margin: EdgeInsets.only(
                                                top: 16.0,
                                                left: 2.0,
                                                right: 2.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            elevation: 4.0,
                                            child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: 24.0,
                                                    bottom: 24.0,
                                                    left: 16.0,
                                                    right: 24.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.wb_sunny_outlined,
                                                      color: Color(0xFFFF9500),
                                                    ),
                                                    SizedBox(
                                                      width: 12.0,
                                                    ),
                                                    Expanded(
                                                        child: TextDescription(
                                                            text:
                                                                "Set Highlight Today")),
                                                  ],
                                                )),
                                          ),
                                        )),
                                    Divider(
                                      color: CustomColor.Divider,
                                      thickness: 1,
                                      height: 56.0,
                                    ),
                                  ],
                                );
                              }

                              if (snapshot.data.docs.first["status"]) {
                                sharedPrefs.doneHighlight = true;
                                if (sharedPrefs.doneHighlight &&
                                    sharedPrefs.doneOthers) {
                                  Timer(Duration(milliseconds: 400), () {
                                    Get.offAllNamed("/task2");
                                  });
                                }
                                return Container();
                              }
                              sharedPrefs.doneHighlight = false;
                              return Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 24.0, right: 24.0),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.wb_sunny_outlined,
                                          color: Colors.grey,
                                          size: 16.0,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 4.0),
                                        ),
                                        TextDescription(
                                          text: "Highlight",
                                          color: CustomColor.Grey,
                                        )
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showBottomEdit(
                                          context, snapshot.data.docs.last);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 24.0, right: 24.0),
                                      child: CardTodo(
                                        id: snapshot.data.docs.last.id,
                                        type: "highlight",
                                        description: snapshot
                                            .data.docs.last['description'],
                                        status:
                                            snapshot.data.docs.last['status'],
                                        time: snapshot
                                            .data.docs.last['timestamp'],
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: CustomColor.Divider,
                                    thickness: 1,
                                    height: 56.0,
                                  ),
                                ],
                              );
                            }),
                      ),
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
                                sharedPrefs.doneOthers = true;
                                if (sharedPrefs.doneHighlight &&
                                    sharedPrefs.doneOthers) {
                                  Timer(Duration(milliseconds: 400), () {
                                    Get.offAllNamed("/task2");
                                  });
                                }
                                return Container();
                              }
                              sharedPrefs.doneOthers = false;
                              var counter = 0;
                              return Column(
                                children: snapshot.data.docs.map((data) {
                                  if (data['type'] != 'highlight') {
                                    counter++;
                                    if (counter == 1) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextDescription(
                                            text: "Others",
                                            color: CustomColor.Grey,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showBottomEdit(context, data);
                                            },
                                            child: CardTodo(
                                              id: data.id,
                                              description: data['description'],
                                              time: data['timestamp'],
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                    return GestureDetector(
                                      onTap: () {
                                        showBottomEdit(context, data);
                                      },
                                      child: CardTodo(
                                        id: data.id,
                                        description: data['description'],
                                        time: data['timestamp'],
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                }).toList(),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                child: GestureDetector(
                  onTap: () => {},
                  child: CustomIcon(
                    type: "menu",
                  ),
                ),
                left: 24.0,
                bottom: 24.0),
            Positioned(
                child: GestureDetector(
                  // onTap: () => openScreenProfile(context),
                  onTap: () {
                    openScreenProfile(context);
                  },
                  child: CustomIcon(
                    type: "profile",
                  ),
                ),
                right: 24.0,
                bottom: 24.0),
            Positioned(
              child: GestureDetector(
                onTap: () => showBottomAdd(context),
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
    );
  }
}
