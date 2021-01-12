import 'package:closa_flutter/core/utils/local_notification.dart';
import 'package:closa_flutter/helpers/FormatTime.dart';
import 'package:closa_flutter/helpers/sharedPref.dart';
import 'package:closa_flutter/widgets/CustomIcon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var time = Time(6, 0, 0);
  int timestamp =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .millisecondsSinceEpoch;

  DateTime selectedDate = DateTime.now();

  signout() async {
    await FirebaseAuth.instance.signOut();
    sharedPrefs.clear();
    Get.offAllNamed("/signup");
  }

  popAndSaveSetting() {
    Get.back();
    if (sharedPrefs.notificationStatus == false) {
      LocalNotification().cancelNotification(0);
      print("aa");
    }
    print("dd");
  }

  TimeOfDay selectedTime = TimeOfDay(hour: 6, minute: 00);
  String addTime;

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
        addTime = FormatTime.formatTime(selectedTime);
        sharedPrefs.highlightTime = addTime;
        sharedPrefs.highlightHour = selectedTime.hour;
        sharedPrefs.highlightMinute = selectedTime.minute;
        print(selectedTime);
        print(FormatTime.formatForTime(selectedTime));
        LocalNotification().setDailyNotification();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => popAndSaveSetting(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, top: 24),
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.5, color: Color(0xFFDDDDDD)),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: CustomIcon(
                      type: "close",
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 16, bottom: 16),
                child: Text(
                  "Settings",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
              ),
              Container(height: 1, color: Color(0xFFDDDDDD)),
              Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  top: 24,
                ),
                child: Text(
                  "Notifications",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                ),
                child: SwitchListTile(
                  contentPadding: EdgeInsets.only(right: 24),
                  title: Text(
                    "Highlight Reminder",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  value: sharedPrefs.notificationStatus,
                  onChanged: (bool value) {
                    setState(() {
                      sharedPrefs.notificationStatus = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                ),
                child: Text(
                  "Closa will remind you to enter and schedule your daily highlight",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      color: Color(0x88888888)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 16),
                child: Container(height: 1, color: Color(0xFFDDDDDD)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 16, right: 24),
                child: Row(
                  children: [
                    CustomIcon(
                      type: "alarm-grey",
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Send Highlight Reminder every ',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(
                            text: () {
                              if (sharedPrefs.highlightTime == "")
                                return "6 AM";
                              return sharedPrefs.highlightTime;
                            }(),
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontStyle: FontStyle.normal),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    GestureDetector(
                        onTap: () => _selectTime(context),
                        child: Icon(Icons.chevron_right)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 16),
                child: Container(height: 1, color: Color(0xFFDDDDDD)),
              ),
              SizedBox(height: 24),
              Container(height: 8, color: Color(0xFFDDDDDD)),
              Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  top: 24,
                ),
                child: Text(
                  "Account",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              GestureDetector(
                onTap: () {
                  signout();
                },
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      Text('Log out',
                          style: TextStyle(color: Colors.redAccent[700])),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
