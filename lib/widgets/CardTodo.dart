import 'package:closa_flutter/core/utils/local_notification.dart';
import 'package:closa_flutter/helpers/CustomSnackbar.dart';
import 'package:closa_flutter/helpers/Network.dart';
import 'dart:convert';
import 'package:closa_flutter/helpers/sharedPref.dart';
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
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            status
                ? CustomIcon(
                    type: 'fillChecklist',
                  )
                : GestureDetector(
                    onTap: () {
                      LocalNotification().cancelNotification(widget.notifId);
                      setState(() {
                        status = true;
                      });

                      Timer(Duration(milliseconds: 700), () {
                        Network.checklistTodo(widget.id);
                        setState(() {
                          status = false;
                        });
                      });

                      CustomSnackbar.checklistTodo(context, widget);
                    },
                    child: CustomIcon(
                      type: 'emptyChecklist',
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
