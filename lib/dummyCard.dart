import 'package:flutter/material.dart';

Positioned cardDemoDummy(var incomingData, double bottom, double right, double left,
    double cardWidth, double rotation, double skew, BuildContext context) {
  Size screenSize = MediaQuery.of(context).size;
  // Size screenSize=(500.0,200.0);
  // print("dummyCard");
  bool _isCardScrollable = false;
  bool _isPopularQuestion = false;
  var dropdownValue = '';
  bool _allQuestionsDone = false;
  return new Positioned(
    bottom: 100.0 + bottom,
    // right: flag == 0 ? right != 0.0 ? right : null : null,
    //left: flag == 1 ? right != 0.0 ? right : null : null,
    child: new Card(
                color: Colors.transparent,
                elevation: 4.0,
                child: new Container(
                  alignment: Alignment.center,
                  width: screenSize.width / 1.2 + cardWidth,
                  height: screenSize.height / 1.7,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    // color: new Color.fromRGBO(121, 114, 173, 1.0),
                    borderRadius: new BorderRadius.circular(15.0),
                  ),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.all(8.0),
                        width: screenSize.width / 1.2 + cardWidth,
                        height: screenSize.height / 8.0,
                        decoration: new BoxDecoration(
                          color: incomingData['type']=='orange'?Colors.orange:Colors.amber,
                          borderRadius: new BorderRadius.only(
                              topLeft: new Radius.circular(15.0),
                              topRight: new Radius.circular(15.0)),
                          // image: img,
                        ),
                        child: incomingData['type']=='question'?Padding(padding: EdgeInsets.only(top: 8.0),
                                child:Text(
                                  "Answer",
                                  style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                                )):Center(
                            child: Column(
                              
                              children: <Widget>[
                                incomingData['type']=='wishes'?Text('Record an wish for',
                                textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,),
                                ):incomingData['type']=='endorsement'?Text(
                          'Give a shoutout for',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,),
                        ):Text(
                        incomingData["orange_headline1"]??'Null',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,),
                      ),

                      incomingData['type']=='wishes' || incomingData['type']=='endorsement'?Text(
                          incomingData["for"]??'NUll', //earlier "name"
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ):incomingData['type']=='orange'?Text(
                        incomingData["orange_headline2"]?? 'Null',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold),
                      ):Text('') // 'question' has no second heading,
                      
                              ],
                            ),
                          ),
                      ),
                      incomingData["message_type"]=='image'?
              Container(
                height: 200.0,
                width: 200.0,
                child: Image(
                  image: NetworkImage(incomingData["message"]),
                  fit: BoxFit.contain,
                ),
              ):
                      Expanded(child:Container(
                        padding: EdgeInsets.all(8.0),
                          child: Text(
                          incomingData['message']??'Null',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w300),
                        ),)),
                      incomingData["tip"].toString().isEmpty || incomingData["tip"] == null?Container(
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
                                                  incomingData["profile_image"]!=null?CircleAvatar(
                                                    radius: 20.0,
                                                    backgroundImage: NetworkImage(
                                                        incomingData["profile_image"]),
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
                                                                  fontSize: 18.0),
                                                            )
                                                          : Text(
                                                              incomingData['type']=='wishes' || incomingData['type']=='endorsement'?
                                                                    'REQUESTED BY':'ASKED BY',
                                                              style: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontSize: 18.0),
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
                                                                      fontSize: 16.0),
                                                                ),
                                                              ],
                                                            )
                                                          : Text(
                                                              incomingData["name"]??'Null',
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontWeight:
                                                                      FontWeight.bold,
                                                                  fontSize: 20.0),
                                                            ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              _isPopularQuestion
                                                  ? Container()
                                                  : Text(
                                                      '₹'+incomingData["amount"].toString()??'Null',
                                                      style: TextStyle(
                                                          color: Colors.amber,
                                                          fontSize: 24.0),
                                                    ),
                                  ],
                                ),
                              ),
                          ): Container(height: 0.0),
                      incomingData["tip"].toString().isNotEmpty?Container(
                    height: 70.0,
                      decoration: new BoxDecoration(
                          color: incomingData['type']=='orange'?Colors.orange:Colors.white,
                          borderRadius: new BorderRadius.only(
                              bottomLeft: new Radius.circular(15.0),
                              bottomRight: new Radius.circular(15.0)),
                          // image: img,
                        ),
                      padding: EdgeInsets.all(6.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              IconTheme(
                                data: IconThemeData(color: incomingData['type']=='orange'?Colors.white:Colors.black, size: 20.0),
                                child: Icon(Icons.lightbulb_outline),
                              ),
                              
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Text(
                                                                'XPERT TIP',
                                                                style: TextStyle(
                                                                    color: incomingData['type']=='orange'?Colors.white:Colors.black,fontSize: 20.0),
                                                              ),
                                                              Container(
                                                                        width: MediaQuery.of(context).size.width*0.8,
                                                                        child: Text(
                                                                          incomingData["tip"]??'This is a demo tip',
                                                                          maxLines: 3,
                                                                          textAlign: TextAlign.start,
                                                                          softWrap: true,
                                                                          style: TextStyle(
                                                                              color: incomingData['type']=='orange'?Colors.white:Colors.black, fontSize: 15.0),
                                                                        ),
                                                                      ),
                                                      ],
                                                    ),
                            ],
                          ),
                        ):Container(height: 0.0),
                    ////
                    ],
                  ),
                ),
              ),
  );
}