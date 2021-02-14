import 'package:closa_flutter/helpers/FormatTime.dart';
import 'package:closa_flutter/helpers/color.dart';
import 'package:closa_flutter/helpers/sharedPref.dart';
import 'package:flutter/material.dart';

import 'CustomIcon.dart';
import 'Text.dart';

class CardHistoryTodo extends StatelessWidget {
  final String description;
  final int time;
  final String type;
  final String id;
  final bool isFirst;
  const CardHistoryTodo(
      {Key key, this.id, this.description, this.time, this.isFirst, this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 28, left: 24, right: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          isFirst
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextDescription(
                      text: "${FormatTime.getDate2(time)[0]}",
                      color: Color(0xFF888888),
                      align: TextAlign.left,
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    TextDescription(
                      text: "${FormatTime.getDate2(time)[1]}",
                      color: Color(0xFF888888),
                      fontWeight: FontWeight.w600,
                      align: TextAlign.left,
                    ),
                  ],
                )
              : TextDescription(
                  text: FormatTime.getDate(time),
                  color: Colors.transparent,
                ),
          SizedBox(
            width: 24.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isFirst
                    ? Column(
                        children: [
                          TextDescription(
                            text: "@${sharedPrefs.username}",
                          ),
                          SizedBox(
                            height: 13,
                          )
                        ],
                      )
                    : Container(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    type == "highlight"
                        ? Container(
                            margin: EdgeInsets.only(top: 2),
                            child: CustomIcon(
                              type: 'highlight',
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.only(top: 2),
                            child: CustomIcon(
                              type: "checklist",
                            ),
                          ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextDescription(
                            text: description,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextSmall(
                            text: FormatTime.getTime(time, history: true),
                            color: Color(0xFF888888),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
