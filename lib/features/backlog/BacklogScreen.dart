import 'dart:async';
import 'package:closa_flutter/core/utils/local_notification.dart';
import 'package:closa_flutter/features/home/TaskScreen.dart';
import 'package:closa_flutter/helpers/FormatTime.dart';
import 'package:closa_flutter/helpers/sharedPref.dart';
import 'package:closa_flutter/widgets/BottomSheetEdit.dart';
import 'package:closa_flutter/widgets/CardBacklog.dart';
import 'package:closa_flutter/widgets/CustomIcon.dart';
import 'package:closa_flutter/widgets/OptionsBacklog.dart';
import 'package:closa_flutter/widgets/Text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class BacklogScreen extends StatefulWidget {
  @override
  _BacklogScreenState createState() => _BacklogScreenState();
}

class _BacklogScreenState extends State<BacklogScreen> {
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
              isBacklog: true,
              id: data.id,
              type: data["type"],
              description: data['description'],
              time: data['timestamp'],
              timeReminder: data["timeReminder"],
              notifId: data['notificationId'],
            ));
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
        builder: (_) => OptionsBacklog(
            id: data["id"],
            description: data["description"],
            type: data["type"],
            time: data["time"],
            timeReminder: data["timeReminder"],
            notifId: data['notifId']));
  }

  void addTodo(id, timestamp, description, notifId) {
    setState(() {
      todos[id] = {
        "time": timestamp,
        "description": description,
        "notifId": notifId
      };
    });
  }

  void setToday() {
    setState(() {
      clickedStart = true;
    });
    var tenMinutes = 600000;
    final firestoreInstance = FirebaseFirestore.instance;
    todos.forEach((key, value) {
      LocalNotification().changeTimeNotification(
        value['notifId'],
        value['description'],
        FormatTime.setToday(value['time']) - tenMinutes,
      );
      firestoreInstance.collection("todos").doc(key).update({
        "timestamp": FormatTime.setToday(value['time']),
      });
    });
    FToast fToast = FToast();
    fToast.init(context);
    fToast.showToast(
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xFF888888),
              borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 8.0, bottom: 8, left: 22, right: 22),
            child: TextSmall(
              text:
                  "Added ${todos.length} ${todos.length == 1 ? 'Task' : 'Tasks'}",
              color: Colors.white,
            ),
          ),
        ),
        toastDuration: Duration(seconds: 3),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: child,
            bottom: 96.0,
            left: 0,
            right: 0,
          );
        });

    Get.offAll(TaskScreen());
  }

  void deleteTodo(id) {
    setState(() {
      todos.remove(id);
    });
  }

  var todos = new Map();
  Stream<QuerySnapshot> getTodo() {
    return FirebaseFirestore.instance
        .collection('todos')
        .orderBy("timestamp")
        .where("timestamp", isGreaterThan: FormatTime.getTimestampYesterday())
        .where('userId', isEqualTo: sharedPrefs.idUser)
        .where('status', isEqualTo: false)
        .snapshots();
  }

  bool clickedStart = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF6F8FA),
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin:
                            EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 16, right: 16, top: 8, bottom: 8),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF6F8FA),
                                  border: Border.all(
                                      width: 2, color: Color(0xFFDDDDDD)),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: CustomIcon(
                                  type: "close",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 16, left: 24),
                          child: TextHeader(text: "Backlog")),
                      SizedBox(
                        height: 24.0,
                      ),
                      Divider(
                        thickness: 1.0,
                        color: Color(0xFFE5E5E5),
                      ),
                    ],
                  )),
              Positioned(
                top: 140,
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height - 220,
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
                                return Column(
                                  children: [
                                    Expanded(child: Container()),
                                    CustomIcon(
                                      type: "emptyBacklog",
                                    ),
                                    Expanded(child: Container()),
                                    TextDescription(
                                      text: "No backlog leads to peace of mind",
                                      color: Color(0xFF888888),
                                    )
                                  ],
                                );
                              }
                              var date = "";
                              var total = 0;
                              snapshot.data.docs.forEach((data) {
                                if (FormatTime.getDate(
                                        FormatTime.getTimestampToday()) !=
                                    FormatTime.getDate(data['timestamp'])) {
                                  total++;
                                }
                              });

                              if (total == 0) {
                                return Column(
                                  children: [
                                    Expanded(child: Container()),
                                    CustomIcon(
                                      type: "emptyBacklog",
                                    ),
                                    Expanded(child: Container()),
                                    TextDescription(
                                      text: "No backlog leads to peace of mind",
                                      color: Color(0xFF888888),
                                    )
                                  ],
                                );
                              } else {
                                return Container(
                                  margin: EdgeInsets.only(bottom: 120),
                                  child: Column(
                                    children: snapshot.data.docs.map((data) {
                                      if (FormatTime.getDate(
                                              FormatTime.getTimestampToday()) ==
                                          FormatTime.getDate(
                                              data['timestamp'])) {
                                        return Container();
                                      } else {
                                        if (date ==
                                            FormatTime.getDate(
                                                data['timestamp'])) {
                                          return GestureDetector(
                                            onTap: () =>
                                                showBottomEdit(context, data),
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
                                            child: CardBacklog(
                                              notifId: data['notificationId'],
                                              deleteTodo: deleteTodo,
                                              addTodo: addTodo,
                                              id: data.id,
                                              isFirst: false,
                                              type: data['type'],
                                              description: data['description'],
                                              time: data['timestamp'],
                                            ),
                                          );
                                        } else {
                                          date = FormatTime.getDate(
                                              data['timestamp']);
                                          return GestureDetector(
                                            onTap: () =>
                                                showBottomEdit(context, data),
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
                                            child: CardBacklog(
                                              notifId: data['notificationId'],
                                              deleteTodo: deleteTodo,
                                              addTodo: addTodo,
                                              id: data.id,
                                              isFirst: true,
                                              type: data['type'],
                                              description: data['description'],
                                              time: data['timestamp'],
                                            ),
                                          );
                                        }
                                      }
                                    }).toList(),
                                  ),
                                );
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: todos.length == 0
                      ? Container()
                      : Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(24.0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextContent(
                                    fontWeight: FontWeight.w600,
                                    text:
                                        "${todos.length} ${todos.length == 1 ? 'Task' : 'Tasks'}",
                                  ),
                                  TextDescription(
                                    text: "Set to today",
                                    color: Color(0xFF888888),
                                  )
                                ],
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              GestureDetector(
                                onTap: () => setToday(),
                                child: Container(
                                    padding: EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 20,
                                        right: 20),
                                    decoration: BoxDecoration(
                                        color: clickedStart
                                            ? Color(0xFF4D4D4D)
                                            : Color(0xFF222222),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: TextDescription(
                                      text: "Start",
                                      color: Colors.white,
                                    )),
                              )
                            ],
                          ),
                        ))
            ],
          ),
        ));
  }
}
