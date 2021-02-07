import 'package:closa_flutter/core/utils/local_notification.dart';
import 'package:closa_flutter/features/backlog/BacklogScreen.dart';
import 'package:closa_flutter/helpers/sharedPref.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'CustomIcon.dart';
import 'InputText.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../helpers/FormatTime.dart';
import 'package:closa_flutter/widgets/Text.dart';

import 'OptionsTodo.dart';

class BottomSheetEdit extends StatefulWidget {
  final String description;
  final int time;
  final String id;
  final String type;
  final int notifId;
  final String timeReminder;

  const BottomSheetEdit(
      {Key key,
      this.id,
      this.description,
      this.time,
      this.type,
      this.notifId,
      this.timeReminder})
      : super(key: key);
  @override
  _BottomSheetEditState createState() => _BottomSheetEditState(
      description, DateTime.fromMillisecondsSinceEpoch(time), timeReminder);
}

class _BottomSheetEditState extends State<BottomSheetEdit> {
  String timeReminder = "";
  String description = "";
  int timestamp;
  String textTime = "";
  DateTime dateTime;
  int todoLength = 0;
  _BottomSheetEditState(this.description, this.dateTime, this.timeReminder);
  TextEditingController controller = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  int addTime = 0;
  int _groupTimes = 5;
  int _groupCustomTimes = 1;
  String _numberCustom;
  @override
  void initState() {
    super.initState();
    controller.text = description;
    selectedTime = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    textTime = FormatTime.formatTime(selectedTime);
    timestamp = DateTime(dateTime.year, dateTime.month, dateTime.day)
        .millisecondsSinceEpoch;
    addTime = FormatTime.addTime(selectedTime.hour, selectedTime.minute);
    switch (timeReminder) {
      case "30 min":
        _groupTimes = 0;
        break;
      case "10 min":
        _groupTimes = 1;
        break;
      case "1 hour":
        _groupTimes = 2;
        break;
      case "at time event":
        _groupTimes = 3;
        break;
      default:
        _groupTimes = 4;
    }
    todoLength = description.length;
    controller.addListener(_getTodoValue);
  }

  _getTodoValue() {
    setState(() {
      todoLength = controller.text.length;
    });
  }

  DateTime selectedDate = DateTime.now();

  String date = "Today";

  final firestoreInstance = FirebaseFirestore.instance;
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
        builder: (_) => OptionsTodo(
            id: data["id"],
            description: data["description"],
            type: data["type"],
            notifId: data["notifId"],
            timeReminder: data["timeReminder"],
            time: data["time"]));
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

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        timestamp = picked.millisecondsSinceEpoch;
        date = FormatTime.formatDate(selectedDate);
      });
    }
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
        textTime = FormatTime.formatTime(selectedTime);
      });
  }

  void setNotificationTime(int id) async {
    int minute, hour, days, weeks;
    DateTime time = DateTime.now();

    if (_groupTimes == 0) {
      minute = 30;
      time = new DateTime(selectedDate.year, selectedDate.month,
          selectedDate.day, selectedTime.hour, selectedTime.minute - minute);
    } else if (_groupTimes == 1) {
      minute = 10;
      time = new DateTime(selectedDate.year, selectedDate.month,
          selectedDate.day, selectedTime.hour, selectedTime.minute - minute);
    } else if (_groupTimes == 2) {
      hour = 1;
      time = new DateTime(selectedDate.year, selectedDate.month,
          selectedDate.day, selectedTime.hour - hour, selectedTime.minute);
    } else if (_groupTimes == 3)
      minute = 0;
    else if (_groupTimes == 4) {
      if (_groupCustomTimes == 0) {
        hour = int.parse(_numberCustom);
        time = new DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, selectedTime.hour - hour, selectedTime.minute);
      } else if (_groupCustomTimes == 1) {
        days = int.parse(_numberCustom);
        time = new DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day - days, selectedTime.hour, selectedTime.minute);
      } else if (_groupCustomTimes == 2) {
        weeks = int.parse(_numberCustom);
        time = new DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day - (weeks * 7),
            selectedTime.hour,
            selectedTime.minute);
      }
    }

    String message =
        '${controller.text} at ${FormatTime.getInfoTime(selectedTime.hour, selectedTime.minute)}';

    firestoreInstance
        .collection("todos")
        .doc(widget.id)
        .update({"timeReminder": timeReminder});

    await LocalNotification().cancelNotification(id);
    await LocalNotification().setNotification(message, time, id);

    // List<PendingNotificationRequest> lists2 =
    //     await LocalNotification().getAllNotification();
    // for (var item in lists2) {
    //   print(item.id);
    // }
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
                            timeReminder = '30 min';
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
                            timeReminder = '10 min';
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
                            timeReminder = '1 hour';
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
                            timeReminder = 'at time event';
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
                    if (!isNotBlankCustomNotif) {
                      print(_numberCustom);
                    } else {
                      var indicator = 'hour';
                      if (_groupCustomTimes == 0) {
                        indicator = "hour";
                      } else if (_groupCustomTimes == 1) {
                        indicator = "days";
                      } else if (_groupCustomTimes == 2) {
                        indicator = "weeks";
                      }
                      timeReminder = "$_numberCustom $indicator";
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
          InputText(
            controller: controller,
            hint: 'Eg: Read 10 page of Atomic Habits',
            focus: true,
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
                    child: TextDescription(text: textTime),
                    padding: EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 4.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    _showTimeDialog();
                  },
                  child: Container(
                    child: Row(
                      children: [
                        CustomIcon(
                          type: "bell",
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(timeReminder),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 24.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    var data = {
                      "id": widget.id,
                      "description": controller.text,
                      "type": widget.type,
                      "time": timestamp + addTime,
                      "timeReminder": widget.timeReminder,
                      "notifId": widget.notifId
                    };
                    optionsBottomSheet(context, data);
                  },
                  child: CustomIcon(
                    type: "more",
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                GestureDetector(
                  onTap: () {
                    if (todoLength != 0) {
                      print(timeReminder);
                      firestoreInstance
                          .collection("todos")
                          .doc(widget.id)
                          .update({
                        "description": controller.text,
                        "timestamp": timestamp + addTime,
                        "timeReminder": timeReminder,
                        "type": widget.type,
                        "userId": sharedPrefs.idUser
                      });

                      Navigator.pop(context);
                      isDateTomorrow();
                      setNotificationTime(widget.notifId);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: todoLength != 0 ? Colors.black : Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(22.0))),
                    child: Row(
                      children: [
                        TextDescription(
                          text: "Edit  ",
                          color: Colors.white,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 14.0,
                        )
                      ],
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
