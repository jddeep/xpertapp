import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xpert/homepage.dart';
import 'package:xpert/main.dart';
import 'package:xpert/otpscreen.dart';
import 'package:xpert/rejectedPage.dart';
import 'package:xpert/underReview_page.dart';

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
  String phoneNo;
  String smsCode;
  String verificationId;

  bool _isRegisteredNo = false;

  _checkPhone() async {
    await Firestore.instance
        .collection('invite_requests')
        .where('mobile', isEqualTo: _phoneNumberController.text)
        .getDocuments()
        .then((docs) {
      if (docs.documents.length == 0) {
        print("This No is not registered before in database");
        verifyPhone().whenComplete(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPScreen(
                  cameras, signInWithPhoneNumber, -2), // Not registerd yet
            ),
          );
        });
      } else {
        if (docs.documents[0].data['status'] == 'underReview') {
          print("UnderReview Profile");
          verifyPhone();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => OTPScreen(
                    cameras, signInWithPhoneNumber, 0), //UnderReview Profile
              ));
        } else if (docs.documents[0].data['status'] == 'rejected') {
          print("Rejected Profile");
          verifyPhone();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OTPScreen(
                  cameras, signInWithPhoneNumber, -1), //Rejected Profile
            ),
          );
        } else if (docs.documents[0].data['status'] == 'accepted') {
          print("Accepted profile");
          verifyPhone();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OTPScreen(
                  cameras, signInWithPhoneNumber, 1), //Accepted Profile
            ),
          );
        }
      }
    });
  }

  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
      print('autotimeout ' + '+91' + _phoneNumberController.text);
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      print('sms code sent: ' + '+91' + _phoneNumberController.text);
      // smsCodeDialog(context).then((value) {
      //   print('Signed in');
      // });
    };

    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential user) {
      print('verified');
      // FirebaseAuth.instance.signInWithCredential(user).then((authResult) async {
      //   if (authResult.additionalUserInfo.profile.isNotEmpty) {

      //   }
      // });
    };

    final PhoneVerificationFailed veriFailed = (AuthException exception) {
      print('${exception.message}');
      print('exception on: ' + '+91' + _phoneNumberController.text);
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91' + _phoneNumberController.text,
      codeAutoRetrievalTimeout: autoRetrieve,
      codeSent: smsCodeSent,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verifiedSuccess,
      verificationFailed: veriFailed,
    );
  }

  /// Sign in using an sms code as input
  /// CALLED IN OTP SCREEN
  Future<FirebaseUser> signInWithPhoneNumber(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final FirebaseUser user =
        (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    assert(user.uid == currentUser.uid);

    _smsCodeController.text = '';
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
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
                        fit: BoxFit.cover),
                  ),
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
            // Expanded(
            //   child:
            Padding(
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
            // ),
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
                _checkPhone();
                // verifyPhone();
                ////Move to OTP Page
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) =>
                //           new OTPScreen(widget.cameras, signInWithPhoneNumber,),
                //     ));
              },
            ),
          ],
        ),
      ),
    );
  }
}