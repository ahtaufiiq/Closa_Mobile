import 'package:flutter/material.dart';
import './InputText.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BottomSheetAdd extends StatefulWidget {
  @override
  _BottomSheetAddState createState() => _BottomSheetAddState();
}

class _BottomSheetAddState extends State<BottomSheetAdd> {
  TextEditingController controller = TextEditingController();
  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  String date = "Today";
  String time = "6 AM";
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
        date = formatDate(selectedDate);
      });
  }

  String formatDate(selectedDate) {
    String date = selectedDate.day.toString();
    int month = selectedDate.month;
    var listMonth = [
      '',
      'Jan',
      "Feb",
      'Mar',
      'Apr',
      "May",
      "Jun",
      "Jul",
      "Aug",
      'Sep',
      'Oct',
      "Nov",
      "Dec"
    ];
    return '$date ${listMonth[month]}';
  }

  String formatTime(selectedTime) {
    int hour = selectedTime.hour;
    int minute = selectedTime.minute;
    print(selectedTime.hour);
    print(minute);
    if (hour < 12) {
      if (minute == 0) {
        return '$hour AM';
      } else if (minute < 10) {
        return '$hour.0$minute AM';
      } else {
        return '$hour.$minute AM';
      }
    } else {
      if (minute == 0) {
        return '${hour - 12} PM';
      } else if (minute < 10) {
        return '${hour - 12}.0$minute PM';
      } else {
        return '${hour - 12}.$minute PM';
      }
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        time = formatTime(selectedTime);
      });
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
          Center(
            child: Icon(Icons.linear_scale),
          ),
          InputText(
            controller: controller,
            hint: 'e.g. Read 10 page of Atomic Habits',
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
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(22.0))),
                    child: Text(date),
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
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(22.0))),
                    child: Text(time),
                    padding: EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                GestureDetector(
                  onTap: () {
                    firestoreInstance.collection("todos").add({
                      "description": controller.text,
                      "time": time,
                      "type": 'others',
                      "userId": "andi"
                    }).then((value) {
                      print(value.id);
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(22.0))),
                    child: Row(
                      children: [
                        Text(
                          "Add  ",
                          style: TextStyle(color: Colors.white),
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
