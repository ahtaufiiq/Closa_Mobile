import 'dart:convert';

import 'package:closa_flutter/components/CustomBottomSheet.dart';
import 'package:closa_flutter/components/CustomSnackbar.dart';
import 'package:closa_flutter/core/utils/local_notification.dart';
import 'package:closa_flutter/features/backlog/BacklogScreen.dart';
import 'package:closa_flutter/helpers/FormatTime.dart';
import 'package:closa_flutter/helpers/sharedPref.dart';
import 'package:closa_flutter/model/Todo.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'BottomSheetEdit.dart';
import 'CustomIcon.dart';
import '../helpers/color.dart';
import 'Text.dart';
import 'package:http/http.dart' as http;

class OptionsBacklog extends StatefulWidget {
  final Todo todo;
  final String id;
  const OptionsBacklog({Key key, this.todo, this.id}) : super(key: key);

  @override
  _OptionsBacklogState createState() =>
      _OptionsBacklogState(todo.description, todo.timestamp);
}

class _OptionsBacklogState extends State<OptionsBacklog> {
  String description = "";
  int time;
  _OptionsBacklogState(this.description, this.time);

  @override
  void initState() {
    super.initState();
  }

  final firestoreInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            child: Container(
              padding: const EdgeInsets.only(top: 24, left: 24.0, bottom: 12),
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.transparent),
              child: Row(
                children: [
                  CustomIcon(
                    type: "iconDone",
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  TextDescription(
                    text: "Done",
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              LocalNotification()
                  .cancelNotification(widget.todo.notificationId);

              var date = DateTime.now().millisecondsSinceEpoch;

              http.post(
                "https://api.closa.me/integrations/done",
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'accessToken':
                      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHAiOiJjbG9zYSIsImlhdCI6MTYwMjE5MDQ3NH0.1d6Z6e4r7QpzRZtGtQ_iDFsg1uPto1N8wgKJ27StAVQ"
                },
                body: jsonEncode(<String, String>{
                  'username': "${sharedPrefs.username}",
                  'id': widget.id,
                  'name': "${sharedPrefs.name}",
                  'text': "$description",
                  'photo': "${sharedPrefs.photo}",
                  'type':
                      "${widget.todo.type == "highlight" ? 'doneHighlight' : 'done'}"
                }),
              );

              firestoreInstance
                  .collection("todos")
                  .doc(widget.id)
                  .update({"status": true, 'timestamp': date});
              LocalNotification()
                  .cancelNotification(widget.todo.notificationId);

              CustomSnackbar.checkDone(context, () {
                firestoreInstance.collection("todos").doc(widget.id).update(
                    {"status": false, 'timestamp': widget.todo.timestamp});
              });
            },
          ),
          GestureDetector(
            child: Container(
              padding: const EdgeInsets.only(left: 24.0, top: 12, bottom: 12),
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.transparent),
              child: Row(
                children: [
                  CustomIcon(
                    type: "edit",
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  TextDescription(text: "Edit Task"),
                ],
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              CustomBottomSheet.editTodo(context, widget.todo, widget.id);
            },
          ),
          GestureDetector(
            child: Container(
              padding: const EdgeInsets.only(left: 24.0, bottom: 28.0, top: 12),
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.transparent),
              child: Row(
                children: [
                  CustomIcon(
                    type: "trash",
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  TextDescription(
                    text: "Delete Task",
                    color: CustomColor.LightRed,
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      content: TextDescription(
                          text: 'Delete "${widget.todo.description}" ?'),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        new FlatButton(
                          textColor: Colors.black,
                          child: new Text("No"),
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                        ),
                        new FlatButton(
                          textColor: Colors.black,
                          child: new Text("Yes"),
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            firestoreInstance
                                .collection("todos")
                                .doc(widget.id)
                                .delete();
                            bool isDelete = true;

                            var notifId = widget.todo.notificationId;
                            var id = widget.id;
                            var todo = {
                              "description": widget.todo.description,
                              "status": false,
                              "timestamp": widget.todo.timestamp,
                              "notificationId": widget.todo.notificationId,
                              "timeReminder": widget.todo.timeReminder,
                              "type": widget.todo.type,
                              "userId": sharedPrefs.idUser
                            };
                            LocalNotification().cancelNotification(notifId);
                            CustomSnackbar.deleteTodo(context, () {
                              firestoreInstance.collection("todos").add(todo);
                            });
                          },
                        ),
                      ],
                    );
                  });
            },
          )
        ],
      ),
    ));
  }
}
