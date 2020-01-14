import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:xpert/homepage2.dart';
import 'global.dart';
import 'homepage.dart';
import 'rejectedPage.dart';
import 'underReview_page.dart';
import 'mobile_login_page.dart';
import 'xpertinvitescreen.dart';

class OTPScreen extends StatefulWidget {
  // int status;
  final Function signInCallback;
  final Function verifyPhone;
  String phoneNumber;

  OTPScreen(this.signInCallback, this.verifyPhone, this.phoneNumber);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController _smsController = TextEditingController();
  FirebaseUser user;
  final dataBaseRef = Firestore.instance;
  bool _isLoggedIn = true; // let's assume by default user is logged in

  _checkIntoMaster(FirebaseUser user) async {
    print('UID: ' + user.uid);
    // print('EMAIL: ' + user.email);
    await dataBaseRef
        .collection('xpert_master')
        .where('auth_id', isEqualTo: user.uid)
        .getDocuments()
        .then((docsMaster) {
      print('auth id check' + docsMaster.documents.toList().toString());
      if (docsMaster.documents.length == 0) {
        /// if auth_id doesn't match with any documents
        /// in xpert_master collection then check phoneNumeber of that user.
        if(widget.phoneNumber == null || widget.phoneNumber == ''){
          widget.phoneNumber = 'no-mobile-number';
        }
        dataBaseRef
            .collection('xpert_master')
            .where('mobile', isEqualTo: widget.phoneNumber)
            .getDocuments()
            .then((docsMaster) {
          print('mobilecheck' + docsMaster.documents.toList().toString());
          if (docsMaster.documents.length == 0) {
            widget.phoneNumber = '';
            //email check
            dataBaseRef
            .collection('xpert_master')
            .where('email', isEqualTo: user.email)
            .getDocuments()
            .then((docsMaster){
               print('emailcheck' + docsMaster.documents.toList().toString());
              if(docsMaster.documents.length == 0){
                dataBaseRef
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
                            phoneNumber: widget.phoneNumber,
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
              } else{
                ///auth_id doesn't match but email matched then update authId
            ///in xpert_master collection and push the user to Home Page.
            dataBaseRef
                .collection('xpert_master')
                .document(docsMaster.documents[0].documentID)
                .updateData({
              'auth_id': user.uid,
              'email': '',
              'mobile': ''
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
            ///auth_id doesn't match but phoneNumber matched then update authId
            ///in xpert_master collection and push the user to Home Page.
            dataBaseRef
                .collection('xpert_master')
                .document(docsMaster.documents[0].documentID)
                .updateData({
              'auth_id': user.uid,
              'mobile': '',
              'email': ''
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
        print(docsMaster.documents.length.toString() + docsMaster.documents[0].documentID + user.email);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage2(
                  userDocId: docsMaster.documents[0].documentID, user: user),
            ));
      }
    });
  }

  Future<FirebaseUser> _checkCurrentUser() async {
    user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.signInCallback == null && widget.phoneNumber.isEmpty) {
      print('checking current user');
      _checkCurrentUser().then((_user) {
        print('USER UID' + '${_user.uid}' + '${_user.email}');
        _checkIntoMaster(_user);
      });
    } else {
      setState(() {
        _isLoggedIn = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    FROM_INVITE_PAGE = false;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn) {
      return Scaffold(
              body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 50.0,
                width: 50.0,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.amber,
                ),
              ),
              FROM_INVITE_PAGE?Text('Creating Your Account', style: TextStyle(fontSize: 20.0), textAlign: TextAlign.center):Container(height: 0.0,),
              FROM_INVITE_PAGE?Text('Please wait while we set up your account',
              
style: TextStyle(fontSize: 18.0),            textAlign: TextAlign.center,):Text('Please Wait...', style: TextStyle(fontSize: 18.0), textAlign: TextAlign.center,)
            ],
          ),
        ),
      );
    } else
      return Scaffold(
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
                                // height: 350,
                                height:
                                    MediaQuery.of(context).size.height / 2.62,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/celeb_banner.png'),
                                        fit: BoxFit.cover)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height /
                                        3.0), //310
                                child: Center(
                                  child: Container(
                                    height: 75, //75
                                    width: 75,
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
                            'Submit OTP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                          // Expanded(
                          // child:
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: PinCodeTextField(
                              autofocus: false,
                              controller: _smsController,
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
                              pinBoxDecoration: ProvidedPinBoxDecoration
                                  .underlinedPinBoxDecoration,
                              pinTextStyle: TextStyle(fontSize: 30.0),
                              pinTextAnimatedSwitcherTransition:
                                  ProvidedPinBoxTextAnimation.scalingTransition,
                              pinTextAnimatedSwitcherDuration:
                                  Duration(milliseconds: 300),
                            ),
                          ),
                          // ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Didn't receive OTP?",
                            style: TextStyle(color: Colors.amber)),
                        GestureDetector(
                          onTap: (){
                            widget.verifyPhone(widget.phoneNumber);
                          },
                          child: Text("Resend", style: TextStyle(color: Colors.white))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     Text(
            //       'TAP: Agree and continue to accept ',
            //       style: TextStyle(color: Colors.white),
            //     ),
            //     Text(
            //       'Xpert Terms of ',
            //       style: TextStyle(color: Colors.amber),
            //     ),
            //   ],
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     Text('Service ', style: TextStyle(color: Colors.amber)),
            //     Text(
            //       'and ',
            //       style: TextStyle(color: Colors.white),
            //     ),
            //     Text(
            //       'Privacy policy.',
            //       style: TextStyle(color: Colors.amber),
            //     )
            //   ],
            // ),
            // SizedBox(
            //   height: 5.0,
            // ),
            MaterialButton(
              minWidth: double.infinity,
              height: 60,
              color: Colors.amber,
              child: Text('Continue',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              onPressed: () {
                print(_smsController.text);
                widget
                    .signInCallback(_smsController.text)
                    .then((FirebaseUser _user) {
                  // user = _user;
                  _checkIntoMaster(_user);
                });
              },
            ),
          ],
        ),
      );
  }
}
