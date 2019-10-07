import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:xpert/xpertinvitescreen.dart';

class OTPScreen extends StatefulWidget {
  var cameras;

  OTPScreen(this.cameras);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100.0, top: 24),
              child: PinCodeTextField(
                autofocus: false,
                controller: _controller,
                hideCharacter: false,
                highlight: true,
                highlightColor: Colors.blue,
                defaultBorderColor: Colors.black,
                hasTextBorderColor: Colors.green,
                maxLength: 5,
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
          ),
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
              // Move to OTP Page
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => new XpertInviteScreen(widget.cameras),
                  ));
            },
          ),
        ],
      ),
      // Stack(
      //   children: <Widget>[
      //     Container(
      //       height: 320,
      //       decoration: BoxDecoration(
      //           image: DecorationImage(
      //               image: AssetImage('assets/celeb_banner.png'),
      //               fit: BoxFit.cover)),
      //     ),
      //     Center(
      //       child: Padding(
      //         padding: const EdgeInsets.only(bottom: 90),
      //         child: Container(
      //           height: 75,
      //           width: 75,
      //           decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(10),
      //               color: Colors.amber),
      //         ),
      //       ),
      //     ),
      //     Positioned(
      //       top: 380,
      //       left: 115,
      //       child: Text(
      //         'Submit OTP',
      //         style: TextStyle(
      //           color: Colors.white,
      //           fontSize: 24,
      //         ),
      //       ),
      //     ),
      //     Positioned(
      //       top: 450,
      //       left: 10,
      //       child: PinCodeTextField(
      //         autofocus: false,
      //         controller: _controller,
      //         hideCharacter: false,
      //         highlight: true,
      //         highlightColor: Colors.blue,
      //         defaultBorderColor: Colors.black,
      //         hasTextBorderColor: Colors.green,
      //         maxLength: 5,
      //         // maskCharacter: "😎",

      //         onTextChanged: (text) {
      //           setState(() {});
      //         },
      //         onDone: (text) {
      //           print("DONE $text");
      //         },
      //         pinCodeTextFieldLayoutType:
      //             PinCodeTextFieldLayoutType.AUTO_ADJUST_WIDTH,
      //         wrapAlignment: WrapAlignment.start,
      //         pinBoxDecoration:
      //             ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
      //         pinTextStyle: TextStyle(fontSize: 30.0),
      //         pinTextAnimatedSwitcherTransition:
      //             ProvidedPinBoxTextAnimation.scalingTransition,
      //         pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
      //       ),
      //     ),
      //     Positioned(
      //       top: 635,
      //       left: 20,
      //       child: Row(
      //         children: <Widget>[
      //           Text(
      //             'TAP: Agree and continue to accept ',
      //             style: TextStyle(color: Colors.white),
      //           ),
      //           Text(
      //             'Xpert Terms of ',
      //             style: TextStyle(color: Colors.amber),
      //           ),
      //         ],
      //       ),
      //     ),
      //     Positioned(
      //       top: 650,
      //       left: 100,
      //       child: Row(
      //         children: <Widget>[
      //           Text('Service ', style: TextStyle(color: Colors.amber)),
      //           Text(
      //             'and ',
      //             style: TextStyle(color: Colors.white),
      //           ),
      //           Text(
      //             'Privacy policy.',
      //             style: TextStyle(color: Colors.amber),
      //           )
      //         ],
      //       ),
      //     ),
      //     Positioned(
      //       top: 670,
      //       child: MaterialButton(
      //         minWidth: 500,
      //         height: 60,
      //         color: Colors.amber,
      //         child: Padding(
      //             padding: EdgeInsets.only(right: 140),
      //             child: Text('Agree and Continue',
      //                 style: TextStyle(color: Colors.white, fontSize: 20))),
      //         onPressed: () {
      //           // Move to Account form Page
      //           Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (context) => XpertInviteScreen(),
      //               ));
      //         },
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}
