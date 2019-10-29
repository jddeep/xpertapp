import 'package:flutter/material.dart';

class UnderReviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Your Profile is under Review",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.amber, fontSize: 30.0),
              ),
              Text("We will get back to you shortly",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ],
          ),
      ),),
    );
  }
}