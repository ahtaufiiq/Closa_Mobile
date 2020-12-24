import 'package:closa_flutter/features/dashboard/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotification {
  const LocalNotification();

  Future localNotifInit() async {
    // final String currentTimeZone =
    //     await FlutterNativeTimezone.getLocalTimezone();

    var time = Time(5, 42, 0);

    final currenTime = await DateTime.now().timeZoneName;

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
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    await flutterLocalNotificationsPlugin.showDailyAtTime(
      0,
      'Closa',
      'Time to set your highlight',
      // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      time,
      const NotificationDetails(
          android: AndroidNotificationDetails('your channel id',
              'your channel name', 'your channel description')),
    );
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    }
    await Get.to(DashboardScreen());
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
              Get.back();
              await Get.to(DashboardScreen());
            },
          )
        ],
      ),
    );
  }
}
