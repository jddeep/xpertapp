import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xpert/profile_options/edit_price_page.dart';

class ChangePricePage extends StatefulWidget {
  final userDocID;
  final String questionPrice;
  final String wishPrice;
  final String shoutPrice;
  ChangePricePage(
      this.userDocID, this.questionPrice, this.wishPrice, this.shoutPrice);
  @override
  _ChangePricePageState createState() => _ChangePricePageState();
}

class _ChangePricePageState extends State<ChangePricePage> {
  Future<Null> _updateQuesPriceInDB(String newprice) async {
    await Firestore.instance
        .collection('xpert_master')
        .document(widget.userDocID)
        .updateData({'question_price': newprice}).whenComplete(() {
      print('Price updated');
    });
  }

  Future<Null> _updateWishPriceInDB(String newprice) async {
    await Firestore.instance
        .collection('xpert_master')
        .document(widget.userDocID)
        .updateData({'wish_price': newprice}).whenComplete(() {
      print('Price updated');
    });
  }

  Future<Null> _updateShoutPriceInDB(String newprice) async {
    await Firestore.instance
        .collection('xpert_master')
        .document(widget.userDocID)
        .updateData({'shout_price': newprice}).whenComplete(() {
      print('Price updated');
    });
  }

  Widget _currQuesPrice(String price) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        color: Colors.amber,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('ANSWERING A QUESTION', style: TextStyle(fontSize: 21.0)),
                CupertinoSwitch(
                  value: price == '0' ? false : true,
                  onChanged: (value) {
                    print(value);
                    if (!value) {
                      _updateQuesPriceInDB('0').then((onValue) {
                        print('NULL PRICe updated!');
                      });
                    }
                  },
                  activeColor: Colors.green,
                )
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.1),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '₹' + price + '/',
                        style: TextStyle(fontSize: 40.0),
                      ),
                      Text(
                        'answer',
                        style: TextStyle(fontSize: 21.0),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.17),
                  child: IconTheme(
                    data: IconThemeData(color: Colors.white),
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      iconSize: 40.0,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditPricePage(
                                      userDocID: widget.userDocID,
                                      pricetype: 'question',
                                    )));
                      },
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _currWishPrice(String price) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        color: Colors.amber,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('RECORDING A GREETING', style: TextStyle(fontSize: 21.0)),
                CupertinoSwitch(
                  value: price == '0' ? false : true,
                  onChanged: (value) {
                    print(value);
                    if (!value) {
                      _updateWishPriceInDB('0').then((onValue) {
                        print('NULL PRICe updated!');
                      });
                    }
                  },
                  activeColor: Colors.green,
                )
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.1),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '₹' + price + '/',
                        style: TextStyle(fontSize: 40.0),
                      ),
                      Text(
                        'wish',
                        style: TextStyle(fontSize: 21.0),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.23),
                  child: IconTheme(
                    data: IconThemeData(color: Colors.white),
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      iconSize: 40.0,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditPricePage(
                                      userDocID: widget.userDocID,
                                      pricetype: 'wish',
                                    )));
                      },
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _currShoutoutPrice(String price) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        color: Colors.amber,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('ENDORSING A BRAND', style: TextStyle(fontSize: 21.0)),
                CupertinoSwitch(
                  value: price == '0' ? false : true,
                  onChanged: (value) {
                    print(value);
                    if (!value) {
                      _updateShoutPriceInDB('0').then((onValue) {
                        print('NULL PRICe updated!');
                      });
                    }
                  },
                  activeColor: Colors.green,
                )
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.1),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '₹' + price + '/',
                        style: TextStyle(fontSize: 40.0),
                      ),
                      Text(
                        'brand',
                        style: TextStyle(fontSize: 21.0),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.3),
                  child: IconTheme(
                    data: IconThemeData(color: Colors.white),
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      iconSize: 40.0,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditPricePage(
                                      userDocID: widget.userDocID,
                                      pricetype: 'shout',
                                    )));
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Change Price'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection('xpert_master')
              .document(widget.userDocID)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();

            var userDoc = snapshot.data;

            print(userDoc["question_price"]);
            print(userDoc["wish_price"]);
            print(userDoc["shout_price"]);

            return ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: _currQuesPrice(userDoc["question_price"]),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: _currWishPrice(userDoc["wish_price"]),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: _currShoutoutPrice(userDoc["shout_price"]),
                ),
              ],
            );
          }),
    );
  }
}
