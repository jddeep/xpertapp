import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:xpert/homepage2.dart';
import 'package:xpert/otpscreen.dart';
import 'package:xpert/xpert_welcome_page.dart';
import 'package:xpert/xpertinvitescreen.dart';

import 'dart:async';
import 'mobile_login_page.dart';

List<CameraDescription> cameras;
bool isLoggedIn = false;

Future<Null> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    // cameras = await availableCameras();

  } on CameraException catch (e) {
    print(e);
  }
  if (await FirebaseAuth.instance.currentUser() != null) {
    print('LOGGED IN: ' + FirebaseAuth.instance.currentUser().toString());
    isLoggedIn = true;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  // final pages = [
  //   PageViewModel(
  //       pageColor: new Color(0xFF37474F),
  //       body: Text(
  //         'Earn money by answering questions',
  //       ),
  //       title: Text(
  //         '',
  //       ),
  //       titleTextStyle: TextStyle(color: Colors.white),
  //       bodyTextStyle: TextStyle(color: Colors.white),
  //       mainImage: Padding(
  //         padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
  //         child: new Container(
  //           color: Colors.white,
  //           alignment: Alignment.center,
  //         ),
  //       )),
  //   PageViewModel(
  //     pageColor: new Color(0xFF37474F),
  //     body: Text(
  //       'Earn money by brand shoutouts',
  //     ),
  //     title: Text(''),
  //     mainImage: Padding(
  //       padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
  //       child: new Container(
  //         color: Colors.white,
  //         alignment: Alignment.center,
  //       ),
  //     ),
  //     titleTextStyle: TextStyle(color: Colors.white),
  //     bodyTextStyle: TextStyle(color: Colors.white),
  //   ),
  //   PageViewModel(
  //     pageColor: new Color(0xFF37474F),
  //     body: Text(
  //       'Earn money recording wishes for fans',
  //     ),
  //     title: Text(''),
  //     mainImage: Padding(
  //       padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
  //       child: new Container(
  //         color: Colors.white,
  //         alignment: Alignment.center,
  //       ),
  //     ),
  //     titleTextStyle: TextStyle(color: Colors.white),
  //     bodyTextStyle: TextStyle(color: Colors.white),
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Admin-Xpert',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.yellow, brightness: Brightness.dark),
        // home: Builder(
        //   builder: (context) => IntroViewsFlutter(
        //     pages,
        //     showNextButton: false,
        //     showBackButton: false,
        //     onTapDoneButton: () {
        //       if(!isLoggedIn){
        //       Navigator.pushReplacement(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => XpertWelcomePage(cameras),
        //         ), //MaterialPageRoute
        //       );
        //       } else{
        //         Navigator.pushReplacement(context,
        //         MaterialPageRoute(
        //           builder: (context)=> OTPScreen(cameras, null, '')
        //         )
        //         );
        //       }
        //       // Navigator.pop(context);
        //     },
        //     pageButtonTextStyles: TextStyle(
        //       color: Colors.white,
        //       fontSize: 18.0,
        //     ),
        //   ), //IntroViewsFlutter
        // ),
        home: isLoggedIn ? OTPScreen(null,null, '') : SplashIntroPage(),
        // home: isLoggedIn ? OTPScreen(null,null, '') : XpertWelcome()
        // home: XpertWelcome(),
        // home: MyHomePage2(user: null, userDocId: 'aayushi-sinha',)
        );
  }
}

class SplashIntroPage extends StatefulWidget {
  @override
  _SplashIntroPageState createState() => _SplashIntroPageState();
}

class _SplashIntroPageState extends State<SplashIntroPage> {

  @override
  void initState() {
    super.initState();
    new Timer(const Duration(seconds: 3), onClose);
  }

  void onClose() {
    Navigator.of(context).pushReplacement(new PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => XpertWelcome(),
        transitionDuration: const Duration(seconds: 2),
        transitionsBuilder: (context, anim1, anim2, child) {
          return new FadeTransition(
            child: child,
            opacity: anim1,
          );
        }));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'CONNECT',
              style: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold),

            ),
            Text(
              'WITH FOLLOWERS',
              style: TextStyle(color: Colors.amber, fontSize: 27.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Text(
              'SHARE',
              style: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold),

            ),
            Text(
              'YOUR EXPERIENCES',
              style: TextStyle(color: Colors.amber, fontSize: 27.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Text(
              'INFLUENCE',
              style: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold),

            ),
            Text(
              'CAREER PATHS',
              style: TextStyle(color: Colors.amber, fontSize: 27.0),
              textAlign: TextAlign.center,

            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          ],
        ),
      ),
    );
  }
}
