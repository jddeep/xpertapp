import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xpert/homepage.dart';
import 'package:xpert/homepage2.dart';
import 'main.dart';
import 'otpscreen.dart';
import 'rejectedPage.dart';
import 'underReview_page.dart';

import 'xpertinvitescreen.dart';

class XpertMobileLoginPage extends StatefulWidget {
  XpertMobileLoginPage();

  @override
  _XpertMobileLoginPageState createState() => _XpertMobileLoginPageState();
}

class _XpertMobileLoginPageState extends State<XpertMobileLoginPage> {
  TextEditingController _smsCodeController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  String phoneNo;
  String smsCode;
  String verificationId;

  bool isVerified = false;

    _checkIntoMaster(FirebaseUser user) async {
    print('UID: ' + user.uid);
    await Firestore.instance
        .collection('xpert_master')
        .where('auth_id', isEqualTo: user.uid)
        .getDocuments()
        .then((docsMaster) {
      print('auth id check' + docsMaster.documents.toList().toString());
      if (docsMaster.documents.length == 0) {
        /// if auth_id doesn't match with any documents
        /// in xpert_master collection then check phoneNumeber of that user.
        Firestore.instance
            .collection('xpert_master')
            .where('mobile', isEqualTo: _phoneNumberController.text)
            .getDocuments()
            .then((docsMaster) {
          print('mobilecheck' + docsMaster.documents.toList().toString());
          if (docsMaster.documents.length == 0) {
            Firestore.instance
                .collection('invite_requests')
                .where('auth_id', isEqualTo: user.uid)
                .getDocuments()
                .then((docsRequest) {
              print('invite check' + '${docsRequest.documents.length}');
              if (docsRequest.documents.length == 0) {
                //todo: maybe pushReplacement
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => XpertInviteScreen(
                            user: user,
                            phoneNumber: _phoneNumberController.text,
                          )),
                );
              } else {
                if (docsRequest.documents[0].data['status'] == 'pending' ||
                    docsRequest.documents[0].data['status'] == 'in-review') {
                  print("UnderReview Profile");
                  //todo: maybe pushReplacement
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UnderReviewPage(),
                    ),
                  );
                } else if (docsRequest.documents[0].data['status'] ==
                    'rejected') {
                  print("Rejected Profile");
                  //todo: maybe pushReplacement
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RejectedPage(),
                    ),
                  );
                }
              }
            });
          } else {
            ///auth_id doesn't match but phoneNumber matched then update authId
            ///in xpert_master collection and push the user to Home Page.
            Firestore.instance
                .collection('xpert_master')
                .document(docsMaster.documents[0].documentID)
                .updateData({
              'auth_id': user.uid,
              'mobile': '' // maybe blank the phone number here (done)
            }).whenComplete(() {
              /// todo: maybe pushRepalcement
              // Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => HomePage(user: user, title: docsMaster.documents[0].documentID,),
              //     ));
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage2(
                        userDocId: docsMaster.documents[0].documentID,
                        user: user),
                  ));
            });
          }
        });
      } else {
        /// If auth_id matched to a document then need to push the user to the
        /// Home Page.
        /// todo: maybe pushRepalcement
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => HomePage(user: user, title: docsMaster.documents[0].documentID,),
        //     ));
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage2(
                  userDocId: docsMaster.documents[0].documentID, user: user),
            ));
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
      isVerified = true;
      _getVerifiedUser(user).then((_user){
        _checkIntoMaster(_user);
      });

      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => MyHomePage2(
      //               userDocId: 'jaideep-prasad',
      //               user: null,
      //             )));
    };

    final PhoneVerificationFailed veriFailed = (AuthException exception) {
      print('${exception.message}');
      print('exception on: ' + '+91' + _phoneNumberController.text);
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91' + _phoneNumberController.text,
      codeAutoRetrievalTimeout: autoRetrieve,
      codeSent: smsCodeSent,
      timeout: const Duration(seconds: 120),
      verificationCompleted: verifiedSuccess,
      verificationFailed: veriFailed,
    );
  }

  Future<FirebaseUser> _getVerifiedUser(credential) async{
    FirebaseUser _user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    return _user;
  }

  /// Sign in using an sms code as input
  /// CALLED IN OTP SCREEN
  Future<FirebaseUser> signInWithPhoneNumber(String smsCode) async {
    print(smsCode + 'ver: ' + verificationId);
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final FirebaseUser user =
        (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    assert(user.uid == currentUser.uid);

    // _smsCodeController.text = '';
    return user;
  }

  _closeApp() async {
    await SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _closeApp();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Column(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                height: MediaQuery.of(context).size.height /
                                    2.62, //280
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          AssetImage('assets/celeb_banner.png'),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height /
                                        3.0), //310
                                child: Center(
                                  child: Container(
                                    height: 75.0, //75
                                    width: 75.0, //75
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/xpert_icon.png')),
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
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.height / 7.32,
                                left: MediaQuery.of(context).size.width / 18,
                                top: MediaQuery.of(context).size.height /
                                    122), // 100, 20, 6
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
                        ],
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
                // _checkPhone();
                verifyPhone();
                ////Move to OTP Page
                if(!isVerified)
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => new OTPScreen(
                          signInWithPhoneNumber, _phoneNumberController.text),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
