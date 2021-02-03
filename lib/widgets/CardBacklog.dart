import 'package:closa_flutter/helpers/FormatTime.dart';
import 'package:closa_flutter/helpers/color.dart';
import 'package:closa_flutter/helpers/sharedPref.dart';
import 'package:flutter/material.dart';

import 'CustomIcon.dart';
import 'Text.dart';

class CardBacklog extends StatefulWidget {
  final String description;
  final int time;
  final String type;
  final String id;
  final Function addTodo;
  final Function deleteTodo;
  final bool isFirst;
  const CardBacklog(
      {Key key,
      this.id,
      this.description,
      this.time,
      this.isFirst,
      this.type,
      this.deleteTodo,
      this.addTodo})
      : super(key: key);

  @override
  _CardBacklogState createState() => _CardBacklogState();
}

class _CardBacklogState extends State<CardBacklog> {
  bool status = false;
  bool isPendingTask(timestamp) {
    return FormatTime.getDate(FormatTime.getTimestampYesterday()) ==
        FormatTime.getDate(timestamp);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 24, right: 24, top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.isFirst
              ? Column(
                  children: [
                    SizedBox(
                      height: 24,
                    ),
                    TextDescription(
                      text: isPendingTask(widget.time)
                          ? "Pending Task"
                          : "${FormatTime.getDate2(widget.time)[1]} ${FormatTime.getDate2(widget.time)[0]}",
                      color: isPendingTask(widget.time)
                          ? Color(0xFF888888)
                          : Color(0xFF222222),
                      align: TextAlign.left,
                    ),
                  ],
                )
              : Container(),
          Container(
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
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              status = false;
                            });
                            widget.deleteTodo(widget.id);
                          },
                          child: CustomIcon(
                            type: 'selectedRadio',
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              status = true;
                            });
                            widget.addTodo(widget.id);
                          },
                          child: CustomIcon(
                            type: 'emptyRadio',
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
                        TextDescription(
                          text: FormatTime.getTime(widget.time) ?? "",
                          color: CustomColor.Grey,
                        )
                      ],
                    ),
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
