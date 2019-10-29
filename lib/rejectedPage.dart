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
              Text("We are sorry!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 26.0),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 50.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                child: Text("We  went through the information you provided. We regret to inform you that we feel we cannot accept you on-board",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 15.0),
                ),
              ),
            ],
          ),
      ),),
    );
  }
}