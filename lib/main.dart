import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:xpert/otpscreen.dart';

import 'dart:async';
import 'xpertWelcome.dart';

List<CameraDescription> cameras;
bool isLoggedIn = false;

Future<Null> main() async {
  
  try {
    WidgetsFlutterBinding.ensureInitialized();
    // cameras = await availableCameras();
    
  } on CameraException catch (e) {
    print(e);
  }
  if (await FirebaseAuth.instance.currentUser() != null){
      isLoggedIn = true;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final pages = [
    PageViewModel(
        pageColor: new Color(0xFF37474F),
        body: Text(
          'Earn money by answering questions',
        ),
        title: Text(
          '',
        ),
        titleTextStyle: TextStyle(color: Colors.white),
        bodyTextStyle: TextStyle(color: Colors.white),
        mainImage: Padding(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: new Container(
            color: Colors.white,
            alignment: Alignment.center,
          ),
        )),
    PageViewModel(
      pageColor: new Color(0xFF37474F),
      body: Text(
        'Earn money by brand shoutouts',
      ),
      title: Text(''),
      mainImage: Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: new Container(
          color: Colors.white,
          alignment: Alignment.center,
        ),
      ),
      titleTextStyle: TextStyle(color: Colors.white),
      bodyTextStyle: TextStyle(color: Colors.white),
    ),
    PageViewModel(
      pageColor: new Color(0xFF37474F),
      body: Text(
        'Earn money recording wishes for fans',
      ),
      title: Text(''),
      mainImage: Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: new Container(
          color: Colors.white,
          alignment: Alignment.center,
        ),
      ),
      titleTextStyle: TextStyle(color: Colors.white),
      bodyTextStyle: TextStyle(color: Colors.white),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XPERT',
      theme:
          ThemeData(primarySwatch: Colors.yellow, brightness: Brightness.dark),
      home: Builder(
        builder: (context) => IntroViewsFlutter(
          pages,
          showNextButton: false,
          showBackButton: false,
          onTapDoneButton: () {
            if(!isLoggedIn){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => XpertWelcomePage(cameras),
              ), //MaterialPageRoute
            );
            } else{
              Navigator.pushReplacement(context,
              MaterialPageRoute(
                builder: (context)=> OTPScreen(cameras, null, '')
              )
              );
            }
            // Navigator.pop(context);
          },
          pageButtonTextStyles: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ), //IntroViewsFlutter
      ),
    );
  }
}
