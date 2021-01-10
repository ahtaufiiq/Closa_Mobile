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
  final void check;
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
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            status
                ? Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Color(0xFFC9FFD7),
                        borderRadius: BorderRadius.circular(9.0),
                        border:
                            Border.all(color: Color(0xFF40B063), width: 2.0)),
                    child: CustomIcon(
                      type: 'check',
                      color: Color(0xFF40B063),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        status = true;
                      });
                      Flushbar flushbar;
                      flushbar = Flushbar(
                          margin:
                              EdgeInsets.only(bottom: 107, left: 24, right: 24),
                          duration: Duration(seconds: 3),
                          borderRadius: 4.0,
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
                          message: "Delete Todo");

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
                                if (isDelete) {
                                  Timer(Duration(seconds: 1), () {
                                    firestoreInstance
                                        .collection("todos")
                                        .doc(widget.id)
                                        .update({"status": true});
                                    status = false;
                                    LocalNotification().cancelNotification(widget.notifId);
                                    http.post(
                                      "https://api.closa.me/integrations/done",
                                      headers: <String, String>{
                                        'Content-Type':
                                            'application/json; charset=UTF-8',
                                        'accessToken':
                                            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHAiOiJjbG9zYSIsImlhdCI6MTYwMjE5MDQ3NH0.1d6Z6e4r7QpzRZtGtQ_iDFsg1uPto1N8wgKJ27StAVQ"
                                      },
                                      body: jsonEncode(<String, String>{
                                        'username': "${sharedPrefs.username}",
                                        'name': "${sharedPrefs.name}",
                                        'text': "${widget.description}",
                                        'photo': "${sharedPrefs.photo}",
                                        'type':
                                            "${widget.type == "highlight" ? 'doneHighlight' : 'done'}"
                                      }),
                                    );
                                  });
                                } else {
                                  setState(() {
                                    status = false;
                                  });
                                  isDelete = true;
                                }
                                break;
                              }
                            case FlushbarStatus.DISMISSED:
                              {
                                break;
                              }
                          }
                        }
                        ..show(context);
                    },
                    child: Container(
                      width: 24.0,
                      height: 24.0,
                      margin: EdgeInsets.only(right: 4.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9.0),
                          border:
                              Border.all(color: Color(0xFFDDDDDD), width: 2.0)),
                    ),
                  ),
            SizedBox(
              width: 12.0,
            ),
            Expanded(
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
            )
          ],
        ),
      ),
    );
  }
}
