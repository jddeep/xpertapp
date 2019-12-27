import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:xpert/mobile_login_page.dart';

import 'otpscreen.dart';

class XpertWelcome extends StatefulWidget {
  @override
  _XpertWelcomeState createState() => _XpertWelcomeState();
}

class _XpertWelcomeState extends State<XpertWelcome> {

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;

  _closeApp() async {
    await SystemNavigator.pop();
  }

  Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  _user = user;

  return 'signInWithGoogle succeeded: $_user';
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
                                // left: MediaQuery.of(context).size.width / 18,
                                top: MediaQuery.of(context).size.height / 80), // 100, 20, 6
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FlatButton(
                                    onPressed: (){
                                      Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context)=> XpertMobileLoginPage())
                                      );
                                    },
                                    color: Colors.white,
                                    padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                                    shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0)),
                                                child: Row(
                                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.08),
                                                      child: IconTheme(
                                                        data: IconThemeData(color: Colors.black),
                                                        child: Icon(Icons.phone),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.07),
                                                      child: Text(
                                                        'Log in using mobile number',
                                                        style: TextStyle(color: Colors.black, fontSize: 18.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FlatButton(
                                    padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                                    onPressed: (){
                                      signInWithGoogle().whenComplete((){
                                        print('USER EMAIL: ' + _user.email);
                                        Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context)=> OTPScreen(null, ''))
                                        );
                                      });
                                    },
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0)),
                                                child: Row(
                                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.08),                                                      child: Container(
                                                        height: 20.0,
                                                        width: 20.0,
                                                        decoration: BoxDecoration(
                                                          image: DecorationImage(image: AssetImage('assets/google.jpg'))
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.12),
                                                      child: Text(
                                                        'Log in with Google',
                                                        style: TextStyle(color: Colors.black, fontSize: 18.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                  ),
                                ),
                              ],
                            )
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
              },
            ),
          ],
        ),
      ),
    );
  }
}