import 'package:closa_flutter/helpers/sharedPref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotification {
  const LocalNotification();

  FlutterLocalNotificationsPlugin get notifConfig => localNotifInit();

  tz.Location get location => tz.getLocation('Asia/Jakarta');

  FlutterLocalNotificationsPlugin localNotifInit() {
    // final String currentTimeZone =
    //     await FlutterNativeTimezone.getLocalTimezone();
    final currenTime = DateTime.now().timeZoneName;

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('launch_background');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    return flutterLocalNotificationsPlugin;
  }

  Future setNotification(String message, DateTime time, int id) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        notifConfig;

    // DateTime time = DateTime.now();
    // time = new DateTime(time.year, time.month, time.day, hour, minutes);
    // DateTime time = DateTime.utc(2021, 1, 1, 17, 41, 00);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Closa',
      '⏰ $message',
      tz.TZDateTime.from(time, tz.getLocation('Asia/Jakarta'))
          .add(const Duration(seconds: 5)),
      const NotificationDetails(
          android: AndroidNotificationDetails('your channel id',
              'your channel name', 'your channel description',
              enableVibration: true)),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: null,
    );
  }

  Future getAllNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        notifConfig;

    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    return pendingNotificationRequests;
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    }
    await Get.offAllNamed("/task");
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    Get.dialog(
      CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              await Get.offAllNamed("/task");
            },
          )
        ],
      ),
    );
  }

  Future setDailyNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        notifConfig;
    var time = Time(sharedPrefs.highlightHour, sharedPrefs.highlightMinute, 0);

    await flutterLocalNotificationsPlugin.showDailyAtTime(
      0,
      'Closa',
      '☀ Set your highlight today, do what matters.',
      // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      time,
      const NotificationDetails(
          android: AndroidNotificationDetails('your channel id',
              'your channel name', 'your channel description',
              enableVibration: true)),
    );
  }

  Future cancelNotification(int id) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        notifConfig;
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
