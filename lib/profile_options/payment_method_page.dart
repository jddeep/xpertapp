import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xpert/profile_options/edit_payment_method.dart';
import 'package:xpert/profile_options/transactions_page.dart';

class ManageBankPage extends StatefulWidget {
  final userDocId;
  final creatorDocId;
  ManageBankPage({this.userDocId, this.creatorDocId});
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
        body: StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection('xpert_master')
                .document(widget.userDocId)
                .collection('creator-settings')
                .document(widget.creatorDocId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Container(
                  color: Colors.white,
                );

              var creatorData = snapshot.data;

              return Column(
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Your funds to be transferred to',
                            style:
                                TextStyle(color: Colors.black, fontSize: 22.0),
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
                                        image: creatorData["payment_type"]
                                                    .toString()
                                                    .toLowerCase() ==
                                                'upi'
                                            ? AssetImage('assets/upi.png')
                                            : AssetImage('assets/paytm.jpeg'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Text(
                                        creatorData["payment_type"] ??
                                            'Not set',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22.0)),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditPayMethod(
                                                  userDocId: widget.userDocId,
                                                  creatorSetDocId:
                                                      widget.creatorDocId,
                                                )));
                                  },
                                  child: Text('Change',
                                      style: TextStyle(
                                          color: Colors.amber, fontSize: 20.0)),
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
                            creatorData["payment_details_id"] ??
                                'No payment id given',
                            style:
                                TextStyle(color: Colors.black, fontSize: 22.0),
                          ),
                          Divider(
                            height: 5.0,
                            color: Colors.grey,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TransactionsPage()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 8.0, 0.0, 0.0),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: 20.0,
                                    width: 20.0,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/view_transactions.png'))),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text('VIEW TRANSACTIONS',
                                        style: TextStyle(
                                            color: Colors.amber,
                                            fontSize: 19.0)),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }));
  }
}
