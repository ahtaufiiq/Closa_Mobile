import 'dart:async';
import 'package:closa_flutter/features/backlog/BacklogScreen.dart';
import 'package:closa_flutter/features/menu/MenuScreen.dart';
import 'package:closa_flutter/features/profile/ProfileScreen.dart';
import 'package:closa_flutter/helpers/sharedPref.dart';
import 'package:closa_flutter/widgets/BottomSheetEdit.dart';
import 'package:closa_flutter/widgets/CustomIcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../widgets/Text.dart';
import '../../widgets/CardTodo.dart';
import '../../helpers/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../helpers/FormatTime.dart';
import '../../widgets/OptionsTodo.dart';
import 'package:closa_flutter/widgets/BottomSheetAdd.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

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
      var max = 6;
      var random = new Random().nextInt(max) + 1;
      if ("$random.jpg" == sharedPrefs.surprisingImage) {
        if (random == max) {
          random -= 1;
        } else {
          random += 1;
        }
      }
      sharedPrefs.surprisingImage = "$random.jpg";
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
              timeReminder: data["timeReminder"],
              notifId: data['notificationId'],
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

  void optionsBottomSheet(context, data) {
    print(data);
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
            id: data["id"],
            description: data["description"],
            type: data["type"],
            time: data["time"],
            timeReminder: data["timeReminder"],
            notifId: data['notifId']));
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
              bottom: 0,
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
                                return Container();
                              }
                              if (snapshot.data.docs.length == 0) {
                                return Column(
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: 24.0, right: 24.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            addTodoBottomSheet(context,
                                                type: "highlight");
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 16.0,
                                                left: 2.0,
                                                right: 2.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0xFF000000)
                                                      .withOpacity(0.12),
                                                  blurRadius: 6,
                                                  offset: Offset(0,
                                                      2), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: 24.0,
                                                    bottom: 24.0,
                                                    left: 16.0,
                                                    right: 24.0),
                                                child: Row(
                                                  children: [
                                                    CustomIcon(
                                                      type: 'highlight',
                                                    ),
                                                    SizedBox(
                                                      width: 12.0,
                                                    ),
                                                    Expanded(
                                                        child: TextDescription(
                                                            text:
                                                                "Set Today’s Highlight")),
                                                  ],
                                                )),
                                          ),
                                        )),
                                  ],
                                );
                              }

                              if (snapshot.data.docs.first["status"]) {
                                sharedPrefs.doneHighlight = true;
                                if (sharedPrefs.doneHighlight &&
                                    sharedPrefs.doneOthers) {
                                  Timer(Duration(seconds: 1), () {
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
                                        CustomIcon(
                                          type: "highlight",
                                          color: Color(0xFF888888),
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
                                    onLongPress: () {
                                      var dataTodo = {
                                        "id": snapshot.data.docs.last.id,
                                        "description": snapshot
                                            .data.docs.last['description'],
                                        "type": "highlight",
                                        "time": snapshot
                                            .data.docs.last['timestamp'],
                                        "timeReminder": snapshot
                                            .data.docs.last["timeReminder"],
                                      };
                                      optionsBottomSheet(context, dataTodo);
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
                                  )
                                ],
                              );
                            }),
                      ),
                      Container(
                        child: StreamBuilder(
                            stream: getTodo(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Container();
                              }
                              if (snapshot.data.docs.length == 0) {
                                sharedPrefs.doneOthers = true;
                                if (sharedPrefs.doneHighlight &&
                                    sharedPrefs.doneOthers) {
                                  Timer(Duration(seconds: 1), () {
                                    Get.offAllNamed("/task2");
                                  });
                                }
                                return Container();
                              }
                              sharedPrefs.doneOthers = false;
                              var counter = 0;
                              return Container(
                                margin: EdgeInsets.only(bottom: 100),
                                child: Column(
                                  children: snapshot.data.docs.map((data) {
                                    if (data['type'] != 'highlight') {
                                      counter++;
                                      if (counter == 1) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            !sharedPrefs.doneHighlight
                                                ? Divider(
                                                    color: CustomColor.Divider,
                                                    thickness: 1,
                                                    height: 56.0,
                                                  )
                                                : Container(),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 24.0, right: 24.0),
                                              child: TextDescription(
                                                text: "Others",
                                                color: CustomColor.Grey,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 24.0, right: 24.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  showBottomEdit(context, data);
                                                },
                                                onLongPress: () {
                                                  var dataTodo = {
                                                    "id": data.id,
                                                    "description":
                                                        data['description'],
                                                    "type": "others",
                                                    "time": data['timestamp'],
                                                    "notifId":
                                                        data['notificationId'],
                                                    "timeReminder":
                                                        data["timeReminder"],
                                                  };
                                                  optionsBottomSheet(
                                                      context, dataTodo);
                                                },
                                                child: CardTodo(
                                                  id: data.id,
                                                  description:
                                                      data['description'],
                                                  time: data['timestamp'],
                                                  notifId:
                                                      data['notificationId'],
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                      }
                                      return Container(
                                        margin: EdgeInsets.only(
                                            left: 24.0, right: 24.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            showBottomEdit(context, data);
                                          },
                                          onLongPress: () {
                                            var dataTodo = {
                                              "id": data.id,
                                              "description":
                                                  data['description'],
                                              "type": "others",
                                              "time": data['timestamp'],
                                              "notifId": data['notificationId'],
                                              "timeReminder":
                                                  data["timeReminder"]
                                            };
                                            optionsBottomSheet(
                                                context, dataTodo);
                                          },
                                          child: CardTodo(
                                              id: data.id,
                                              description: data['description'],
                                              time: data['timestamp'],
                                              notifId: data['notificationId']),
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  }).toList(),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              child: Container(
                color: Color(0xFFFAFAFB),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BacklogScreen()),
                        );
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.all(24),
                        child: CustomIcon(
                          type: "menu",
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    GestureDetector(
                      // onTap: () => openScreenProfile(context),
                      onTap: () {
                        openScreenProfile(context);
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.all(24),
                        child: CustomIcon(
                          type: "profile",
                        ),
                      ),
                    )
                  ],
                ),
              ),
              left: 0,
              bottom: 0,
              right: 0,
            ),
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
