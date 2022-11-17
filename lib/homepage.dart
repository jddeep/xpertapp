import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:xpert/broadcastpage.dart';
import 'package:xpert/detail_question_page.dart';
import 'package:xpert/videoanswerscreen.dart';
import 'package:xpert/xpert_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.cameras}) : super(key: key);

  final String title;
  var cameras;
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
  bool _allQuestionsDone = false;
  static bool _isVisible = false;
  static bool _isAccepted = false; //let's assume default action is reject
  // The question incoming goes here below
  // String _questionAsked = 'What dietary restrictions should be followed by people who follow a sedentary lifestyle without much scope for exercise?';
  
  Widget _questionCard(String questionAsked) {
//    if(_isCardScrollable){
//      setState(() {
//        Navigator.pushReplacement(context,
//            MaterialPageRoute(builder: (context)=> DetailQuestionPage(incomingQuestion: _questionAsked,))
//        );
//      });
//      return Container();
//    }
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_isCardScrollable)
            _isCardScrollable = false;
          else{
            _isCardScrollable = true;
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context)=> DetailQuestionPage(incomingQuestion: questionAsked,))
            );
          }
        });
      },
      child: Card(
        clipBehavior: Clip.none,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                      topRight: Radius.circular(10.0)
                    )
                  ),
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
            _isVisible?Center(
              child: IconTheme(
                data: IconThemeData(color: _isAccepted?Colors.green:Colors.red, size: 30.0),
                child: Icon(_isAccepted?Icons.thumb_up:Icons.thumb_down),
              ),
            ):Container(),
            _isCardScrollable
                ? SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        questionAsked,
                        style: TextStyle(color: Colors.black, fontSize: 18.0,),
                      ),
                    ))
                : Expanded(
                    child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      questionAsked,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w300),
                    ),
                  )),
            _isCardScrollable
                ? Container()
                : Align(
                    alignment: AlignmentDirectional.bottomStart,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0, left: 8.0, right: 4.0),
                          child: _isPopularQuestion
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
                              : CircleAvatar(
                                  radius: 20.0,
                                  backgroundImage:
                                      AssetImage('assets/profile_pic.jpg'),
                                ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            
                            _isPopularQuestion
                                ? Text(
                                    'VOTED BY',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12.0),
                                  )
                                : Text(
                                    'ASKED BY',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 9.0),
                                  ),
                            _isPopularQuestion
                                ? Row(
                                    children: <Widget>[
                                      Text(
                                        '10,000 ',
                                        style: TextStyle(
                                            color: Colors.amber,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22.0),
                                      ),
                                      Text(
                                        'people',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0),
                                      ),
                                    ],
                                  )
                                : Text(
                                    'Anushka',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0),
                                  ),
                          ],
                        ),
                        _isPopularQuestion
                            ? Container()
                            : Padding(
                              padding: EdgeInsets.only(left: 44.0),
                              child: Text(
                                  '₹2500',
                                  style: TextStyle(
                                      color: Colors.amber, fontSize: 20.0),
                                ),
                            ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
int _currDocIndex = 0;
  @override
  Widget build(BuildContext context) {
    CardController controller; //Use this to trigger swap.
    List<DocumentSnapshot> userDocuments;
    Firestore.instance.collection('web_orders')
    .snapshots().listen(
      (data) => userDocuments = data.documents
          // (data) => print('grower ${data.documents[0]['name']}')
    );
    int _documentsLength;
    
    if(userDocuments != null)
    _documentsLength = userDocuments.length;

    return new Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height:30.0),
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
          SizedBox(height: 20.0,),
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 20.0),
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: _allQuestionsDone?
                  Container()
                  :
                  StreamBuilder(
                    stream: Firestore.instance.collection('web_orders').document(userDocuments.elementAt(_currDocIndex).toString()).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        var userDocument = snapshot.data;
                      return _isCardScrollable
                          ? _questionCard(userDocument["message"])
                          : Transform.scale(
                              scale: 1/0.68,
                                                      child: TinderSwapCard(
                                orientation: AmassOrientation.BOTTOM,
                                totalNum: 6,
                                stackNum: 3,
                                swipeEdge: 3.0,
                                maxWidth: MediaQuery.of(context).size.width * 0.7,
                                maxHeight: MediaQuery.of(context).size.width * 1.0,
                                minWidth: MediaQuery.of(context).size.width * 0.6,
                                minHeight: MediaQuery.of(context).size.width * 0.9,
                                cardBuilder: (context, index) => _questionCard(userDocument["message"]),
                                // cardBuilder: (context, index) => Card(
                                //       child: Image.asset('${welcomeImages[index]}'),
                                //       color: Colors.white,
                                //     ),
                                cardController: controller = CardController(),
                                swipeUpdateCallback:
                                    (DragUpdateDetails details, Alignment align) {
                                  /// Get swiping card's alignment
                                  print(align.x);
                                  if(align.x > 0 && align.x <= 3.2){
                                    _isVisible = true;
                                    _isAccepted = true;
                                  }
                                  
                                  else if (align.x < 0) {
                                    _isVisible = true;
                                    _isAccepted = false;
                                    print('left');
                                    //Card is LEFT swiping
                                  } else if (align.x > 3.2) {
                                    //Card is RIGHT swiping
                                    // Future.delayed(
                                    //     const Duration(milliseconds: 500), () {});
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                new CameraApp(widget.cameras, userDocument["message"])));

                                    print('right');
                                    // _isVisible = false;
                                  }
                                },
                                swipeCompleteCallback:
                                    (CardSwipeOrientation orientation, int index) {
                                  /// Get orientation & index of swiped card!
                                   _isVisible = false;
                                   _currDocIndex++;
                                   if(_currDocIndex >= _documentsLength){
                                     setState(() {
                                       _allQuestionsDone = true;
                                     });
                                   }
                                   
                                }
                                ),
                );
                    }
                  ),
                ),
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
              IconButton(
                icon: Icon(Icons.chat),
                color: Colors.grey,
                iconSize: 30.0,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BroadcastPage()));
                },
              ),
              IconButton(
                icon: Icon(Icons.credit_card),
                color: Colors.amber,
                iconSize: 40.0,
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.person),
                color: Colors.grey,
                iconSize: 30.0,
                onPressed: () {
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context)=>XpertProfilePage(),
                  )
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
