import 'package:flutter/material.dart';
import 'package:xpert/profile_options/edit_price_page.dart';

class ChangePricePage extends StatefulWidget {
  @override
  _ChangePricePageState createState() => _ChangePricePageState();
}

Widget _currPrice(){

  return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('₹500/', style: TextStyle(fontSize: 40.0,)),
                              Text('answer', style: TextStyle(fontSize: 26.0,))
                            ],
                          );
}

class _ChangePricePageState extends State<ChangePricePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
          child: Scaffold(
        appBar: AppBar(
          title: Text('Change Price'),
          bottom: TabBar(
            
            labelColor: Colors.white,
            indicatorColor: Colors.amber,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(color: Colors.black),
            tabs: <Widget>[
              Tab(
                 child: Text('Ask me anything'),
              ),
              Tab(
                child: Text('Invites & wishes'),
              ),
              Tab(
                child: Text('Brand Shoutouts'),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                    child: Container(
                      color: Colors.amber,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Current Price',
                            style: TextStyle(color: Colors.black)
                          ),
                          _currPrice(),
                          OutlineButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                            onPressed: (){
                              Navigator.push(context,
                              MaterialPageRoute(builder: (context)=>EditPricePage(oldPrice: _currPrice(),))
                              );
                            },
                            borderSide: BorderSide(color: Colors.blue),
                            child: Text('Change Price', style:TextStyle(color: Colors.black, fontSize: 20.0)),
                          ),
                        ],
                      ),
                    ),
                  ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10.0),
                  color: Colors.white,
                  child: Text('NOTE: your yearly income is Rs xxxxxx', style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),
                )
              ],
            ),
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }
}