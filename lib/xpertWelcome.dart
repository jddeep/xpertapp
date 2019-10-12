import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:xpert/main.dart';
import 'package:xpert/otpscreen.dart';

import 'xpertinvitescreen.dart';

class XpertWelcomePage extends StatefulWidget {
  var cameras;
  XpertWelcomePage(this.cameras);

  @override
  _XpertWelcomePageState createState() => _XpertWelcomePageState();
}

class _XpertWelcomePageState extends State<XpertWelcomePage> {
  TextEditingController _smsCodeController = TextEditingController();
TextEditingController _phoneNumberController = TextEditingController();

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
            'Welcome to Xpert',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100.0, left: 20, top: 6),
              child: Row(
                children: <Widget>[
                  new CountryCodePicker(
                    onChanged: print,
                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                    initialSelection: '+91',
                    favorite: ['+91', 'IN'],
                    // optional. Shows only country name and flag
                    showCountryOnly: false,
                    // optional. Shows only country name and flag when popup is closed.
                    //  showOnlyCountryCodeWhenClosed: false,
                    // optional. aligns the flag and the Text left
                    alignLeft: false,
                  ),
                  Container(
                    width: 200,
                    child: TextField(
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                        hintText: 'Enter your phone number',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      onChanged: print,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 5),
            child: Row(
              children: <Widget>[
                Text(
                  'Looking to follow Xperts? ',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Download our User App.',
                  style: TextStyle(color: Colors.amber),
                )
              ],
            ),
          ),
          MaterialButton(
            minWidth: double.infinity,
            height: 60,
            color: Colors.amber,
            child: Text('Continue',
                style: TextStyle(color: Colors.white, fontSize: 20)),
            onPressed: () {
//             verifyPhone();
              // Move to OTP Page
               Navigator.push(
                   context,
                   MaterialPageRoute(
                     builder: (context) => new OTPScreen(widget.cameras,null),
                   ));
            },
          ),
        ],
      ),
    );
  }
}
