// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:xpert/activeCard.dart';
// import 'package:flutter/scheduler.dart' show timeDilation;
// import 'package:xpert/videoanswerscreen.dart';
// import 'dummyCard.dart';

// class MyHomePage2 extends StatefulWidget {
//   @override
//   _MyHomePage2State createState() => _MyHomePage2State();
// }

// class _MyHomePage2State extends State<MyHomePage2>
//     with TickerProviderStateMixin {
//   AnimationController _buttonController;
//   Animation<double> rotate;
//   Animation<double> right;
//   Animation<double> bottom;
//   Animation<double> width;
//   int flag = 0;

//   String text;
//   static bool isAccepted = false;
//   static bool isRejected = false;

//   // List<String> data =
//   //     []; //[" Question 1", "Question 2", "Question 3", "Question 4"];
//   List<String> selectedData = [];

//   List<DocumentSnapshot> orders;

//   List<Widget> _questionsCards =[];

//   Future<List<DocumentSnapshot>> _getWebOrders() async {
//     List<DocumentSnapshot> d =
//         []; //[" Question 1", "Question 2", "Question 3", "Question 4"];

//     await Firestore.instance
//         .collection('xpert_master')
//         .document('aayu-sinha') //widget.title
//         .collection('orders')
//         .where('status', isEqualTo: 'xpert review')
//         .getDocuments()
//         .then((docs) {
//       for (var item in docs.documents) {
//         d.add(item);
//       }
//     });

//     return d;
//   }

//   _createCardList(List<DocumentSnapshot> data) {
//     List<Widget> _cards = [];
//     timeDilation = 0.4;

//     double initialBottom = 15.0;
//     var dataLength = data.length;
//     double backCardPosition = initialBottom + (dataLength - 1) * 10 + 10;
//     double backCardWidth = -10.0;
//     print(data.length);
//     int c =0;
//     for (var item in data) {
//       if (c==0) {
//         _cards.add(
//           cardDemo(
//             item.data, //.data['message'],
//             bottom.value,
//             right.value,
//             0.0,
//             backCardWidth + 30,
//             rotate.value,
//             rotate.value < -10 ? 0.1 : 0.0,
//             isAccepted,
//             isRejected,
//             context,
//             dismissImg,
//             flag,
//             addImg,
//             swipeRight,
//             swipeLeft,
//           ),
//         );
//         c+=1;
//       } else {
//        _cards.add(cardDemo(
//             item.data, //.data['message'],
//             bottom.value + 10,
//             right.value,
//             0.0,
//             backCardWidth + 30,
//             rotate.value,
//             rotate.value < -10 ? 0.1 : 0.0,
//             isAccepted,
//             isRejected,
//             context,
//             dismissImg,
//             flag,
//             addImg,
//             swipeRight,
//             swipeLeft,
//           ),
//        );

//       }
//     }
//     setState(() {
//       _questionsCards = _cards;
//     });
//   }

//   void initState() {
//     super.initState();
//     _getWebOrders().then((_data) {
//       setState(() {
//         orders = _data;
//       });
//       _buttonController = new AnimationController(
//         duration: new Duration(milliseconds: 1000), vsync: this);

//     rotate = new Tween<double>(
//       begin: -0.0,
//       end: -40.0,
//     ).animate(
//       new CurvedAnimation(
//         parent: _buttonController,
//         curve: Curves.ease,
//       ),
//     );
//     rotate.addListener(() {
//       setState(() {
//         if (rotate.isCompleted) {
//           //todo
//           // var i = data.removeLast();
//           // data.insert(0, i);
//           _buttonController.reset();
//         }
//       });
//     });

//     right = new Tween<double>(
//       begin: 0.0,
//       end: 400.0,
//     ).animate(
//       new CurvedAnimation(
//         parent: _buttonController,
//         curve: Curves.ease,
//       ),
//     );
//     bottom = new Tween<double>(
//       begin: 15.0,
//       end: 100.0,
//     ).animate(
//       new CurvedAnimation(
//         parent: _buttonController,
//         curve: Curves.ease,
//       ),
//     );
//     width = new Tween<double>(
//       begin: 20.0,
//       end: 25.0,
//     ).animate(
//       new CurvedAnimation(
//         parent: _buttonController,
//         curve: Curves.bounceOut,
//       ),
//     );
//       _createCardList(_data);
//       print(orders);
//     });
//     // _buttonController = new AnimationController(
//     //     duration: new Duration(milliseconds: 1000), vsync: this);

//     // rotate = new Tween<double>(
//     //   begin: -0.0,
//     //   end: -40.0,
//     // ).animate(
//     //   new CurvedAnimation(
//     //     parent: _buttonController,
//     //     curve: Curves.ease,
//     //   ),
//     // );
//     // rotate.addListener(() {
//     //   setState(() {
//     //     if (rotate.isCompleted) {
//     //       //todo
//     //       // var i = data.removeLast();
//     //       // data.insert(0, i);
//     //       _buttonController.reset();
//     //     }
//     //   });
//     // });

//     // right = new Tween<double>(
//     //   begin: 0.0,
//     //   end: 400.0,
//     // ).animate(
//     //   new CurvedAnimation(
//     //     parent: _buttonController,
//     //     curve: Curves.ease,
//     //   ),
//     // );
//     // bottom = new Tween<double>(
//     //   begin: 15.0,
//     //   end: 100.0,
//     // ).animate(
//     //   new CurvedAnimation(
//     //     parent: _buttonController,
//     //     curve: Curves.ease,
//     //   ),
//     // );
//     // width = new Tween<double>(
//     //   begin: 20.0,
//     //   end: 25.0,
//     // ).animate(
//     //   new CurvedAnimation(
//     //     parent: _buttonController,
//     //     curve: Curves.bounceOut,
//     //   ),
//     // );
//   }

//   @override
//   void dispose() {
//     _buttonController.dispose();
//     super.dispose();
//   }

//   Future<Null> _swipeAnimation() async {
//     try {
//       await _buttonController.forward();
//     } on TickerCanceled {}
//   }

//   dismissImg(String txt) {
//     setState(() {
//       //todo
//       // data.remove(txt);
//       _questionsCards.removeLast();
//       print(orders);
//     });
//   }

//   addImg(String txt) {
//     setState(() {
//       //todo
//       // data.remove(txt);
//       _questionsCards.removeLast();

//       selectedData.add(txt);
//       print(orders);
//     });
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CameraExampleHome(
//           incomingQuestion: txt,
//         ),
//       ),
//     );
//   }

//   swipeRight(String txt) {
//     if (flag == 0)
//       setState(() {
//         flag = 1;
//         // data.remove(txt);
//         print(orders);
//         // selectedData.add(txt);
//       });
//     _swipeAnimation().whenComplete(() {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => CameraExampleHome(
//             incomingQuestion: txt,
//           ),
//         ),
//       );
//     });

//     // addImg(txt);
//   }

//   swipeLeft(String txt) {
//     if (flag == 1)
//       setState(() {
//         flag = 0;
//         // data.remove(txt);
//         print(orders);
//       });
//     _swipeAnimation();
//     // dismissImg(txt);
//   }

//   @override
//   Widget build(BuildContext context) {
//     timeDilation = 0.4;

//     double initialBottom = 15.0;
//     var dataLength = orders.length;
//     double backCardPosition = initialBottom + (dataLength - 1) * 10 + 10;
//     double backCardWidth = -10.0;
//     return Scaffold(
//         // backgroundColor: Color.fromRGBO(106, 94, 175, 1.0),
//         appBar: new AppBar(
//             elevation: 0.0,
//             // backgroundColor: new Color.fromRGBO(106, 94, 175, 1.0),
//             centerTitle: true,
//             leading: new Container(
//               // margin: const EdgeInsets.all(15.0),
//               // padding: const EdgeInsets.only(bottom: 10.0),
//               child: new IconButton(
//                 icon: Icon(Icons.person, size: 30),
//                 color: Colors.white,
//                 onPressed: () {
//                   //todo
//                 },
//               ),
//             ),
//             actions: <Widget>[
//               new GestureDetector(
//                 onTap: () {
//                   //todo
//                   // Navigator.push(
//                   //     context,
//                   //     new MaterialPageRoute(
//                   //         builder: (context) => new PageMain()));
//                 },
//                 child: new Container(
//                     // margin: const EdgeInsets.all(15.0),
//                     child: new Icon(
//                   Icons.notifications,
//                   color: Colors.white,
//                   size: 30.0,
//                 )),
//               ),
//             ],
//             title: Image.asset(
//               'assets/xpert_icon.png',
//               height: 35,
//             )),
//         body:
//             //     StreamBuilder<QuerySnapshot>(
//             //       stream: Firestore.instance
//             // .collection('web_orders')
//             // .snapshots(),
//             //       builder: (context, snapshot) {
//             //     return
//             //    snapshot.hasData?
//             Stack(
//           //   mainAxisAlignment: MainAxisAlignment.center,
//           alignment: Alignment.topCenter,
//           children: <Widget>[
//             // new Container(
//             //   height: MediaQuery.of(context).size.height * 0.8,
//             //   color: Colors.red, //new Color.fromRGBO(106, 94, 175, 1.0),
//             //   alignment: Alignment.center,
//             //   child:
//             Center(
//                 child: _questionsCards.length > 0
//                     ? new Stack(
//                         alignment: AlignmentDirectional.center,
//                         children: _questionsCards,
//                         //     children: data.map((item) {
//                         //       if (data.indexOf(item) == dataLength - 1) {
//                         //         text = item; //.data['message'];
//                         //         print(text);
//                         //         return cardDemo(
//                         //           item, //.data['message'],
//                         //           bottom.value,
//                         //           right.value,
//                         //           0.0,
//                         //           backCardWidth + 10,
//                         //           rotate.value,
//                         //           rotate.value < -10 ? 0.1 : 0.0,
//                         //           context,
//                         //           dismissImg,
//                         //           flag,
//                         //           addImg,
//                         //           swipeRight,
//                         //           swipeLeft,
//                         //         );
//                         //       } else {
//                                 // backCardPosition = backCardPosition - 10;
//                                 // backCardWidth = backCardWidth + 10;

//                         //         return cardDemoDummy(
//                         //             item, //.data['message'],
//                         //             backCardPosition,
//                         //             0.0,
//                         //             0.0,
//                         //             backCardWidth,
//                         //             0.0,
//                         //             0.0,
//                         //             context);
//                         //       }
//                         //     }).toList())
//                         // : new Text("No Card Left",
//                         //     style:
//                         //         new TextStyle(color: Colors.white, fontSize: 50.0)
//                       )
//                     : new Text("No Card Left",
//                         style: new TextStyle(
//                             color: Colors.white, fontSize: 50.0))),

//             Positioned(
//               bottom: MediaQuery.of(context).size.height * 0.04,
//               child: Container(
//                 // color:  Color.fromRGBO(106, 94, 175, 1.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     new FlatButton(
//                         padding: new EdgeInsets.all(0.0),
//                         onPressed: () {
//                           swipeLeft(text);
//                           setState(() {
//                             _questionsCards.removeLast();
//                             // data.remove(text);
//                             print("#####$orders");
//                           });
//                         },
//                         child: new Container(
//                           height: 30.0,
//                           width: 130.0,
//                           alignment: Alignment.center,
//                           decoration: new BoxDecoration(
//                             color: Colors.red,
//                             borderRadius: new BorderRadius.circular(60.0),
//                           ),
//                           child: new Text(
//                             "DON'T",
//                             style: new TextStyle(color: Colors.white),
//                           ),
//                         )),
//                     new FlatButton(
//                         padding: new EdgeInsets.all(0.0),
//                         onPressed: () {
//                           swipeRight(text);
//                           setState(() {
//                             orders.remove(text);
//                             print("#####$orders");
//                           });
//                         },
//                         child: new Container(
//                           height: 30.0,
//                           width: 130.0,
//                           alignment: Alignment.center,
//                           decoration: new BoxDecoration(
//                             color: Colors.cyan,
//                             borderRadius: new BorderRadius.circular(60.0),
//                           ),
//                           child: new Text(
//                             "I'M IN",
//                             style: new TextStyle(color: Colors.white),
//                           ),
//                         ))
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ) // }
//         );
//     // );
//   }
// }
/////////////////////////////////////////////////////////

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xpert/activeCard.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:xpert/notofication_page.dart';
import 'package:xpert/videoanswerscreen.dart';
import 'package:xpert/xpert_profile_page.dart';
import 'dummyCard.dart';

class MyHomePage2 extends StatefulWidget {
  final userDocId;
  final FirebaseUser user;
  MyHomePage2({this.userDocId, this.user});
  @override
  _MyHomePage2State createState() => _MyHomePage2State();
}

class _MyHomePage2State extends State<MyHomePage2>
    with TickerProviderStateMixin {
  AnimationController _buttonController;
  Animation<double> rotate;
  Animation<double> right;
  Animation<double> bottom;
  Animation<double> width;
  int flag = 0;

  String text;
  DocumentSnapshot _item;

  // List<String> data =
  //     []; //[" Question 1", "Question 2", "Question 3", "Question 4"];
  List<DocumentSnapshot> selectedData = new List();

  List<DocumentSnapshot> orders = new List();
  static bool isAccepted = false;
  static bool isRejected = false;
  static bool isDoLater = false;
  bool _isMandatory = false;

  List<Widget> _questionsCards = [];

  Future<List<DocumentSnapshot>> _getWebOrders() async {
    List<DocumentSnapshot> d = new List();
    //[" Question 1", "Question 2", "Question 3", "Question 4"];

    await Firestore.instance
        .collection('xpert_master')
        .document(widget.userDocId)
        // .document('aayush-sinha')//widget.title
        .collection('orders')
        .where('status', isEqualTo: 'xpert review')
        .getDocuments()
        .then((docs) {
      for (var item in docs.documents) {
        print('DATA MESSG:' + item.data['message']);
        d.add(item);
      }
    });

    return d;
  }

  void _rejectUpdateData(_orderDocID) async {
    print('Reject func called id: ' +
        widget.userDocId.toString() +
        ' ' +
        _orderDocID.toString());
    await Firestore.instance
        .collection('xpert_master')
        .document(widget.userDocId) // 'duhita-banerjee'
        // .document('aayush-sinha') //widget.title
        .collection('orders')
        .document(_orderDocID)
        .updateData({
      'status': _isMandatory ? 'xpert review' : 'rejected'
    }).whenComplete(() {
      print('Updated!');
      _isMandatory = false;
    });
  }

  void _acceptUpdateData(_orderDocID) async{
    print('Accept func called id: ' +
        widget.userDocId.toString() +
        ' ' +
        _orderDocID.toString());
    await Firestore.instance
        .collection('xpert_master')
        .document(widget.userDocId) // 'duhita-banerjee'
        // .document('aayush-sinha') //widget.title
        .collection('orders')
        .document(_orderDocID)
        .updateData({
      'status': 'accepted'
    }).whenComplete(() {
      print('Updated!');
      _isMandatory = false;
    });
  }

  void _doLater(_orderDocID) async {
    await Firestore.instance
        .collection('xpert_master')
        .document(widget.userDocId) // 'duhita-banerjee'
        // .document('aayush-sinha') //widget.title
        .collection('orders')
        .document(_orderDocID)
        .updateData({'status': 'xpert review'}).whenComplete(() {
      print('Updated!');
    });
  }

  _createCardList(List<DocumentSnapshot> data) {
    print(
        'MEDIAQUERY HEIGHT: ' + MediaQuery.of(context).size.height.toString());
    print('MEDIAQUERY WIDTH: ' + MediaQuery.of(context).size.width.toString());

    List<Widget> _cards = [];
    timeDilation = 0.4;

    double initialBottom = MediaQuery.of(context).size.height / 48.8; // 15.0
    var dataLength = data.length;
    // double backCardPosition = initialBottom + (dataLength - 1) * 10 + 10;
    double backCardWidth = -(MediaQuery.of(context).size.width / 36.0); // -10.0
    print(data.length);
    int c = 0;
    for (var item in data) {
      if (c == 0) {
        _cards.add(
          cardDemo(
            // 'aayush-sinha',
            widget.userDocId,
            item.documentID,
            item.data, //.data['message'],
            bottom.value,
            right.value,
            0.0,
            backCardWidth + 10,
            rotate.value,
            rotate.value < -10 ? 0.1 : 0.0,
            isAccepted,
            isRejected,
            isDoLater,
            context,
            dismissImg,
            flag,
            addImg,
            swipeRight,
            swipeLeft,
          ),
        );
        c += 1;
      } else {
        _cards.add(
          cardDemo(
            // 'aayush-sinha',
            widget.userDocId,
            item.documentID,
            item.data, //.data['message'],
            bottom.value + 10,
            right.value,
            0.0,
            backCardWidth + 10,
            rotate.value,
            rotate.value < -10 ? 0.1 : 0.0,
            isAccepted,
            isRejected,
            isDoLater,
            context,
            dismissImg,
            flag,
            addImg,
            swipeRight,
            swipeLeft,
          ),
        );
      }
    }
    setState(() {
      _questionsCards = _cards;
    });
  }

  void initState() {
    super.initState();
    _getWebOrders().then((_data) {
      setState(() {
        print('ORDERS LENGTH: ' + _data.length.toString());
        orders = _data;
      });
      // _createCardList(_data);
      print('ORDERS LENGTH: ' + orders.length.toString());
    });
    _buttonController = new AnimationController(
        duration: new Duration(milliseconds: 1400), vsync: this);

    // rotate = new Tween<double>(
    //   begin: -0.0,
    //   end: -(MediaQuery.of(context).size.width/9.0), // -40.0
    // ).animate(
    //   new CurvedAnimation(
    //     parent: _buttonController,
    //     curve: Curves.ease,
    //   ),
    // );
    // rotate.addListener(() {
    //   setState(() {
    //     if (rotate.isCompleted) {
    //       //todo
    //       // var i = data.removeLast();
    //       // data.insert(0, i);
    //       _buttonController.reset();
    //     }
    //   });
    // });

    // right = new Tween<double>(
    //   begin: 0.0,
    //   end: MediaQuery.of(context).size.width + 40.0, //400.0
    // ).animate(
    //   new CurvedAnimation(
    //     parent: _buttonController,
    //     curve: Curves.ease,
    //   ),
    // );
    // bottom = new Tween<double>(
    //   begin: MediaQuery.of(context).size.width/24.0, // 15.0
    //   end: MediaQuery.of(context).size.width/3.6, //100.0
    // ).animate(
    //   new CurvedAnimation(
    //     parent: _buttonController,
    //     curve: Curves.ease,
    //   ),
    // );
    // width = new Tween<double>(
    //   begin: MediaQuery.of(context).size.width/18.0, // 20.0
    //   end: MediaQuery.of(context).size.width/14.4, //25.0
    // ).animate(
    //   new CurvedAnimation(
    //     parent: _buttonController,
    //     curve: Curves.bounceOut,
    //   ),
    // );
  }

  void initAnimation() {
    rotate = new Tween<double>(
      begin: -0.0,
      end: -(MediaQuery.of(context).size.width / 9.0), // -40.0
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    rotate.addListener(() {
      setState(() {
        if (rotate.isCompleted) {
          //todo
          // var i = data.removeLast();
          // data.insert(0, i);
          _buttonController.reset();
        }
      });
    });

    right = new Tween<double>(
      begin: 0.0,
      end: MediaQuery.of(context).size.width + 40.0, //400.0
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    bottom = new Tween<double>(
      begin: MediaQuery.of(context).size.width / 24.0, // 15.0
      end: MediaQuery.of(context).size.width / 3.6, //100.0
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    width = new Tween<double>(
      begin: MediaQuery.of(context).size.width / 18.0, // 20.0
      end: MediaQuery.of(context).size.width / 14.4, //25.0
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.bounceOut,
      ),
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  Future<Null> _swipeAnimation() async {
    try {
      await _buttonController.forward();
    } on TickerCanceled {}
  }

  dismissImg(var txt) {
    isRejected = true;
    setState(() {
      //todo
      orders.remove(txt);
      _questionsCards.removeLast();
      if (txt.data['mandatory'] == 'yes') _isMandatory = true;
      _rejectUpdateData(txt.documentID);
      print(orders);
    });
    isRejected = false;
  }

  doLaterPressed(var txt) {
    isRejected = true;
    isDoLater = true;
    if (flag == 1)
      setState(() {
        flag = 0;
        print(orders);
      });
    _swipeAnimation().whenComplete(() {
      setState(() {
        _doLater(txt.documentID);
        orders.remove(txt);
      });
      isRejected = false;
      isDoLater = false;
    });
  }

  addImg(var txt) {
    isAccepted = true;
    setState(() {
      //todo
      orders.remove(txt);
      _questionsCards.removeLast();

      selectedData.add(txt);
      print(orders);
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraExampleHome(
          incomingQuestion: txt.data['teleprompter_text'] ??
              'No teleprompter text', // teleprompter_text
          docId: widget.userDocId,
          // docId: 'aayush-sinha',
          orderDocId: txt.documentID,
        ),
      ),
    );
    isAccepted = false;
  }

  swipeRight(var txt) {
    isAccepted = true;
    if (flag == 0)
      setState(() {
        flag = 1;
        print(orders);
        // selectedData.add(txt);
      });
    _swipeAnimation().whenComplete(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraExampleHome(
            incomingQuestion: txt.data['teleprompter_text'] ??
                'No teleprompter text', // teleprompter_text
            docId: widget.userDocId,
            // docId: 'aayush-sinha',
            orderDocId: txt.documentID,
          ),
        ),
      );
      print('Swipe right question cards: ' + _questionsCards.length.toString());

      isAccepted = false;
      orders.remove(txt);
      _questionsCards.removeLast();
      if(_questionsCards.length == 0){
        _acceptUpdateData(txt.documentID);
    }
      print('SWIPE ORDERS LEN: ' + orders.length.toString());
      
    });

    // addImg(txt);
  }

  swipeLeft(var txt) {
    isRejected = true;
    if (flag == 1)
      setState(() {
        flag = 0;
        print(orders);
      });
    _swipeAnimation().whenComplete(() {
      setState(() {
        if (txt.data['mandatory'] == 'yes') _isMandatory = true;

        _rejectUpdateData(txt.documentID);
        orders.remove(txt);
        if(orders.length == 0)
        _questionsCards = new List();
      });
      isRejected = false;
    });
  }

  Widget _noCardLeftRefresh() {
    print('No card refr meth called');
    print(_questionsCards.length);
    print(orders.length);
    _getWebOrders().then((_data) {
      setState(() {
        print('ORDERS LENGTH: ' + _data.length.toString());
        orders = _data;
      });
      // _createCardList(_data);
      print('ORDERS LENGTH: ' + orders.length.toString());
    });
    return Center(
        child: Container(
          height: 0.0,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    initAnimation();
    double initialBottom = MediaQuery.of(context).size.height / 48.8; // 15.0
    var dataLength = orders.length;
    double backCardPosition = initialBottom + (dataLength - 1) * 10 + 10;
    double backCardWidth = -(MediaQuery.of(context).size.width / 36.0); // -10.0
    _createCardList(orders);

    return Scaffold(
      appBar: new AppBar(
          elevation: 0.0,
          centerTitle: true,
          leading: new Container(
            child: new IconButton(
              icon: Icon(Icons.person, size: 30),
              color: Colors.white,
              onPressed: () {
                //todo
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            XpertProfilePage(widget.user, widget.userDocId)));
              },
            ),
          ),
          actions: <Widget>[
            new GestureDetector(
              onTap: () {
                //todo
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationPage(),
                    ));
              },
              child: new Container(
                  padding: EdgeInsets.only(right: 14.0),
                  child: new Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 30.0,
                  )),
            ),
          ],
          title: Image.asset(
            'assets/xpert_icon.png',
            height: 55,
          )),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
           _questionsCards.length > 0
                ? Stack(
                    alignment: Alignment.center,
                    // children: _questionsCards,
                    children: orders.map((item) {
                      if (orders.indexOf(item) == dataLength - 1) {
                        _item = item;
                        text = item.data['message']; //.data['message'];
                        print('ITEM DATA MAP: ' + item.data.toString());
                        return cardDemo(
                          // 'aayu-sinha',
                          widget.userDocId,
                          item.documentID,
                          item.data, //.data['message'],
                          bottom.value,
                          right.value,
                          0.0,
                          backCardWidth + 10,
                          rotate.value,
                          rotate.value < -10 ? 0.1 : 0.0,
                          isAccepted,
                          isRejected,
                          isDoLater,
                          context,
                          dismissImg,
                          flag,
                          addImg,
                          swipeRight,
                          swipeLeft,
                        );
                      } else {
                        double bkdist;
                        print('QUESTION CARDS LENGTH: '+ _questionsCards.length.toString());
                        if(_questionsCards.length > 2)
                        bkdist = MediaQuery.of(context).size.height <= 640.0?MediaQuery.of(context).size.height/58.0:MediaQuery.of(context).size.height/68.0;
                        else
                        bkdist = MediaQuery.of(context).size.height <= 640.0?MediaQuery.of(context).size.height/20.0:MediaQuery.of(context).size.height/30.0;
                        // double bkdist = MediaQuery.of(context).size.height <= 640.0?MediaQuery.of(context).size.height* 0.03:15;
                        backCardPosition = backCardPosition - bkdist;
                        // MediaQuery.of(context).size.height > 640? MediaQuery.of(context).size.height* 0.04
                        // :MediaQuery.of(context).size.height* 0.04;
                        backCardWidth = backCardWidth + 50;

                        return cardDemoDummy(
                            item.data, //.data['message'],
                            backCardPosition,
                            0.0,
                            0.0,
                            backCardWidth,
                            0.0,
                            0.0,
                            context);
                      }
                    }).toList())
                : _noCardLeftRefresh(),
                  // return Center(child:Text("No Card Left",
                  //   style: new TextStyle(color: Colors.white, fontSize: 50.0)));
                    
          
          Container(
              // color:  Color.fromRGBO(106, 94, 175, 1.0),
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 6.0),
                    child: GestureDetector(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.18,
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/reject_two.png'))),
                      ),
                      onTap: () {
                        if (_questionsCards.length != 0) swipeLeft(_item);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 0.0, left: 0.0),
                    child: GestureDetector(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.18,
                        height: MediaQuery.of(context).size.height * 0.07,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/do_later_two.png'))),
                      ),
                      onTap: () {
                        if (_questionsCards.length != 0) doLaterPressed(_item);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 6.0),
                    child: GestureDetector(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.18,
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/accept_two.png'))),
                      ),
                      onTap: () {
                        if (_questionsCards.length != 0) swipeRight(_item);
                      },
                    ),
                  ),
                  // OutlineButton(
                  //   padding: EdgeInsets.all(6.0),
                  //   shape: CircleBorder(
                  //     side: BorderSide(width: 4.0, color: Colors.white,)
                  //   ),
                  //   child: IconTheme(
                  //     data: IconThemeData(color: Colors.red, size: 50.0),
                  //     child: Icon(Icons.cancel)
                  //   ),
                  //   // child: Container(
                  //   //   height: 50.0,
                  //   //   decoration: BoxDecoration(
                  //   //     image: DecorationImage(image: AssetImage('assets/reject_icon.png'))
                  //   //   ),
                  //   // ),
                  //   onPressed: (){
                  //     if(_questionsCards.length != 0)
                  //     swipeLeft(_item);
                  //   },
                  // ),
                  // OutlineButton(
                  //   padding: EdgeInsets.all(6.0),
                  //   shape: CircleBorder(
                  //     side: BorderSide(width: 4.0, color: Colors.white,)
                  //   ),
                  //   child: IconTheme(
                  //     data: IconThemeData(color: Colors.yellow, size: 40.0),
                  //     child: Icon(Icons.refresh),
                  //   ),
                  //   // child: Container(
                  //   //   height: 50.0,
                  //   //   decoration: BoxDecoration(
                  //   //     image: DecorationImage(image: AssetImage('assets/do_later_icon.png'))
                  //   //   ),
                  //   // ),
                  //   onPressed: (){
                  //     // todo refresh
                  //     if(_questionsCards.length != 0)
                  //     doLaterPressed(_item);
                  //   },
                  // ),
                  // OutlineButton(
                  //   padding: EdgeInsets.all(6.0),
                  //   shape: CircleBorder(
                  //     side: BorderSide(width: 4.0, color: Colors.white,)
                  //   ),
                  //   // child: Container(
                  //   //   height: 50.0,
                  //   //   decoration: BoxDecoration(
                  //   //     image: DecorationImage(image: AssetImage('assets/accept_icon.png'))
                  //   //   ),
                  //   // ),
                  //   child: IconTheme(
                  //     data: IconThemeData(color: Colors.green, size: 50.0),
                  //     child: Icon(Icons.favorite),
                  //   ),
                  //   onPressed: (){
                  //     if(_questionsCards.length != 0)
                  //     swipeRight(_item);
                  //   },
                  // ),
                  // new FlatButton(
                  //     padding: new EdgeInsets.all(0.0),
                  //     onPressed: () {
                  //       swipeLeft(_item);
                  //       // setState(() {
                  //       //   data.remove(text);
                  //       //   print("#####$data");
                  //       // });
                  //     },
                  //     child: new Container(
                  //       height: 30.0,
                  //       width: 130.0,
                  //       alignment: Alignment.center,
                  //       decoration: new BoxDecoration(
                  //         color: Colors.red,
                  //         borderRadius: new BorderRadius.circular(60.0),
                  //       ),
                  //       child: new Text(
                  //         "DON'T",
                  //         style: new TextStyle(color: Colors.white),
                  //       ),
                  //     )),
                  // new FlatButton(
                  //     padding: new EdgeInsets.all(0.0),
                  //     onPressed: () {
                  //       swipeRight(_item);
                  //       // setState(() {
                  //       //   data.remove(text);
                  //       //   print("#####$data");
                  //       // });
                  //     },
                  //     child: new Container(
                  //       height: 30.0,
                  //       width: 130.0,
                  //       alignment: Alignment.center,
                  //       decoration: new BoxDecoration(
                  //         color: Colors.cyan,
                  //         borderRadius: new BorderRadius.circular(60.0),
                  //       ),
                  //       child: new Text(
                  //         "I'M IN",
                  //         style: new TextStyle(color: Colors.white),
                  //       ),
                  //     ))
                ],
              ),
            ),
          // ),
        ],
      ),
    );
  }
}
