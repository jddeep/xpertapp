import 'dart:math';

// import 'package:animation_exp/SwipeAnimation/detail.dart';
import 'package:flutter/material.dart';

Positioned cardDemo(
    var userDocId,
    var orderDocId,
    var incomingData,
    double bottom,
    double right,
    double left,
    double cardWidth,
    double rotation,
    double skew,
    // bool isMandatory,
    // bool isOrange,
    // String type, //question, wishes, endorsement
    bool isAccepted,
    bool isRejected,
    bool isDoLater,
    BuildContext context,
    Function dismissImg,
    int flag,
    Function addImg,
    Function swipeRight,
    Function swipeLeft) {
  Size screenSize = MediaQuery.of(context).size;
  // print("Card");
  bool _isCardScrollable = false;
  bool _isPopularQuestion = false;
  var dropdownValue = '';
  bool _allQuestionsDone = false;
  print('accepted: ' +
      isAccepted.toString() +
      'REJECTED: ' +
      isRejected.toString());

  return new Positioned(
    bottom: (screenSize.height <= 640.0?screenSize.height*0.13:100.0) +bottom,
    right: flag == 0 ? right != 0.0 ? right : null : null,
    left: flag == 1 ? right != 0.0 ? right : null : null,
    // child: new Dismissible(
    //   key: new Key(new Random().toString()),
    //   crossAxisEndOffset: -0.3,
    //   onResize: () {
    //     //print("here");
    //     // setState(() {
    //     //   var i = data.removeLast();

    //     //   data.insert(0, i);
    //     // });
    // },
//       onDismissed: (DismissDirection direction) {
// //          _swipeAnimation();
//         if (direction == DismissDirection.endToStart){
//           print(rotation);
//           print(skew);
//           // _rejectUpdateData(orderDocId);
//           dismissImg(incomingData);
//         }
//         else{
//           print(rotation);
//           print(skew);
//           addImg(incomingData);
//         }
//       },
    child: new Transform(
      alignment: flag == 0 ? Alignment.bottomRight : Alignment.bottomLeft,
      //transform: null,
      transform: new Matrix4.skewX(skew),
      //..rotateX(-math.pi / rotation),
      child: new RotationTransition(
        turns: new AlwaysStoppedAnimation(
            flag == 0 ? rotation / 360 : -rotation / 360),
        // child: new Hero(
        //   tag: "img",
        child: new GestureDetector(
          onTap: () {
            // Navigator.push(
            //     context,
            //     new MaterialPageRoute(
            //         builder: (context) => new DetailPage(type: img)));
            // Navigator.of(context).push(new PageRouteBuilder(
            //       pageBuilder: (_, __, ___) => new DetailPage(type: img),
            //     ));
          },
          child: Stack(
            children: <Widget>[
              Opacity(
                opacity: isAccepted || isRejected ? 0.5 : 1.0,
                child: 
                    Card(
                      color: Colors.transparent,
                      elevation: 4.0,
                      child: new Container(
                        // alignment: Alignment.center,
                        width: screenSize.width * 0.9,
                        height: screenSize.height * 0.7,
                        // width: screenSize.width / 1.2 + cardWidth,
                        // height: screenSize.height / 1.5,
                        decoration: new BoxDecoration(
                          color: incomingData['type'] == 'orange'
                              ? Colors.amber
                              : Colors.white,
                          // color: new Color.fromRGBO(121, 114, 173, 1.0),
                          borderRadius: new BorderRadius.circular(15.0),
                        ),
                        child: incomingData['type'] =='bot_training'?
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top:8.0, left: 8.0, right: 8.0, bottom: 2.0),
                              width: screenSize.width * 0.9,
                              height: screenSize.height * 0.22,
                              decoration: new BoxDecoration(
                                color: Colors.amber,
                                borderRadius: new BorderRadius.only(
                                    topLeft: new Radius.circular(15.0),
                                    topRight: new Radius.circular(15.0)),
                                // image: img,
                              ),
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.only(left: screenSize.width * 0.17, top: screenSize.height * 0.045),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                                            'Have a',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 26.0,
                                                        ),
                                                      ),
                                                      Text(
                                                            'CHAT',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 45.0,
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                      ),

                                    ],
                                  ),
                                ),
                              ),
                                ),
                                
                                incomingData['type'] =='bot_training'?
                    Positioned(
                      left: screenSize.width * 0.07,
                      top: screenSize.height * 0.04,
                                          child: CircleAvatar(
                  backgroundImage: NetworkImage(incomingData['bot_pic_270x270']),
                  radius: 50.0,
                ),
                    ):Container(height: 0.0,)
                              ],
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                   children: <Widget>[
                                     Text(
                                       'Name',
                                       style: TextStyle(color: Colors.grey, fontSize: 17.0),

                                     ),
                                     Text(incomingData['bot_name'], style: TextStyle(color: Colors.black, fontSize: 22.0,fontWeight: FontWeight.bold)),
                                     Text(
                                       'Role',
                                       style: TextStyle(color: Colors.grey, fontSize: 17.0),

                                     ),
                                     Text(incomingData['bot_role']??'', style: TextStyle(color: Colors.black, fontSize: 18.0,fontWeight: FontWeight.bold)),
                                   Text(
                                       'Goal',
                                       style: TextStyle(color: Colors.grey, fontSize: 17.0),

                                     ),
                                     Text(incomingData['bot_goal'], style: TextStyle(color: Colors.black, fontSize: 18.0,fontWeight: FontWeight.bold))
                                   ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: screenSize.height/8,
                                    decoration: new BoxDecoration(
                                      color: incomingData['type'] == 'orange'
                                          ? Colors.amber
                                          : Colors.white,
                                      borderRadius: new BorderRadius.only(
                                          bottomLeft: new Radius.circular(15.0),
                                          bottomRight: new Radius.circular(15.0)),
                                      // image: img,
                                    ),
                                    padding: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 8.0, top: 30.0),
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: <Widget>[
                                                                        Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        IconTheme(
                                          data: IconThemeData(
                                              color:
                                                  incomingData['type'] == 'orange'
                                                      ? Colors.white
                                                      : Colors.black,
                                              size: 20.0),
                                          child: Icon(Icons.lightbulb_outline),
                                        ),
                                            Text(
                                              'XPERT TIP',
                                              style: TextStyle(
                                                  color: incomingData['type'] ==
                                                          'orange'
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 20.0),
                                            ),
                                      ],
                                    ),
                                    Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              child: Text(
                                                incomingData["tip"] ??
                                                    '',
                                                maxLines: 3,
                                                textAlign: TextAlign.start,
                                                softWrap: true,
                                                style: TextStyle(
                                                    color: incomingData['type'] ==
                                                            'orange'
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontSize: 14.0),
                                              ),
                                            ),
                                                                      ],
                                                                    ),
                            )
                          ],
                        )
                        : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Container(
                              padding: EdgeInsets.only(top:8.0, left: 8.0, right: 8.0, bottom: 2.0),
                              width: screenSize.width * 0.9,
                              // height: screenSize.height * 0.85,
                              // width: screenSize.width / 1.2 + cardWidth,
                              height: incomingData['type'] == 'question'?
                              screenSize.height * 0.12
                              :
                              screenSize.height * 0.22,
                              decoration: new BoxDecoration(
                                color: Colors.amber,
                                borderRadius: new BorderRadius.only(
                                    topLeft: new Radius.circular(15.0),
                                    topRight: new Radius.circular(15.0)),
                                // image: img,
                              ),
                              child: incomingData['type'] == 'question'
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 4.0),
                                      child: Align(
                                        alignment: AlignmentDirectional.centerStart,
                                        child: Text(
                                          "Answer",
                                          style: TextStyle(
                                              fontSize: 50.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ))
                                  : Center(
                                      child: Column(
                                        children: <Widget>[
                                          incomingData['type'] == 'wishes'
                                              ? Text(
                                                  'Record an wish for',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 26.0,
                                                  ),
                                                )
                                              : incomingData['type'] ==
                                                      'endorsement'
                                                  ? Text(
                                                      'Give a shoutout for',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 26.0,
                                                      ),
                                                    )
                                                  : Text(
                                                      incomingData[
                                                              "orange_headline1"] ??
                                                          'Null',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 26.0,
                                                      ),
                                                    ),

                                          incomingData['type'] == 'wishes'
                                              ? Text(
                                                  incomingData["for"] ??
                                                      'NUll', //earlier "name"
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 50.0,
                                                      fontWeight: FontWeight.bold),
                                                )
                                              : incomingData['type'] ==
                                                      'endorsement'
                                                  ? Text(
                                                      incomingData["for"]
                                                              .toString()
                                                              .toUpperCase() ??
                                                          'Null', //earlier "name"
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 50.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  : incomingData['type'] == 'orange'
                                                      ? Text(
                                                          incomingData[
                                                                      "orange_headline2"]
                                                                  .toString()
                                                                  .toUpperCase() ??
                                                              'Null',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 40.0,
                                                              fontWeight:
                                                                  FontWeight.bold),
                                                        )
                                                      : Text(
                                                          '') // 'question' has no second heading,
                                        ],
                                      ),
                                    ),
                            ),
                            incomingData["message_type"] == 'image'
                                ? Expanded(
                                    child: Container(
                                      height: 200.0,
                                      width: 200.0,
                                      child: Image(
                                        image:
                                            NetworkImage(incomingData["message"]),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  )
                                :incomingData["message_type"] == 'video'?
                                Expanded(flex:1, child:Container(height: 0.0,) ):
                                Expanded(
                                  flex: 1,
                                    child: Container(
                                      color: Colors.white,
                                      child: SingleChildScrollView(
                                          child: Container(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          incomingData['message'] ?? 'Null',
                                          textAlign: TextAlign.center,
                                          maxLines: 7,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      )),
                                    ),
                                  ),
                            incomingData['type'] == 'orange'
                                ? Container(
                                    height: 0.0,
                                  )
                                : incomingData["tip"].toString().isEmpty ||
                                        incomingData["tip"] == null
                                    ? Container(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0, left: 8.0, right: 4.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              _isPopularQuestion
                                                  ? Stack(
                                                      children: <Widget>[
                                                        CircleAvatar(
                                                          radius: 25.0,
                                                          backgroundImage: AssetImage(
                                                              'assets/profile_pic.jpg'),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                  left: 10.0),
                                                          child: CircleAvatar(
                                                            radius: 25.0,
                                                            backgroundImage: AssetImage(
                                                                'assets/profile_pic.jpg'),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                  left: 20.0),
                                                          child: CircleAvatar(
                                                            radius: 25.0,
                                                            backgroundImage: AssetImage(
                                                                'assets/profile_pic.jpg'),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Row(
                                                      children: <Widget>[
                                                        incomingData[
                                                                    "profile_image"] !=
                                                                null
                                                            ? CircleAvatar(
                                                                radius: 20.0,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        incomingData[
                                                                            "profile_image"]),
                                                              )
                                                            : Container(
                                                                height: 1.0,
                                                              ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            _isPopularQuestion
                                                                ? Text(
                                                                    'VOTED BY',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .grey,
                                                                        fontSize:
                                                                            22.0),
                                                                  )
                                                                : Text(
                                                                    incomingData['type'] ==
                                                                                'wishes' ||
                                                                            incomingData['type'] ==
                                                                                'endorsement'
                                                                        ? 'REQUESTED BY'
                                                                        : 'ASKED BY',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .grey,
                                                                        fontSize:
                                                                            22.0),
                                                                  ),
                                                            _isPopularQuestion
                                                                ? Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        '10,000 ',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .amber,
                                                                            fontWeight:
                                                                                FontWeight
                                                                                    .bold,
                                                                            fontSize:
                                                                                25.0),
                                                                      ),
                                                                      Text(
                                                                        'people',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontWeight:
                                                                                FontWeight
                                                                                    .bold,
                                                                            fontSize:
                                                                                20.0),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Text(
                                                                    incomingData[
                                                                            "name"] ??
                                                                        'Null',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            24.0),
                                                                  ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                              _isPopularQuestion
                                                  ? Container()
                                                  : Text(
                                                      '₹' +
                                                              incomingData["amount"]
                                                                  .toString() ??
                                                          '0',
                                                      style: TextStyle(
                                                          color: Colors.amber,
                                                          fontSize: 28.0),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 0.0,
                                      ),
                            incomingData["tip"].toString().isNotEmpty &&
                                    incomingData['tip'] != null
                                ? Container(
                                    height: screenSize.height/8,
                                    decoration: new BoxDecoration(
                                      color: incomingData['type'] == 'orange'
                                          ? Colors.amber
                                          : Colors.white,
                                      borderRadius: new BorderRadius.only(
                                          bottomLeft: new Radius.circular(15.0),
                                          bottomRight: new Radius.circular(15.0)),
                                      // image: img,
                                    ),
                                    padding: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 8.0, top: 30.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        IconTheme(
                                          data: IconThemeData(
                                              color:
                                                  incomingData['type'] == 'orange'
                                                      ? Colors.white
                                                      : Colors.black,
                                              size: 30.0),
                                          child: Icon(Icons.lightbulb_outline),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'XPERT TIP',
                                              style: TextStyle(
                                                  color: incomingData['type'] ==
                                                          'orange'
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 20.0),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              child: Text(
                                                incomingData["tip"] ??
                                                    '',
                                                maxLines: 3,
                                                textAlign: TextAlign.start,
                                                softWrap: true,
                                                style: TextStyle(
                                                    color: incomingData['type'] ==
                                                            'orange'
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontSize: 14.0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(height: 0.0),
                            ////
                          ],
                        ),
                      ),
                    ),
                    
              ),
              isAccepted
                  ? Positioned(
                      left: MediaQuery.of(context).size.width * 0.17,
                      top: MediaQuery.of(context).size.height * 0.3,
                      child: Container(
                        child: Center(
                          child: Image(
                              image: AssetImage('assets/accept_stamp.png')),
                        ),
                      ),
                    )
                  : isRejected
                      ? Positioned(
                          left: MediaQuery.of(context).size.width * 0.17,
                          top: MediaQuery.of(context).size.height * 0.3,
                          child: Container(
                            child: Center(
                              child: Image(
                                  image: incomingData['mandatory'].toString() ==
                                              'yes' ||
                                          isDoLater
                                      ? AssetImage('assets/do_later_stamp.png')
                                      : AssetImage('assets/reject_stamp.png')),
                            ),
                          ),
                        )
                      : Container(height: 0.0),
            ],
          ),
        ),
      ),
    ),
    // ),
    // ),
  );
}

//// Koley card code ////
// import 'dart:math';

// // import 'package:animation_exp/SwipeAnimation/detail.dart';
// import 'package:flutter/material.dart';

// Positioned cardDemo(
//     String text,
//     double bottom,
//     double right,
//     double left,
//     double cardWidth,
//     double rotation,
//     double skew,
//     BuildContext context,
//     Function dismissImg,
//     int flag,
//     Function addImg,
//     Function swipeRight,
//     Function swipeLeft) {
//   Size screenSize = MediaQuery.of(context).size;
//   // print("Card");
//    bool _isCardScrollable = false;
//   bool _isPopularQuestion = false;
//   var dropdownValue = '';
//   bool _allQuestionsDone = false;
//   // static bool _isVisible = false;
//   // static bool _isAccepted = false;
//   return new Positioned(
//     bottom: 100.0 + bottom,
//     right: flag == 0 ? right != 0.0 ? right : null : null,
//     left: flag == 1 ? right != 0.0 ? right : null : null,
//     child: new Dismissible(
//       key: new Key(new Random().toString()),
//       crossAxisEndOffset: -0.3,
//       onResize: () {
//         //print("here");
//         // setState(() {
//         //   var i = data.removeLast();

//         //   data.insert(0, i);
//         // });
//       },
//       onDismissed: (DismissDirection direction) {
// //          _swipeAnimation();
//         if (direction == DismissDirection.endToStart){
//           dismissImg(text);
//         }
//         else
//           addImg(text);
//       },
//       child: new Transform(
//         alignment: flag == 0 ? Alignment.bottomRight : Alignment.bottomLeft,
//         //transform: null,
//         transform: new Matrix4.skewX(skew),
//         //..rotateX(-math.pi / rotation),
//         child: new RotationTransition(
//           turns: new AlwaysStoppedAnimation(
//               flag == 0 ? rotation / 360 : -rotation / 360),
//           // child: new Hero(
//           //   tag: "img",
//             child:
//              new GestureDetector(
//               onTap: () {
//                 // Navigator.push(
//                 //     context,
//                 //     new MaterialPageRoute(
//                 //         builder: (context) => new DetailPage(type: img)));
//                 // Navigator.of(context).push(new PageRouteBuilder(
//                 //       pageBuilder: (_, __, ___) => new DetailPage(type: img),
//                 //     ));
//               },
//               child: Card(
//                 color: Colors.transparent,
//                 elevation: 4.0,
//                 child: new Container(
//                   alignment: Alignment.center,
//                   width: screenSize.width / 1.2 + cardWidth,
//                   height: screenSize.height / 1.7,
//                   decoration: new BoxDecoration(
//                     color: Colors.white,
//                     // color: new Color.fromRGBO(121, 114, 173, 1.0),
//                     borderRadius: new BorderRadius.circular(8.0),
//                   ),
//                   child: new Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       new Container(
//                         width: screenSize.width / 1.2 + cardWidth,
//                         height: screenSize.height / 8.0,
//                         decoration: new BoxDecoration(
//                           color: Colors.orange,
//                           borderRadius: new BorderRadius.only(
//                               topLeft: new Radius.circular(8.0),
//                               topRight: new Radius.circular(8.0)),
//                           // image: img,
//                         ),
//                         child: Center(
//                           child: Text(
//                             "Answer",
//                             style: TextStyle(fontSize: 40.0),
//                           ),
//                         ),
//                       ),
//                       Container(
//                           child: Center(
//                         child: Text(
//                           text,
//                           style: TextStyle(color: Colors.black),
//                         ),
//                       )),
//                       Container(
//                         child: Row(
//                       children: <Widget>[
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               bottom: 8.0, left: 8.0, right: 4.0),
//                           child: _isPopularQuestion
//                               ? Stack(
//                                   children: <Widget>[
//                                     CircleAvatar(
//                                       radius: 25.0,
//                                       backgroundImage:
//                                           AssetImage('assets/profile_pic.jpg'),
//                                     ),
//                                     Padding(
//                                       padding:
//                                           const EdgeInsets.only(left: 10.0),
//                                       child: CircleAvatar(
//                                         radius: 25.0,
//                                         backgroundImage: AssetImage(
//                                             'assets/profile_pic.jpg'),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding:
//                                           const EdgeInsets.only(left: 20.0),
//                                       child: CircleAvatar(
//                                         radius: 25.0,
//                                         backgroundImage: AssetImage(
//                                             'assets/profile_pic.jpg'),
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               : CircleAvatar(
//                                   radius: 20.0,
//                                   backgroundImage:
//                                       AssetImage('assets/profile_pic.jpg'),
//                                 ),
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             _isPopularQuestion
//                                 ? Text(
//                                     'VOTED BY',
//                                     style: TextStyle(
//                                         color: Colors.grey, fontSize: 12.0),
//                                   )
//                                 : Text(
//                                     'ASKED BY',
//                                     style: TextStyle(
//                                         color: Colors.grey, fontSize: 9.0),
//                                   ),
//                             _isPopularQuestion
//                                 ? Row(
//                                     children: <Widget>[
//                                       Text(
//                                         '10,000 ',
//                                         style: TextStyle(
//                                             color: Colors.amber,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 22.0),
//                                       ),
//                                       Text(
//                                         'people',
//                                         style: TextStyle(
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 14.0),
//                                       ),
//                                     ],
//                                   )
//                                 : Text(
//                                     'Anushka',
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 14.0),
//                                   ),
//                           ],
//                         ),
//                         _isPopularQuestion
//                             ? Container()
//                             : Padding(
//                                 padding: EdgeInsets.only(left: 44.0),
//                                 child: Text(
//                                   '₹2500',
//                                   style: TextStyle(
//                                       color: Colors.amber, fontSize: 20.0),
//                                 ),
//                               ),
//                       ],
//                     ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       // ),
//     ),
//   );
// }
