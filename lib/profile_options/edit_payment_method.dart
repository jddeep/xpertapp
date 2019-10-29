import 'package:flutter/material.dart';

class EditPayMethod extends StatefulWidget {
  @override
  _EditPayMethodState createState() => _EditPayMethodState();
}

class _EditPayMethodState extends State<EditPayMethod> {
  bool _upiCheckerVal = true;
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
              child: 
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Your funds to be transferred to',
                            style: TextStyle(color: Colors.black, fontSize: 18.0),),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Checkbox(
                                value: _upiCheckerVal,
                                onChanged: (value){
                                  setState(() {
                                    _upiCheckerVal = value;
                                  });
                                  
                                },
                                activeColor: Colors.amber,
                                checkColor: Colors.white,
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 8.0),
                                height: 30.0,
                                child: Image(
                                  image: AssetImage('assets/welcome0.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Text('UPI ID', style: TextStyle(color: Colors.black))
                            ],
                          ),
                        ),
                        TextField(
                          autofocus: false,
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration.collapsed(hintText: 'Enter your UPI ID',
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
                              Checkbox(
                                value: !_upiCheckerVal,
                                onChanged: (value){
                                  setState(() {
                                    _upiCheckerVal = !value;
                                  });
                                  
                                },
                                activeColor: Colors.amber,
                                checkColor: Colors.white,
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 8.0),
                                height: 30.0,
                                child: Image(
                                  image: AssetImage('assets/welcome1.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Text('Paytm', style: TextStyle(color: Colors.black))
                            ],
                          ),
                          
                        ),
                        Text('NOTE:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        Text('Funds will be...', style: TextStyle(color: Colors.black))
                      ],
                    ),
            ),
          ),
           MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          color: Colors.amber,
                          child: Text('Continue',
                              style: TextStyle(color: Colors.white, fontSize: 20)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
        ],
      ),
    );
  }
}