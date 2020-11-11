import 'package:flutter/material.dart';
import '../../widgets/Text.dart';
import '../../widgets/CardTodo.dart';
import '../../helpers/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 16.0, left: 24.0, right: 24.0),
            child: TextHeader(text: "2 November 2020"),
          ),
          Container(
            margin: EdgeInsets.only(left: 24.0, right: 24.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.list,
                  color: Colors.grey,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4.0),
                ),
                TextSectionDivider(
                  text: "Highlight",
                  color: CustomColor.Grey,
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 24.0, right: 24.0),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('todos')
                    .where('userId', isEqualTo: "andi")
                    .where('type', isEqualTo: 'highlight')
                    .limit(1)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text("loading"),
                    );
                  }
                  if (snapshot.data.docs.length == 0) {
                    return Center(
                      child: Text("Kosong"),
                    );
                  }
                  return CardTodo(
                    description: snapshot.data.docs.last['description'],
                    time: snapshot.data.docs.last['time'],
                  );
                }),
          ),
          Divider(
            color: CustomColor.Divider,
            thickness: 1,
            height: 56.0,
          ),
          Container(
            margin: EdgeInsets.only(left: 24.0, right: 24.0),
            child: TextSectionDivider(
              text: "Others",
              color: CustomColor.Grey,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 24.0, right: 24.0),
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('todos').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text("loading"),
                    );
                  }
                  if (snapshot.data.docs.length == 0) {
                    return Center(
                      child: Text("Kosong"),
                    );
                  }
                  return Column(
                    children: snapshot.data.docs.map((data) {
                      if (data['type'] != 'highlight') {
                        return CardTodo(
                          description: data['description'],
                          time: data['time'],
                        );
                      } else {
                        return Container();
                      }
                    }).toList(),
                  );
                }),
          ),
          SizedBox(
            height: 10.0,
          )
        ],
      ),
    );
  }
}
