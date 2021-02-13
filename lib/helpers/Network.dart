import 'dart:convert';

import 'package:closa_flutter/helpers/sharedPref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class Network {
  static postSetHighlight(description) {
    print('========= set highlight');
    print('$description');
    print('=========');
    // http.post(
    //   "https://api.closa.me/integrations/highlight",
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //     'accessToken':
    //         "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHAiOiJjbG9zYSIsImlhdCI6MTYwMjE5MDQ3NH0.1d6Z6e4r7QpzRZtGtQ_iDFsg1uPto1N8wgKJ27StAVQ"
    //   },
    //   body: jsonEncode(<String, String>{
    //     'username': "${sharedPrefs.username}",
    //     'name': "${sharedPrefs.name}",
    //     'text': "${description}",
    //     'photo': "${sharedPrefs.photo}",
    //     'type': "setHighlight"
    //   }),
    // );
  }

  static postDone(description, type) {
    print('========= $type');
    print('$description');
    print('=========');
    // http.post(
    //   "https://api.closa.me/integrations/done",
    //   headers: <String, String>{
    //     'Content-Type':
    //         'application/json; charset=UTF-8',
    //     'accessToken':
    //         "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHAiOiJjbG9zYSIsImlhdCI6MTYwMjE5MDQ3NH0.1d6Z6e4r7QpzRZtGtQ_iDFsg1uPto1N8wgKJ27StAVQ"
    //   },
    //   body: jsonEncode(<String, String>{
    //     'username': "${sharedPrefs.username}",
    //     'name': "${sharedPrefs.name}",
    //     'text': "$description",
    //     'photo': "${sharedPrefs.photo}",
    //     'type':
    //         "${type == "highlight" ? 'doneHighlight' : 'done'}"
    //   }),
    // );
  }

  static undoDelete(id, timestamp) {
    FirebaseFirestore.instance
        .collection("todos")
        .doc(id)
        .update({"status": false, 'timestamp': timestamp});
  }

  static deleteTodo(id) {
    FirebaseFirestore.instance.collection("todos").doc(id).delete();
  }

  static checklistTodo(id) {
    var date = DateTime.now().millisecondsSinceEpoch;

    FirebaseFirestore.instance
        .collection("todos")
        .doc(id)
        .update({"status": true, "timestamp": date});
  }
}
