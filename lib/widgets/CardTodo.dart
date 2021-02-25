import 'package:closa_flutter/core/utils/local_notification.dart';
import 'dart:convert';
import 'package:closa_flutter/helpers/sharedPref.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'Text.dart';
import '../helpers/color.dart';
import 'package:closa_flutter/widgets/CustomIcon.dart';
import 'package:closa_flutter/helpers/FormatTime.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class CardTodo extends StatefulWidget {
  final String description;
  final int time;
  final String id;
  final String type;
  final bool status;
  final VoidCallback check;
  final int notifId;

  const CardTodo(
      {Key key,
      this.id,
      this.description,
      this.time,
      this.notifId,
      this.status = false,
      this.type = "default",
      this.check})
      : super(key: key);

  @override
  _CardTodoState createState() => _CardTodoState();
}

class _CardTodoState extends State<CardTodo> {
  final firestoreInstance = FirebaseFirestore.instance;
  bool status = false;
  bool isDelete = true;

  _CardTodoState();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.0, left: 2.0, right: 2.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000).withOpacity(0.12),
            blurRadius: 6,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          status
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CustomIcon(
                    type: 'fillChecklist',
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    LocalNotification().cancelNotification(widget.notifId);
                    setState(() {
                      status = true;
                    });
                    var description = widget.description;
                    var notifId = widget.notifId;
                    var timestamp = widget.time;
                    var id = widget.id;
                    var date = DateTime.now().millisecondsSinceEpoch;
                    Flushbar flushbar;
                    Timer(Duration(milliseconds: 300), () {
                      firestoreInstance
                          .collection("todos")
                          .doc(id)
                          .update({"status": true, "timestamp": date});
                      setState(() {
                        status = false;
                      });
                    });
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
                            "${widget.type == "highlight" ? 'doneHighlight' : 'done'}"
                      }),
                    );

                    flushbar = Flushbar(
                        margin:
                            EdgeInsets.only(bottom: 107, left: 24, right: 24),
                        duration: Duration(seconds: 3),
                        borderRadius: 4.0,
                        icon: CustomIcon(type: "checkDone"),
                        mainButton: FlatButton(
                          onPressed: () {
                            isDelete = false;
                            flushbar.dismiss(true);
                          },
                          child: Text(
                            "Undo",
                            style: TextStyle(color: Colors.amber),
                          ),
                        ), // <bool> is the type of the result passed to dismiss() and collected by show().then((result){})
                        message: "Done");

                    flushbar
                      ..onStatusChanged = (FlushbarStatus flushbarStatus) {
                        switch (flushbarStatus) {
                          case FlushbarStatus.SHOWING:
                            {
                              break;
                            }
                          case FlushbarStatus.IS_APPEARING:
                            {
                              break;
                            }
                          case FlushbarStatus.IS_HIDING:
                            {
                              break;
                            }
                          case FlushbarStatus.DISMISSED:
                            {
                              if (!isDelete) {
                                firestoreInstance
                                    .collection("todos")
                                    .doc(id)
                                    .update({
                                  "status": false,
                                  'timestamp': timestamp
                                });
                              } else {
                                LocalNotification().cancelNotification(notifId);
                              }
                              break;
                            }
                        }
                      }
                      ..show(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(color: Colors.transparent),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 22),
                    child: CustomIcon(
                      type: 'emptyChecklist',
                    ),
                  ),
                ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0, top: 12, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextDescription(text: widget.description ?? ""),
                  SizedBox(
                    height: 8.0,
                  ),
                  DateTime.now().millisecondsSinceEpoch > widget.time
                      ? Row(children: [
                          CustomIcon(type: 'alarm'),
                          SizedBox(
                            width: 2.0,
                          ),
                          TextDescription(
                            text: FormatTime.getTime(widget.time) ?? "",
                            color: CustomColor.Red,
                          )
                        ])
                      : TextDescription(
                          text: FormatTime.getTime(widget.time) ?? "",
                          color: CustomColor.Grey,
                        )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
