import 'package:closa_flutter/widgets/CustomIcon.dart';
import 'package:closa_flutter/widgets/Text.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0),
              child: Row(
                children: [
                  CustomIcon(
                    type: "streak",
                  ),
                  SizedBox(
                    width: 6.0,
                  ),
                  TextDescription(
                    text: "37",
                    fontWeight: FontWeight.w600,
                  ),
                  Expanded(child: Container()),
                  CustomIcon(
                    type: "more",
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        top: 6.0, bottom: 6.0, right: 12.0, left: 12.0),
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 1.0, color: Color(0xFFDDDDDD)),
                        borderRadius: BorderRadius.circular(14.0)),
                    child: Icon(Icons.close),
                  ) 
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Center(
              child: Container(
                width: 64.0,
                height: 64.0,
                decoration: BoxDecoration(
                    border: Border.all(width: 5.0, color: Color(0xFFEFEFEF)),
                    borderRadius: BorderRadius.circular(21.0)),
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            Center(
              child: TextDescription(
                  text: "Aprianil Sesti Rangga", fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 6.0,
            ),
            Center(child: TextDescription(text: "@apri")),
            SizedBox(
              height: 16.0,
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(left: 24.0, right: 24.0),
                child: TextDescription(
                  text:
                      "A Product & Community Enthusiast. Interested in philosophy, consumer tech, Interpersonal Relationship, & 1 on 1 talk.",
                  align: TextAlign.justify,
                ),
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Divider(
              thickness: 1.0,
              color: Color(0xFFE5E5E5),
            ),
            SizedBox(
              height: 24.0,
            ),
            Container(
              child: TextDescription(text: "224 Completed Task"),
              margin: EdgeInsets.only(left: 24.0),
            ),
            SizedBox(
              height: 24.0,
            ),
            Divider(
              thickness: 8.0,
              color: Color(0xFFEFEFEF),
            ),
            Container(
              margin: EdgeInsets.only(left: 24.0, right: 24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextDescription(text: "Nov\n23"),
                  SizedBox(
                    width: 24.0,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            TextDescription(text: "@apri"),
                            SizedBox(
                              width: 8.0,
                            ),
                            CustomIcon(
                              type: "streak",
                              color: Color(0xFF888888),
                            ),
                            SizedBox(
                              width: 3.0,
                            ),
                            TextDescription(
                              text: "37",
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF888888),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomIcon(
                              type: 'check',
                              color: Color(0xFF40B063),
                            ),
                            TextDescription(
                              text:
                                  "Continue Design & Prototype Personal To-do App",
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomIcon(
                              type: 'check',
                              color: Color(0xFF40B063),
                            ),
                            TextDescription(
                              text:
                                  "Continue Design & Prototype Personal To-do App",
                            )
                          ],
                        )
                      ]),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
