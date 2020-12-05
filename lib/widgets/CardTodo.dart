import 'package:flutter/material.dart';
import 'Text.dart';
import '../helpers/color.dart';
import 'package:closa_flutter/widgets/CustomIcon.dart';
import 'package:closa_flutter/helpers/FormatTime.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class CardTodo extends StatefulWidget {
  final String description;
  final int time;
  final String id;
  const CardTodo({Key key, this.id, this.description, this.time})
      : super(key: key);
  @override
  _CardTodoState createState() => _CardTodoState();
}

class _CardTodoState extends State<CardTodo> {
  bool state = false;
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
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
              state
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
                          state = !state;
                          Timer(Duration(seconds: 1), () {
                            firestoreInstance
                                .collection("todos")
                                .doc(widget.id)
                                .update({"status": true});
                            state = !state;
                          });
                        });
                      },
                      child: Container(
                        width: 24.0,
                        height: 24.0,
                        margin: EdgeInsets.only(right: 4.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9.0),
                            border: Border.all(
                                color: Color(0xFFDDDDDD), width: 2.0)),
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
      ),
    );
  }
}
