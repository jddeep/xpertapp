import 'package:flutter/material.dart';

class TransactionsPage extends StatefulWidget {
  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: Center(
        child: Text(
          'Once active, the payments made to you would show up here.',
          style: TextStyle(color: Colors.black, fontSize: 26.0),
          textAlign: TextAlign.center,
        ),
      ),
      // body: ListView(
      //   children: <Widget>[
      //     ListTile(
      //       leading: IconTheme(
      //         data: IconThemeData(color: Colors.black),
      //         child: Icon(Icons.attach_money),
      //       ),
      //       title: Column(
      //         children: <Widget>[
      //           Text('Recording an invite', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
      //           Text('01 October 2019', style: TextStyle(color: Colors.grey))
      //         ],
      //       ),
      //       trailing: Text(
      //         '₹500',
      //         style: TextStyle(color: Colors.amber, fontSize: 18.0)
      //       ),
      //     ),
      //     ListTile(
      //       leading: IconTheme(
      //         data: IconThemeData(color: Colors.black),
      //         child: Icon(Icons.attach_money),
      //       ),
      //       title: Column(
      //         children: <Widget>[
      //           Text('Answering a question', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
      //           Text('01 October 2019', style: TextStyle(color: Colors.grey))
      //         ],
      //       ),
      //       trailing: Text(
      //         '₹500',
      //         style: TextStyle(color: Colors.amber, fontSize: 18.0)
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
