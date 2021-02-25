import 'dart:math';
import 'dart:convert';

import 'package:closa_flutter/core/utils/local_notification.dart';
import 'package:closa_flutter/features/backlog/BacklogScreen.dart';
import 'package:closa_flutter/helpers/sharedPref.dart';
import 'package:closa_flutter/widgets/CustomIcon.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import './InputText.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../helpers/FormatTime.dart';
import 'package:closa_flutter/widgets/Text.dart';
import 'package:http/http.dart' as http;

class BottomSheetAdd extends StatefulWidget {
  final String type;

  const BottomSheetAdd({Key key, this.type}) : super(key: key);
  @override
  _BottomSheetAddState createState() => _BottomSheetAddState();
}

class _BottomSheetAddState extends State<BottomSheetAdd> {
  TextEditingController todoController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  int todoLength = 0;
  TimeOfDay selectedTime = TimeOfDay(hour: 8, minute: 00);
  DateTime dateNow = DateTime.now();
  String time;
  String timeReminder = "10 min";
  @override
  void initState() {
    super.initState();
    if (dateNow.minute > 15) {
      dateNow = dateNow.subtract(Duration(minutes: dateNow.minute));
      dateNow = dateNow.add(Duration(hours: 2));
    } else {
      dateNow = dateNow.subtract(Duration(minutes: dateNow.minute));
      dateNow = dateNow.add(Duration(hours: 1));
    }
    selectedTime = TimeOfDay(hour: dateNow.hour, minute: 00);
    time = FormatTime.formatTime(dateNow);
    addTime = FormatTime.addTime(selectedTime.hour, selectedTime.minute);
    todoController.addListener(_getTodoValue);
  }

  _getTodoValue() {
    setState(() {
      todoLength = todoController.text.length;
    });
  }

  void isDateTomorrow() {
    if ((timestamp + addTime) > FormatTime.getTimestampTomorrow()) {
      Flushbar flushbar;
      flushbar = Flushbar(
          margin: EdgeInsets.only(bottom: 107, left: 24, right: 24),
          duration: Duration(seconds: 3),
          borderRadius: 4.0,
          icon: CustomIcon(
            type: "arrowUpRight",
          ),
          mainButton: FlatButton(
            onPressed: () {
              Get.to(BacklogScreen());
            },
            child: Text(
              "View",
              style: TextStyle(color: Colors.amber),
            ),
          ), // <bool> is the type of the result passed to dismiss() and collected by show().then((result){})
          message: "Moved to Backlog");

      flushbar
        ..onStatusChanged = (FlushbarStatus status) async {
          switch (status) {
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
                break;
              }
          }
        }
        ..show(context);
    }
  }

  int timestamp =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .millisecondsSinceEpoch;
  int addTime = 0;
  String date = "Today";
  final firestoreInstance = FirebaseFirestore.instance;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        timestamp = picked.millisecondsSinceEpoch;
        date = FormatTime.formatDate(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child,
        );
      },
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        addTime = FormatTime.addTime(selectedTime.hour, selectedTime.minute);
        time = FormatTime.formatTime(selectedTime);
      });
  }

  int _groupTimes = 1;
  int _groupCustomTimes = 0;
  String _numberCustom;

  void setNotificationTime(int id) async {
    int minute, hour, days, weeks;
    DateTime timeAlarm = DateTime.now();

    if (_groupTimes == 0) {
      minute = 30;
      timeAlarm = new DateTime(selectedDate.year, selectedDate.month,
          selectedDate.day, selectedTime.hour, selectedTime.minute - minute);
    } else if (_groupTimes == 1) {
      minute = 10;
      timeAlarm = new DateTime(selectedDate.year, selectedDate.month,
          selectedDate.day, selectedTime.hour, selectedTime.minute - minute);
    } else if (_groupTimes == 2) {
      hour = 1;
      timeAlarm = new DateTime(selectedDate.year, selectedDate.month,
          selectedDate.day, selectedTime.hour - hour, selectedTime.minute);
    } else if (_groupTimes == 3)
      minute = 0;
    else if (_groupTimes == 4) {
      if (_groupCustomTimes == 0) {
        hour = int.parse(_numberCustom);
        timeAlarm = new DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, selectedTime.hour - hour, selectedTime.minute);
      } else if (_groupCustomTimes == 1) {
        days = int.parse(_numberCustom);
        timeAlarm = new DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day - days, selectedTime.hour, selectedTime.minute);
      } else if (_groupCustomTimes == 2) {
        weeks = int.parse(_numberCustom);
        timeAlarm = new DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day - (weeks * 7),
            selectedTime.hour,
            selectedTime.minute);
      }
    }

    String message =
        '${todoController.text} at ${FormatTime.getInfoTime(selectedTime.hour, selectedTime.minute)}';
    await LocalNotification().setNotification(message, timeAlarm, id);
  }

  Future<void> _showTimeDialog() async {
    return showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notification'),
          contentPadding: EdgeInsets.all(4),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    ListTile(
                      title: const Text('30 minutes before'),
                      leading: Radio(
                        activeColor: Colors.black,
                        value: 0,
                        groupValue: _groupTimes,
                        onChanged: (int value) {
                          setState(() {
                            _groupTimes = value;
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('10 minutes before'),
                      leading: Radio(
                        activeColor: Colors.black,
                        value: 1,
                        groupValue: _groupTimes,
                        onChanged: (int value) {
                          setState(() {
                            _groupTimes = value;
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('1 hour before'),
                      leading: Radio(
                        activeColor: Colors.black,
                        value: 2,
                        groupValue: _groupTimes,
                        onChanged: (int value) {
                          setState(() {
                            _groupTimes = value;
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('At the time of event'),
                      leading: Radio(
                        activeColor: Colors.black,
                        value: 3,
                        groupValue: _groupTimes,
                        onChanged: (int value) {
                          setState(() {
                            _groupTimes = value;
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Custom'),
                      leading: Radio(
                        activeColor: Colors.black,
                        value: 4,
                        groupValue: _groupTimes,
                        onChanged: (int value) {
                          setState(() {
                            _groupTimes = value;
                          });
                          Navigator.of(context).pop();
                          _showCustomTimeDialog();
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // actions: <Widget>[
          //   TextButton(
          //     child: Text('Done'),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          // ],
        );
      },
    );
  }

  Future<void> _showCustomTimeDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        bool isNotBlankCustomNotif = false;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text("Custom Notification"),
            contentPadding: EdgeInsets.all(4),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextField(
                      onChanged: (val) {
                        if (val == "0" || val == "") {
                          print("Error");
                          setState(() {
                            isNotBlankCustomNotif = false;
                            _numberCustom = val;
                          });
                        } else {
                          print("Masuk bisa");
                          setState(() {
                            isNotBlankCustomNotif = true;
                            _numberCustom = val;
                          });
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: new UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.red)),
                          hintText: 'Enter a number'),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(5),
                    title: const Text('Hours'),
                    leading: Radio(
                      activeColor: Colors.black,
                      value: 0,
                      groupValue: _groupCustomTimes,
                      onChanged: (int value) {
                        setState(() {
                          _groupCustomTimes = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Days'),
                    contentPadding: EdgeInsets.all(5),
                    leading: Radio(
                      activeColor: Colors.black,
                      value: 1,
                      groupValue: _groupCustomTimes,
                      onChanged: (int value) {
                        setState(() {
                          _groupCustomTimes = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Week'),
                    contentPadding: EdgeInsets.all(5),
                    leading: Radio(
                      activeColor: Colors.black,
                      value: 2,
                      groupValue: _groupCustomTimes,
                      onChanged: (int value) {
                        setState(() {
                          _groupCustomTimes = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: isNotBlankCustomNotif
                    ? Text('Done', style: TextStyle(color: Colors.black))
                    : Text('Done', style: TextStyle(color: Colors.grey)),
                onPressed: () {
                  setState(() {
                    if (_numberCustom.isBlank || !isNotBlankCustomNotif) {
                      print(_numberCustom);
                    } else {
                      Navigator.of(context).pop();
                    }
                    print(_numberCustom);
                  });
                },
              )
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        children: [
          SizedBox(
            height: 12.0,
          ),
          Container(
            margin: EdgeInsets.only(left: 24.0, right: 24.0),
            child: TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: todoController,
                onSubmitted: (value) {
                  int id = DateTime.now().millisecondsSinceEpoch % 100000000;

                  if (todoLength != 0) {
                    firestoreInstance.collection("todos").add({
                      "description": todoController.text,
                      "status": false,
                      "timestamp": timestamp + addTime,
                      "notificationId": id,
                      "timeReminder": timeReminder,
                      "type":
                          widget.type == "highlight" ? 'highlight' : 'others',
                      "userId": sharedPrefs.idUser
                    }).then((value) {
                      print(value.id);
                      if (widget.type == "highlight") {
                        http.post(
                          "https://api.closa.me/integrations/highlight",
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                            'accessToken':
                                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHAiOiJjbG9zYSIsImlhdCI6MTYwMjE5MDQ3NH0.1d6Z6e4r7QpzRZtGtQ_iDFsg1uPto1N8wgKJ27StAVQ"
                          },
                          body: jsonEncode(<String, String>{
                            'username': "${sharedPrefs.username}",
                            'name': "${sharedPrefs.name}",
                            'text': "${todoController.text}",
                            'photo': "${sharedPrefs.photo}",
                            'type': "setHighlight"
                          }),
                        );
                      }
                    });
                    setNotificationTime(id);
                    todoLength = 0;
                    todoController.text = "";
                  }
                },
                autofocus: true,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Inter"),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'e.g. Read 10 page of Atomic Habits',
                    hintStyle: TextStyle(color: Color(0xFFCCCCCC)))),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 4.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFCCCCCC), width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(22.0))),
                    child: TextDescription(text: date),
                    padding: EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
                  ),
                ),
                SizedBox(width: 8.0),
                GestureDetector(
                  onTap: () {
                    _selectTime(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFCCCCCC), width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(22.0))),
                    child: TextDescription(text: time),
                    padding: EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 4.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    _showTimeDialog();
                  },
                  child: Wrap(
                    children: [
                      CustomIcon(type: 'bell'),
                      SizedBox(width: 8),
                      Text((() {
                        switch (_groupTimes) {
                          case 0:
                            timeReminder = "30 min";
                            return "30 min";
                          case 1:
                            timeReminder = "10 min";
                            return "10 min";
                          case 2:
                            timeReminder = "1 hour";
                            return "1 hour";
                          case 3:
                            return "at time event";
                          case 4:
                            String a;
                            if (_groupCustomTimes == 0) {
                              a = "hour";
                            } else if (_groupCustomTimes == 1) {
                              a = "days";
                            } else if (_groupCustomTimes == 2) {
                              a = "weeks";
                            }
                            if (_numberCustom != null) {
                              timeReminder = "$_numberCustom $a";
                              return "$_numberCustom $a";
                            } else {
                              return timeReminder;
                            }
                        }
                      }())),
                    ],
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.center,
                  ),
                ),
                Expanded(child: Container()),
                GestureDetector(
                  onTap: () {
                    int id = DateTime.now().millisecondsSinceEpoch % 100000000;

                    if (todoLength != 0) {
                      firestoreInstance.collection("todos").add({
                        "description": todoController.text,
                        "status": false,
                        "timestamp": timestamp + addTime,
                        "notificationId": id,
                        "timeReminder": timeReminder,
                        "type":
                            widget.type == "highlight" ? 'highlight' : 'others',
                        "userId": sharedPrefs.idUser
                      }).then((value) {
                        print(value.id);
                        if (widget.type == "highlight") {
                          http.post(
                            "https://api.closa.me/integrations/highlight",
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                              'accessToken':
                                  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHAiOiJjbG9zYSIsImlhdCI6MTYwMjE5MDQ3NH0.1d6Z6e4r7QpzRZtGtQ_iDFsg1uPto1N8wgKJ27StAVQ"
                            },
                            body: jsonEncode(<String, String>{
                              'username': "${sharedPrefs.username}",
                              'name': "${sharedPrefs.name}",
                              'text': "${todoController.text}",
                              'photo': "${sharedPrefs.photo}",
                              'type': "setHighlight"
                            }),
                          );
                        }
                      });
                      Navigator.pop(context);
                      isDateTomorrow();
                      setNotificationTime(id);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: todoLength != 0 ? Colors.black : Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(22.0))),
                    child: TextDescription(
                      text: "Add ↑",
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.0),
        ],
      ),
    ));
  }
}
