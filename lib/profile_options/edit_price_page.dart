import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xpert/xpert_profile_page.dart';

class EditPricePage extends StatefulWidget {
  final userDocID;
  final pricetype;
  EditPricePage({this.userDocID, this.pricetype});
  @override
  _EditPricePageState createState() => _EditPricePageState();
}

class _EditPricePageState extends State<EditPricePage> {
  TextEditingController _priceTextController = TextEditingController();

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

  Widget _currPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('₹', style: TextStyle(fontSize: 40.0, color: Colors.black)),
        Container(
          width: 200.0,
          child: TextField(
            controller: _priceTextController,
            autofocus: false,
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.black, fontSize: 24.0),
            decoration: InputDecoration.collapsed(
              hintText: 'Enter new price',
              hintStyle: TextStyle(color: Colors.grey),

              // border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 5.0), ),
            ),
          ),
        ),
        Text('/answer', style: TextStyle(fontSize: 26.0, color: Colors.grey))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Set Price For Answers'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: Container(
            child: Column(
              children: <Widget>[
                _currPrice(),
                Divider(
                  color: Colors.grey,
                  height: 5.0,
                )
              ],
            ),
          )),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.grey,
                  )),
              child: Row(
                children: <Widget>[
                  IconTheme(
                    data: IconThemeData(color: Colors.amber, size: 25.0),
                    child: Icon(Icons.lightbulb_outline),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'XPERT TIP',
                        style: TextStyle(
                            color: Colors.amber, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'This is a demo tip',
                        // company["tip"],
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            minWidth: double.infinity,
            height: 60,
            color: Colors.amber,
            child: Text('Update Price',
                style: TextStyle(color: Colors.white, fontSize: 20)),
            onPressed: () {
              print('Doc ID Price page: ' +
                  widget.userDocID.toString() +
                  'text: ' +
                  _priceTextController.text);
              if (widget.pricetype.toString() == 'question') {
                _updateQuesPriceInDB(_priceTextController.text).then((value) {
                  Navigator.pop(context);
                });
              } else if (widget.pricetype.toString() == 'wish') {
                _updateWishPriceInDB(_priceTextController.text).then((value) {
                  Navigator.pop(context);
                });
              } else {
                _updateShoutPriceInDB(_priceTextController.text).then((value) {
                  Navigator.pop(context);
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
