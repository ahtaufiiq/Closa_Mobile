import 'package:flutter/material.dart';
import 'Text.dart';
import '../helpers/color.dart';
class CardTodo extends StatefulWidget {
  final String description;
  final String time;
  const CardTodo ({ Key key, this.description,this.time }): super(key: key);
  @override
  _CardTodoState createState() => _CardTodoState();
}

class _CardTodoState extends State<CardTodo> {
  bool state = false;

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Card(
      margin: EdgeInsets.only(top:16.0, left:2.0,right: 2.0),
      shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
      elevation: 4.0,
      child: Padding(padding: EdgeInsets.all(12.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Checkbox(value: state, onChanged: (bool value) { 
              setState(() {
                state = !state;
              });
             },),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextDescription(text:widget.description??""),
                SizedBox(height: 8.0,),
                TextDescription(text:widget.time??"",color: CustomColor.Grey,)
              ],
            ),)
            
          ],
        ),
        ),
    ),);
  }
}