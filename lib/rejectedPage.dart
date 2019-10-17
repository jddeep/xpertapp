import 'package:flutter/material.dart';

class RejectedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Sorry, your profile is rejected :(",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.amber, fontSize: 30.0),
              ),
              Text("Please feel free to share this app with other potential experts.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ],
          ),
      ),),
    );
  }
}