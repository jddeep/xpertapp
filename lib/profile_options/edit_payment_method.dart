import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xpert/profile_options/payment_method_page.dart';

class EditPayMethod extends StatefulWidget {
  final userDocId;
  final creatorSetDocId;
  EditPayMethod({this.userDocId, this.creatorSetDocId});

  @override
  _EditPayMethodState createState() => _EditPayMethodState();
}

class _EditPayMethodState extends State<EditPayMethod> {
  bool _upiCheckerVal = true;
  TextEditingController _upiIdController = new TextEditingController();

  Future<Null> _updatePaymentType(String paytype, String payid) async {
    await Firestore.instance
        .collection('xpert_master')
        .document(widget.userDocId)
        .collection('creator-settings')
        .document(widget.creatorSetDocId)
        .updateData({
      'payment_type': paytype,
      'payment_details_id': payid ?? ''
    }).whenComplete(() {
      print('Payment Type updated');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('Manage bank page: ' + widget.userDocId + " ; " + widget.creatorSetDocId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Edit Payment Method'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Your funds to be transferred to',
                    style: TextStyle(color: Colors.black, fontSize: 22.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Theme(
                          data: ThemeData(
                            unselectedWidgetColor: Colors.black
                          ),
                                                  child: Checkbox(
                            value: _upiCheckerVal,
                            onChanged: (value) {
                              setState(() {
                                _upiCheckerVal = value;
                              });
                            },
                            activeColor: Colors.amber,
                            checkColor: Colors.white,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 8.0),
                          height: 30.0,
                          child: Image(
                            image: AssetImage('assets/upi.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text('UPI ID',
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0))
                      ],
                    ),
                  ),
                  TextField(
                    controller: _upiIdController,
                    autofocus: false,
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Enter your UPI ID',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Divider(
                    height: 5.0,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Theme(
                          data: ThemeData(
                            unselectedWidgetColor: Colors.black
                          ),
                                                  child: Checkbox(
                            value: !_upiCheckerVal,
                            onChanged: (value) {
                              setState(() {
                                _upiCheckerVal = !value;
                              });
                            },
                            activeColor: Colors.amber,
                            checkColor: Colors.white,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 8.0),
                          height: 30.0,
                          child: Image(
                            image: AssetImage('assets/paytm.jpeg'),
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text('Paytm',
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0))
                      ],
                    ),
                  ),
                  Text('NOTE:',
                      style: TextStyle(
                          color: Colors.black,)),
                  Text('Funds will be transferred bi-weekly to your specified account and will be net of our commission. For payment related queries contact your account manager or email us at finance@xpert.tv',
                      style: TextStyle(color: Colors.black, fontSize: 12.0))
                ],
              ),
            ),
          ),
          MaterialButton(
            minWidth: double.infinity,
            height: 60,
            color: Colors.amber,
            child: Text('Continue',
                style: TextStyle(color: Colors.white, fontSize: 22)),
            onPressed: () {
              if (_upiCheckerVal)
                _updatePaymentType('upi', _upiIdController.text).then((onValue){
                  Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context)=> ManageBankPage(userDocId: widget.userDocId, creatorDocId: widget.creatorSetDocId,))
                  );
                });
              else
                _updatePaymentType('paytm', null).then((onValue){
                  Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context)=> ManageBankPage(userDocId: widget.userDocId, creatorDocId: widget.creatorSetDocId,))
                  );
                });
            },
          ),
        ],
      ),
    );
  }
}
