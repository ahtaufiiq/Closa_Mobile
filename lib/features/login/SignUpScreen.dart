import 'package:closa_flutter/widgets/CustomIcon.dart';
import 'package:closa_flutter/widgets/Text.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFB),
      body: Container(
        margin:
            EdgeInsets.only(top: 108.0, left: 24.0, right: 24.0, bottom: 46.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  CustomIcon(
                    type: "logo",
                  ),
                  SizedBox(
                    width: 6.0,
                  ),
                  TextHeader(
                    text: "Closa",
                  )
                ],
              ),
            ),
            SizedBox(
              height: 22.0,
            ),
            Container(
                margin: EdgeInsets.only(left: 8.0, right: 8.0),
                child: TextContent(
                  text:
                      "A creator community where you get things done, meet interesting people and do what matters.",
                )),
            Expanded(child: Container()),
            Container(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.0),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF000000).withOpacity(0.12),
                      blurRadius: 6,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIcon(
                    type: "google",
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  TextDescription(
                    text: "SIGN UP WITH GOOGLE",
                    fontWeight: FontWeight.w600,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextDescription(
                  text: "already a member?",
                ),
                SizedBox(
                  width: 6.0,
                ),
                TextDescription(
                  text: "Sign In",
                  fontWeight: FontWeight.w800,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
