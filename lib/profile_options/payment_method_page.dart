import 'package:flutter/material.dart';
import 'package:xpert/profile_options/edit_payment_method.dart';
import 'package:xpert/profile_options/transactions_page.dart';

class ManageBankPage extends StatefulWidget {
  @override
  _ManageBankPageState createState() => _ManageBankPageState();
}

class _ManageBankPageState extends State<ManageBankPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Payment Method'),
      ),
      body: Column(
        children: <Widget>[
          Container(
              child: 
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Your funds to be transferred to',
                            style: TextStyle(color: Colors.black, fontSize: 18.0),

                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(right: 5.0),
                                      height: 30.0,
                                      child: Image(
                                        image: AssetImage('assets/welcome0.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Text('UPI ID', style:TextStyle(color: Colors.black, fontSize: 16.0)),
                                  ],
                                ),
                                
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context,
                                    MaterialPageRoute(builder: (context)=> EditPayMethod())
                                    );
                                  },
                                  child: Text(
                                    'Change',
                                    style: TextStyle(color: Colors.amber)
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            height: 5.0,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'jaideep45@okaxis',
                            style: TextStyle(color: Colors.black),
                          ),
                          Divider(
                            height: 5.0,
                            color: Colors.grey,
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context,
                              MaterialPageRoute(builder: (context)=>TransactionsPage())
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20.0, 8.0, 0.0, 0.0),
                              child: Text(
                                'VIEW TRANSACTIONS',
                                style: TextStyle(color: Colors.amber, fontSize: 20.0)
                              ),
                            ),
                          )
                        ],
                      ),
                  ),
            ),
        ],
          
      )
    );
  }
}
