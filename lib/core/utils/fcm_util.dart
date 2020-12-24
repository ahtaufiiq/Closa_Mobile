import 'package:closa_flutter/core/storage/device_token.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FCMConfigure {
  const FCMConfigure();

  Future setupFCM() async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    final token = await firebaseMessaging.getToken();
    DeviceToken.setup(token);

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        // showDialog(
        //     context: context,
        //     builder: (context) => AlertDialog(
        //             content: ListTile(
        //             title: Text(message['notification']['title']),
        //             subtitle: Text(message['notification']['body']),
        //             ),
        //             actions: <Widget>[
        //             FlatButton(
        //                 child: Text('Ok'),
        //                 onPressed: () => Navigator.of(context).pop(),
        //             ),
        //         ],
        //     ),
        // );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      // onBackgroundMessage: (Map<String, dynamic> message) async {
      //   print("onLaunch: $message");
      //   // TODO optional
      // },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );

    print("klarr");
  }
}
