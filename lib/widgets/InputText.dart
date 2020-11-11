import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  const InputText({Key key, this.controller, this.hint})
      : super(
          key: key,
        );

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 24.0, right: 24.0),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 16.0),
        decoration: InputDecoration(border: InputBorder.none, hintText: hint),
      ),
    );
  }
}
