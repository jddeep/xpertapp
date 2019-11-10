import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:xpert/broadcastpage.dart';
import 'package:xpert/detail_question_page.dart';
import 'package:xpert/videoanswerscreen.dart';
import 'package:xpert/xpert_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.cameras, this.user}) : super(key: key);

  final String title;
  var cameras;
  final FirebaseUser user;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<String> welcomeImages = [
    "assets/welcome0.png",
    "assets/welcome1.png",
    "assets/welcome2.png",
    "assets/welcome2.png",
    "assets/welcome1.png",
    "assets/welcome1.png"
  ];
  bool _isCardScrollable = false;
  bool _isPopularQuestion = false;
  var dropdownValue = '';
  static bool _isSwipeCompleted = false;
  static bool _isMandatory = false;
  bool _allQuestionsDone = false;
  static bool _isVisible = false;
  static bool _isAccepted = false; //let's assume default action is reject
  // The question incoming goes here below
  // String _questionAsked = 'What dietary restrictions should be followed by people who follow a sedentary lifestyle without much scope for exercise?';
  List<DocumentSnapshot> _userDocs;

  Future<List<DocumentSnapshot>> getData() async {
    List<DocumentSnapshot> userDocuments;
    await Firestore.instance
        .collection('xpert_master')
        .document('aayu-sinha') //widget.title
        .collection('orders')
        .where('status', isEqualTo: 'xpert review')
        .getDocuments()
        .then((data) {
      userDocuments = data.documents;
    }
            // (data) => print('grower ${data.documents[0]['name']}')
            );
    return userDocuments;
  }

  void _rejectUpdateData(_orderDocID) async{
    await Firestore.instance
    .collection('xpert_master')
    .document('aayu-sinha') //widget.title
    .collection('orders')
    .document(_orderDocID)
    .updateData({
      'status': _isMandatory? 'xpert review':'rejected'
    }).whenComplete((){
      print('Updated!');
    });
  }

  

  @override
  void initState() {
    getData().then((userDocs) {
      setState(() {
        _userDocs = userDocs;
        print('User doxs: ' + '${_userDocs.length}');
      });
    });
    super.initState();
  }

  Widget _xpertIntroCard(var company){
    return GestureDetector(
      onTap: () {
        // if (_isCardScrollable)
        //     _isCardScrollable = false;
        //   else {
        //     _isCardScrollable = true;
        //     Navigator.pushReplacement(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => DetailQuestionPage(
        //                   incomingQuestion: company["message"],
        //                 )));
        //   }
      },
      child: Card(
        clipBehavior: Clip.none,
        color: Colors.orange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
                  children:<Widget>[
                    
                    Opacity(
                      opacity: _isVisible? 0.5:1.0,
                                          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                      height: 65.0,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0))),
                  ),
                  Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                        company["orange_headline1"]??'Null',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,),
                      ),
                      Text(
                        company["orange_headline2"]?? 'Null',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold),
                      ),
                        ],
                      ),
                  ),
                ],
              ),
              company["message_type"]=='image'?
              Container(
                height: 200.0,
                width: 200.0,
                child: Image(
                  image: NetworkImage(company["message"]),
                  fit: BoxFit.contain,
                ),
              )
              :
              Expanded(
                //               child: company["message_type"]=='image'?
                //               Image(
                //   image: NetworkImage(company["message"]),
                //   fit: BoxFit.contain,
                // ):
                flex: 1,
                child: Container(
                  color: Colors.white,
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          company["message"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
              ),
                  // Container(
                  //     height: 50.0,
                  //     decoration: BoxDecoration(
                  //         color: Colors.orange,
                  //         borderRadius: BorderRadius.only(
                  //             bottomLeft: Radius.circular(10.0),
                  //             bottomRight: Radius.circular(10.0))),
                  // ),
                  company["tip"]!=null?Container(
                    height: 70.0,
                      padding: EdgeInsets.all(6.0),
                          child: company["tip"]!=null?Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              IconTheme(
                                data: IconThemeData(color: Colors.white),
                                child: Icon(Icons.lightbulb_outline),
                              ),
                              
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Text(
                                                                'XPERT TIP',
                                                                style: TextStyle(
                                                                    color: Colors.white,),
                                                              ),
                                                              Wrap(children: <Widget>[
                                                                Text(
                                                                  
                                                                  company["tip"]??'This is a demo tip',
                                                                  maxLines: 4,
                                                                  softWrap: true,
                                                                  style: TextStyle(
                                                                      color: Colors.white, fontSize: 12.0),
                                                                ),
                                                              ],
                                                                                                                          
                                                              ),
                                                      ],
                                                    ),
                            ],
                          ):Container(height: 1.0),
                        ):Container(height: 0.0),
              
            ],
          ),
                    ),
          _isVisible
            ?  Container(
                    child: Center(
                      child: Image(
                        image: _isAccepted? AssetImage('assets/accept_stamp.png') : AssetImage('assets/do_later_stamp.png'),
                      ),
                    ),
            ) : Container(),
                  ],
        ),
      ),
    );
  }

  Widget _questionCard(var questionAsked) {
    return GestureDetector(
      onTap: () {
        if (_isCardScrollable)
            _isCardScrollable = false;
          else {
            _isCardScrollable = true;
            print(questionAsked.documentID.toString());
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailQuestionPage(
                          incomingQuestion: questionAsked["message"],
                          orderDocId: questionAsked.documentID,
                        )));
          }
      },
      child: Card(
        clipBehavior: Clip.none,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: <Widget>[
            Opacity(
              opacity: _isVisible? 0.5:1.0,
                          child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                        child: Text(
                          'Answer',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            iconEnabledColor: Colors.white,
                            iconDisabledColor: Colors.white,
                            style: TextStyle(color: Colors.amber),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValue = newValue;
                              });
                            },
                            items: <String>['', 'Delete', 'Report']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  _isCardScrollable
                      ? SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              questionAsked["message"],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                              ),
                            ),
                          ))
                      : Expanded(
                          child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            questionAsked["message"],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w300),
                          ),
                        )),
                  _isCardScrollable
                      ? Container()
                      : Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Container(
                            child:
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8.0, left: 8.0, right: 4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    _isPopularQuestion
                                        ? Stack(
                                            children: <Widget>[
                                              CircleAvatar(
                                                radius: 25.0,
                                                backgroundImage:
                                                    AssetImage('assets/profile_pic.jpg'),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(left: 10.0),
                                                child: CircleAvatar(
                                                  radius: 25.0,
                                                  backgroundImage: AssetImage(
                                                      'assets/profile_pic.jpg'),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(left: 20.0),
                                                child: CircleAvatar(
                                                  radius: 25.0,
                                                  backgroundImage: AssetImage(
                                                      'assets/profile_pic.jpg'),
                                                ),
                                              ),
                                            ],
                                          )
                                        : 
                                              Row(
                                                children: <Widget>[
                                                  questionAsked["profile_image"]!=null?CircleAvatar(
                                                    radius: 20.0,
                                                    backgroundImage: NetworkImage(
                                                        questionAsked["profile_image"]),
                                                  ):Container(height: 1.0,),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      _isPopularQuestion
                                                          ? Text(
                                                              'VOTED BY',
                                                              style: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontSize: 12.0),
                                                            )
                                                          : Text(
                                                              'ASKED BY',
                                                              style: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontSize: 9.0),
                                                            ),
                                                      _isPopularQuestion
                                                          ? Row(
                                                              children: <Widget>[
                                                                Text(
                                                                  '10,000 ',
                                                                  style: TextStyle(
                                                                      color: Colors.amber,
                                                                      fontWeight:
                                                                          FontWeight.bold,
                                                                      fontSize: 22.0),
                                                                ),
                                                                Text(
                                                                  'people',
                                                                  style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontWeight:
                                                                          FontWeight.bold,
                                                                      fontSize: 14.0),
                                                                ),
                                                              ],
                                                            )
                                                          : Text(
                                                              questionAsked["name"],
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontWeight:
                                                                      FontWeight.bold,
                                                                  fontSize: 14.0),
                                                            ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              _isPopularQuestion
                                                  ? Container()
                                                  : Text(
                                                      '₹'+questionAsked["amount"].toString(),
                                                      style: TextStyle(
                                                          color: Colors.amber,
                                                          fontSize: 20.0),
                                                    ),
                                  ],
                                ),
                              ),
                          ),
                        ),
                ],
              ),
            ),
            _isVisible
            ?  Container(
                    child: Center(
                      child: Image(
                        image: _isAccepted? AssetImage('assets/accept_stamp.png') :
                        _isMandatory? AssetImage('assets/do_later_stamp.png') : AssetImage('assets/reject_stamp.png'),
                      ),
                    ),
            ) : Container(),
          ],
        ),
      ),
    );
  }

  Widget _endorsementCard(var company){
    return GestureDetector(
      onTap: () {
        if (_isCardScrollable)
            _isCardScrollable = false;
          else {
            _isCardScrollable = true;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailQuestionPage(
                          incomingQuestion: company["message"],
                          orderDocId: company.documentID,
                        )));
          }
      },
      child: Card(
        clipBehavior: Clip.none,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: <Widget>[
            Opacity(
              opacity: _isVisible?0.5:1.0,
                          child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 65.0,
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0))),
                      ),
                      Align(
                        alignment: AlignmentDirectional.topCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                          'Give a shoutout for',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,),
                        ),
                        Text(
                          company["for"], //earlier "name"
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            iconEnabledColor: Colors.white,
                            iconDisabledColor: Colors.white,
                            style: TextStyle(color: Colors.amber),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValue = newValue;
                              });
                            },
                            items: <String>['', 'Delete', 'Report']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  _isCardScrollable
                      ? SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              company["message"],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                              ),
                            ),
                          ))
                      : Expanded(
                          child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            company["message"],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w300),
                          ),
                        )),
                  _isCardScrollable
                      ? Container()
                      : Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Container(
                            child: 
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8.0, left: 8.0, right: 4.0),
                                child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                          'REQUESTED BY',
                                                          style: TextStyle(
                                                              color: Colors.grey,
                                                              fontSize: 9.0),
                                                        ),
                                                        Text(
                                                          company["name"],
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontSize: 14.0),
                                                        ),
                                                ],
                                              ),
                                              IconTheme(
                                                data: IconThemeData(color: Colors.amber, size: 8.0),
                                                child: Icon(Icons.info_outline),
                                              )
                                            ],
                                          ),
                                          _isPopularQuestion
                                              ? Container()
                                              : Padding(
                                                padding: EdgeInsets.only(left: 4.0),
                                                child:Text(
                                                  '₹'+company["amount"].toString(),
                                                  style: TextStyle(
                                                      color: Colors.amber,
                                                      fontSize: 20.0),
                                                ),
                                              ),
                                        ],
                                      ),
                              ),
                          ),
                        ),
                ],
              ),
            ),
            _isVisible
            ?  Container(
                    child: Center(
                      child: Image(
                        image: _isAccepted? AssetImage('assets/accept_stamp.png') :
                         _isMandatory? AssetImage('assets/do_later_stamp.png') : AssetImage('assets/reject_stamp.png'),
                      ),
                    ),
            ) : Container(),
          ],
        ),
      ),
    );
  }

  Widget _wishCard(var user){
    return GestureDetector(
      onTap: () {
        if (_isCardScrollable)
            _isCardScrollable = false;
          else {
            _isCardScrollable = true;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailQuestionPage(
                          incomingQuestion: user["message"],
                          orderDocId: user.documentID,
                        )));
          }
        // setState(() {
        //   if (_isCardScrollable)
        //     _isCardScrollable = false;
        //   else {
        //     _isCardScrollable = true;
        //     Navigator.pushReplacement(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => DetailQuestionPage(
        //                   incomingQuestion: user["message"],
        //                 )));
        //   }
        // });
      },
      child: Card(
        clipBehavior: Clip.none,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: <Widget>[
            Opacity(
              opacity: _isVisible?0.5:1.0,
                          child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 65.0,
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0))),
                      ),
                      Align(
                        alignment: AlignmentDirectional.topCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                          'Record a wish for',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,),
                        ),
                        Text(
                          user["for"], // earlier "name"
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                              value: dropdownValue,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              iconEnabledColor: Colors.white,
                              iconDisabledColor: Colors.white,
                              style: TextStyle(color: Colors.amber),
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                });
                              },
                              items: <String>['', 'Delete', 'Report']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  _isCardScrollable
                      ? SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              user["message"],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                              ),
                            ),
                          ))
                      : Expanded(
                          child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            user["message"],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w300),
                          ),
                        )),
                  _isCardScrollable
                      ? Container()
                      : Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Container(
                            child: 
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8.0, left: 8.0, right: 4.0),
                                child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                          'REQUESTED BY',
                                                          style: TextStyle(
                                                              color: Colors.grey,
                                                              fontSize: 9.0),
                                                        ),
                                                        Text(
                                                          user["name"],
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontSize: 14.0),
                                                        ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          _isPopularQuestion
                                              ? Container()
                                              : Padding(
                                                padding: EdgeInsets.only(left: 4.0),
                                                child:Text(
                                                  '₹'+user["amount"].toString(),
                                                  style: TextStyle(
                                                      color: Colors.amber,
                                                      fontSize: 20.0),
                                                ),
                                              ),
                                        ],
                                      ),
                              ),
                          ),
                        ),
                ],
              ),
            ),
            _isVisible
            ?  Container(
                    child: Center(
                      child: Image(
                        image: _isAccepted? AssetImage('assets/accept_stamp.png') :
                         _isMandatory? AssetImage('assets/do_later_stamp.png') : AssetImage('assets/reject_stamp.png'),
                      ),
                    ),
            ) : Container(),
          ],
        ),
      ),
    );
  }

  static int _currDocIndex = 0;
  var orderDocId;
  @override
  Widget build(BuildContext context) {
    CardController controller; //Use this to trigger swap.
    print('Curr Doc Index: ' +_currDocIndex.toString());
    return new Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                child: Image(
                  image: AssetImage('assets/app_logo_bg.png'),
                  height: 50.0,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                color: Colors.grey,
                iconSize: 40.0,
                onPressed: () {},
              )
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(top: 20.0),
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: _allQuestionsDone
                        ? Container()
                        : _userDocs != null && _userDocs.length !=0
                            ? StreamBuilder<DocumentSnapshot>(
                                stream: Firestore.instance
                                    .collection('xpert_master')
                                    .document('aayu-sinha')// aparna-prasad
                                    .collection('orders')
                                    .document(_userDocs
                                        .elementAt(_currDocIndex)
                                        .documentID)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: Container(
                                        height: 50.0,
                                        width: 50.0,
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.amber,
                                        ),
                                      ),
                                    );
                                  }
                                  var userDocument = snapshot.data;
                                  orderDocId = userDocument.documentID;
                                  return _isCardScrollable
                                      ? (){
                                        print('Mandatory user DOC: ' + userDocument["mandatory"].toString());
                                        if(userDocument["mandatory"].toString() == "yes"){
                                          _isMandatory = true;
                                        }else{
                                          _isMandatory = false;
                                        }
                                        if(userDocument["type"].toString()=="orange"){
                                          print('returning orange card');
                                          return _xpertIntroCard(userDocument); // mandatory should be "yes"
                                        }else{
                                          print('returning else');
                                        if(userDocument["type"].toString()=="wishes")
                                        return _wishCard(userDocument);
                                        else if(userDocument["type"].toString()=="endorsement")
                                        return _endorsementCard(userDocument);
                                        else
                                        return _questionCard(userDocument);
                                        }
                                      }
                                      : Transform.scale(
                                          scale: 1 / 0.68,
                                          child: TinderSwapCard(animDuration: 5,
                                              orientation:
                                                  AmassOrientation.BOTTOM,
                                              totalNum: 6,
                                              stackNum: 3,
                                              swipeEdge: 3.0,
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              maxHeight: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1.0,
                                              minWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              minHeight: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              cardBuilder: ((context, index){
                                        if(userDocument["mandatory"].toString() == "yes"){
                                          _isMandatory = true;
                                        } else{
                                          _isMandatory = false;
                                        }
                                        if(userDocument["type"].toString()=="orange"){
                                          print('returning orange card');
                                          return _xpertIntroCard(userDocument); // mandatory should be "yes"
                                        }else{
                                          print('returning else');
                                          
                                        if(userDocument["type"].toString()=="wishes")
                                        return _wishCard(userDocument);
                                        else if(userDocument["type"].toString()=="endorsement")
                                        return _endorsementCard(userDocument);
                                        else
                                        return _questionCard(userDocument);
                                        }
                                              }),
                                              // cardBuilder: (context, index) => Card(
                                              //       child: Image.asset('${welcomeImages[index]}'),
                                              //       color: Colors.white,
                                              //     ),
                                              cardController: controller =
                                                  CardController(),
                                              swipeUpdateCallback:
                                                  (DragUpdateDetails details,
                                                      Alignment align) {
                                                /// Get swiping card's alignment
                                                
                                                print(align.x);

                                                if (align.x > 1 &&
                                                    align.x < 3.2) {
                                                  _isVisible = true;
                                                  _isAccepted = true;
                                                } else if (align.x < -1) {
                                                  _isVisible = true;
                                                  _isAccepted = false;
                                                  if(align.x.abs() >= 3.2){
                                                    print('leftSwipComp');
                                                    _isSwipeCompleted = true;
                                                    
                                                  }
                                                  print('left');
                                                  //Card is LEFT swiping
                                                } else if (align.x >= 3.2) {
                                                  _isSwipeCompleted = true;
                                                  print('rightSwipComp');
                                                } else if(align.x.abs()>=0 && align.x.abs() <=1){
                                                  _isVisible = false;
                                                }
                                              },
                                              swipeCompleteCallback:(CardSwipeOrientation orientation,
                                                      int index) {
                                                        
                                                /// Get orientation & index of swiped card!
                                                if(_isSwipeCompleted) {
                                                                                         print('swipe completed!');
                                                print('Users Length:' + '${_userDocs.length}');
                                                print('$_isAccepted' + '$_isSwipeCompleted');
                                                if(_isAccepted && _isSwipeCompleted){
                                                  print('accepted');
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              new CameraApp(
                                                                  // userDocument["message_type"]=="text"?
                                                                  userDocument["teleprompter_text"]??'No Teleprompter text',
                                                                      orderDocId,
                                                                      'aayu-sinha')));

                                                  print('right');
                                                } else {
                                                  _rejectUpdateData(orderDocId);
                                                  print('rejected');
                                                }
                                                _isVisible = false;
                                                _isSwipeCompleted = false;
                                                
                                                  setState(() {
                                                    _currDocIndex++;
                                                    if (_currDocIndex >=
                                                    _userDocs.length) {
                                                    _allQuestionsDone = true;
                                                    }
                                                  });
                                                }}
                                              ),
                                        );
                                })
                            : Container()),
                SizedBox(
                  height: 100.0,
                ),
                _isCardScrollable || _allQuestionsDone
                    ? Container()
                    : Text(
                        'Swipe right to answer',
                        style: TextStyle(color: Colors.grey),
                      ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
  child: Container(
   width:50,
   height: 50,
   decoration: BoxDecoration(
    //  color: Colors.black,
     image: DecorationImage(
       image:AssetImage("assets/chat_icon.png"), 
       fit:BoxFit.cover
     ),
   ),
  ),onTap:(){
   Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BroadcastPage()));
                
  }
),
GestureDetector(
  child: Container(
   width:50,
   height: 50,
   decoration: BoxDecoration(
    //  color: Colors.black,
     image: DecorationImage(
       image:AssetImage("assets/cards_icon.png"), 
       fit:BoxFit.cover
     ),
   ),
  ),onTap:(){
  //  Navigator.push(context,
  //                     MaterialPageRoute(builder: (context) => BroadcastPage()));
                
  }
),
GestureDetector(
  child: Container(
   width:50,
   height: 50,
   decoration: BoxDecoration(
    //  color: Colors.black,
     image: DecorationImage(
       image:AssetImage("assets/user_prof_icon.png"), 
       fit:BoxFit.cover
     ),
   ),
  ),onTap:(){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => XpertProfilePage(widget.user, widget.title),
                      )); 
  }
)
            ],
          )
        ],
      ),
    );
  }
}

