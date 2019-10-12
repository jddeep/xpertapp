import 'package:flutter/material.dart';
import 'package:xpert/homepage.dart';

class DetailQuestionPage extends StatefulWidget {
  final incomingQuestion;
  DetailQuestionPage({this.incomingQuestion});
  @override
  _DetailQuestionPageState createState() => _DetailQuestionPageState();
}

class _DetailQuestionPageState extends State<DetailQuestionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(

            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top:20.0, left: 8.0, right: 8.0),
                child: Text(
                  widget.incomingQuestion,
                  style: TextStyle(color: Colors.black, fontSize: 24.0),

                ),
              ),
            ),
          ),
          MaterialButton(
            minWidth: double.infinity,
            height: 60,
            color: Colors.amber,
            child: Text('Proceed',
                style: TextStyle(color: Colors.white, fontSize: 20)),
            onPressed: () {
//             verifyPhone();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => new HomePage(),
                  ));
            },
          ),
        ],

      ),
    );
  }
}
