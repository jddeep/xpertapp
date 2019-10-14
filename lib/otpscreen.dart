import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:xpert/homepage.dart';
import 'package:xpert/rejectedPage.dart';
import 'package:xpert/underReview_page.dart';
import 'package:xpert/xpertWelcome.dart';
import 'package:xpert/xpertinvitescreen.dart';

class OTPScreen extends StatefulWidget {
  int status;
  var cameras;
  final Function signInCallback;

  OTPScreen(this.cameras, this.signInCallback, this.status);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController _controller = TextEditingController();
  var user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 350,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/celeb_banner.png'),
                          fit: BoxFit.cover)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 310.0),
                  child: Center(
                    child: Container(
                      height: 75,
                      width: 75,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/xpert_icon.png')),
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'Submit OTP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            // Expanded(
            // child:
            Padding(
              padding: const EdgeInsets.only(bottom: 100.0, top: 24),
              child: PinCodeTextField(
                autofocus: false,
                controller: _controller,
                hideCharacter: false,
                highlight: true,
                highlightColor: Colors.blue,
                defaultBorderColor: Colors.black,
                hasTextBorderColor: Colors.green,
                maxLength: 6,
                // maskCharacter: "😎",

                onTextChanged: (text) {
                  setState(() {});
                },
                onDone: (text) {
                  print("DONE $text");
                },
                pinCodeTextFieldLayoutType:
                    PinCodeTextFieldLayoutType.AUTO_ADJUST_WIDTH,
                wrapAlignment: WrapAlignment.start,
                pinBoxDecoration:
                    ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
                pinTextStyle: TextStyle(fontSize: 30.0),
                pinTextAnimatedSwitcherTransition:
                    ProvidedPinBoxTextAnimation.scalingTransition,
                pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
              ),
            ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'TAP: Agree and continue to accept ',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Xpert Terms of ',
                  style: TextStyle(color: Colors.amber),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Service ', style: TextStyle(color: Colors.amber)),
                Text(
                  'and ',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Privacy policy.',
                  style: TextStyle(color: Colors.amber),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            MaterialButton(
              minWidth: double.infinity,
              height: 60,
              color: Colors.amber,
              child: Text('Continue',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              onPressed: () {
                widget.signInCallback(_controller.text).then((_user) {
                  user = _user;
                });
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => widget.status == -1
                          ? RejectedPage()
                          : widget.status == 0
                              ? UnderReviewPage()
                              : widget.status == 1
                                  ? HomePage()
                                  : XpertInviteScreen(
                                      cameras: widget.cameras,
                                      user: user,
                                    ),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
