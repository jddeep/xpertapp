import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xpert/profile_options/edit_price_page.dart';

class ChangePricePage extends StatefulWidget {
  final userDocID;
  final String questionPrice;
  final String wishPrice;
  final String shoutPrice;
  ChangePricePage(this.userDocID, this.questionPrice, this.wishPrice, this.shoutPrice);
  @override
  _ChangePricePageState createState() => _ChangePricePageState();
}



class _ChangePricePageState extends State<ChangePricePage> {

  Widget _currQuesPrice(String price) {
  return Container(
    height: 120.0,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0)
      ),
      color: Colors.amber,
      elevation: 10.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'ANSWERING A QUESTION',
                style: TextStyle(fontSize: 18.0)
              ),
              CupertinoSwitch(
                value: true,
                onChanged: (value){
                  print(value);
                },
                activeColor: Colors.green,
                
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('₹'+price+'/',
                  style: TextStyle(fontSize: 25.0),
                  ),
                  Text('answer', style: TextStyle(fontSize: 16.0),),
                ],
              ),
              
              IconTheme(
                data: IconThemeData(color: Colors.white, size: 18.0),
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: (){
                    Navigator.push(context, 
                    MaterialPageRoute(builder: (context)=>EditPricePage(userDocID: widget.userDocID, pricetype: 'question',))
                    );
                  },
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
    height: 120.0,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0)
      ),
      color: Colors.amber,
      elevation: 10.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'RECORDING A GREETING',
                style: TextStyle(fontSize: 18.0)
              ),
              CupertinoSwitch(
                value: true,
                onChanged: (value){
                  print(value);
                },
                activeColor: Colors.green,
                
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('₹'+price+'/',
                  style: TextStyle(fontSize: 25.0),
                  ),
                  Text('wish', style: TextStyle(fontSize: 16.0),),
                ],
              ),
              
              IconTheme(
                data: IconThemeData(color: Colors.white, size: 18.0),
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: (){
                    Navigator.push(context, 
                    MaterialPageRoute(builder: (context)=>EditPricePage(userDocID: widget.userDocID, pricetype: 'wish',))
                    );
                  },
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
    height: 120.0,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0)
      ),
      color: Colors.amber,
      elevation: 10.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'ENDORSING A BRAND',
                style: TextStyle(fontSize: 18.0)
              ),
              CupertinoSwitch(
                value: true,
                onChanged: (value){
                  print(value);
                },
                activeColor: Colors.green,
                
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('₹'+price+'/',
                  style: TextStyle(fontSize: 25.0),
                  ),
                  Text('brand', style: TextStyle(fontSize: 16.0),),
                ],
              ),
              
              IconTheme(
                data: IconThemeData(color: Colors.white, size: 18.0),
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: (){
                    Navigator.push(context, 
                    MaterialPageRoute(builder: (context)=>EditPricePage(userDocID: widget.userDocID, pricetype: 'shout',))
                    );
                  },
                ),
              )
            ],
          )
        ],
      ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Change Price'
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: _currQuesPrice(widget.questionPrice),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: _currWishPrice(widget.wishPrice),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: _currShoutoutPrice(widget.shoutPrice),
          ),
        ],
      ),
    );
  }
}
