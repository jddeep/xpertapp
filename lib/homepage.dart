import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:xpert/broadcastpage.dart';
import 'package:xpert/videoanswerscreen.dart';

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
  bool _isPopularQuestion = true;
  var dropdownValue = '';
  // The question incoming goes here below
  String _questionAsked =
      'If the onChanged callback is null or the list of items is null then the dropdown button will be disabled, i.e. its arrow will be displayed in grey and it will not respond to input. A disabled button will display the disabledHint widget if it is non-null.';

  Widget _questionCard() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_isCardScrollable)
            _isCardScrollable = false;
          else
            _isCardScrollable = true;
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
                  color: Colors.amber,
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
              height: 20,
            ),
            _isCardScrollable
                ? SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _questionAsked,
                        style: TextStyle(color: Colors.black, fontSize: 18.0),
                      ),
                    ))
                : Expanded(
                    child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _questionAsked,
                      style: TextStyle(color: Colors.black, fontSize: 18.0),
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
                                          AssetImage('assets/celeb_banner.png'),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: CircleAvatar(
                                        radius: 25.0,
                                        backgroundImage: AssetImage(
                                            'assets/celeb_banner.png'),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: CircleAvatar(
                                        radius: 25.0,
                                        backgroundImage: AssetImage(
                                            'assets/celeb_banner.png'),
                                      ),
                                    ),
                                  ],
                                )
                              : CircleAvatar(
                                  radius: 25.0,
                                  backgroundImage:
                                      AssetImage('assets/celeb_banner.png'),
                                ),
                        ),
                        Column(
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
                                        color: Colors.grey, fontSize: 12.0),
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
                                            fontSize: 16.0),
                                      ),
                                    ],
                                  )
                                : Text(
                                    'Anushka',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                          ],
                        ),
                        _isPopularQuestion
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.only(left: 80.0),
                                child: Text(
                                  '₹2500',
                                  style: TextStyle(
                                      color: Colors.amber, fontSize: 26.0),
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

  @override
  Widget build(BuildContext context) {
    CardController controller; //Use this to trigger swap.

    return new Scaffold(
      appBar: new AppBar(
        title: Text('XpertTV'),
      ),
      body: Column(
        children: <Widget>[
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
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 20.0),
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: _isCardScrollable
                      ? _questionCard()
                      : TinderSwapCard(
                          orientation: AmassOrientation.BOTTOM,
                          totalNum: 6,
                          stackNum: 3,
                          swipeEdge: 3.0,
                          maxWidth: MediaQuery.of(context).size.width * 0.9,
                          maxHeight: MediaQuery.of(context).size.width * 1.0,
                          minWidth: MediaQuery.of(context).size.width * 0.8,
                          minHeight: MediaQuery.of(context).size.width * 0.9,
                          cardBuilder: (context, index) => _questionCard(),
                          // cardBuilder: (context, index) => Card(
                          //       child: Image.asset('${welcomeImages[index]}'),
                          //       color: Colors.white,
                          //     ),
                          cardController: controller = CardController(),
                          swipeUpdateCallback:
                              (DragUpdateDetails details, Alignment align) {
                            /// Get swiping card's alignment
                            if (align.x < 0) {
                              print('left');
                              //Card is LEFT swiping
                            } else if (align.x > 5) {
                              //Card is RIGHT swiping
                              Future.delayed(
                                  const Duration(milliseconds: 500), () {});
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          new CameraApp(widget.cameras)));

                              print('right');
                            }
                          },
                          swipeCompleteCallback:
                              (CardSwipeOrientation orientation, int index) {
                            /// Get orientation & index of swiped card!
                          }),
                ),
                SizedBox(
                  height: 8.0,
                ),
                _isCardScrollable
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
                icon: Icon(Icons.network_check),
                color: Colors.grey,
                iconSize: 30.0,
                onPressed: () {},
              ),
            ],
          )
        ],
      ),
    );
  }
}
