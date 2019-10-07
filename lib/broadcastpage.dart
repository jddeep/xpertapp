import 'package:flutter/material.dart';
import 'package:xpert/homepage.dart';

class BroadcastPage extends StatefulWidget {
  @override
  _BroadcastPageState createState() => _BroadcastPageState();
}

Widget _trainChatBotWidget() {
  return Container(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/xpert_icon.png')),
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black),
                    ),

                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                'Your XPERT ',
                                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                              ),
                              // SizedBox(width: 15.0,),
                              Container( // Can be a button
                              height: 15.0,
                              width: 45.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.amber),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text('Train bot', style: TextStyle(fontSize: 10.0)),
                              ),
                          ),
                            ],
                          ),
                        ),
                        Text('Chat with me to train me...')
                      ],
                    ),
                    SizedBox(width: 45.0,),
                    Container(
                      height: 20.0,
                      width: 20.0,
                      child: RawMaterialButton(
                        fillColor: Colors.amber,
                        shape: CircleBorder(),
                        elevation: 0.0,
                        child: Center(
                          child: Text('2'),
                        ),
                        onPressed: (){},
                      )
                    )
        ],
      ),
    ),
  );
}

class _BroadcastPageState extends State<BroadcastPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
          child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(opacity: 0.0),
                    bottom: TabBar(
              tabs: [
                    Tab(
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Text(
                              'Live feed'
                            ),
                          ),
                          IconTheme(
                            data: IconThemeData(color: Colors.red, size: 14.0),
                            child: Icon(Icons.fiber_manual_record),
                          )
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Text(
                              'Chats'
                            ),
                          ),
                          IconTheme(
                            data: IconThemeData(color: Colors.amber, size: 14.0),
                            child: Icon(Icons.fiber_manual_record),
                          )
                        ],
                      ),
                    ),
                  ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Scaffold(
                body: Column(
                  children: <Widget>[
                    _trainChatBotWidget(),
                    Divider(
                      height: 5.0,
                      color: Colors.grey,
                    ),
                    Expanded(
                                          child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconTheme(
                              data: IconThemeData(color: Colors.white, size: 90.0),
                              child: Icon(Icons.warning),
                            ),
                            SizedBox(height: 20.0),
Text(
                                      'TRAIN YOUR CHATBOT',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 35.0)
                                    ),
                            Text(
                              'Click on the broadcast tab to start training your chatbot.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey)
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.bottomEnd,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: FloatingActionButton(
                        backgroundColor: Colors.amber,
                        child: IconTheme(
                          data: IconThemeData(color: Colors.white, size: 50.0),
                          child: Icon(Icons.add)
                          ),
                        onPressed: (){},
                      ),
                                          ),
                    ),
                    Divider(
                      height: 5.0,
                      color: Colors.grey,
                    ),
                    Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.chat),
                color: Colors.amber,
                iconSize: 40.0,
                onPressed: () {
                  
                },
              ),
              IconButton(
                icon: Icon(Icons.credit_card),
                color: Colors.grey,
                iconSize: 30.0,
                onPressed: () {
                  Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => HomePage()
                  )
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.person),
                color: Colors.grey,
                iconSize: 30.0,
                onPressed: () {},
              ),
            ],
          )
                  ],
                ),
              ),
              ///
              Scaffold(
                body: Column(
                  children: <Widget>[
                    _trainChatBotWidget(),
                    Divider(
                      height: 5.0,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}