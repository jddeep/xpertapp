import 'package:flutter/material.dart';
import 'package:xpert/videoanswerscreen.dart';

class CreateQuestionPage extends StatefulWidget {

  final userDocId;

  CreateQuestionPage({this.userDocId});
  @override
  _CreateQuestionPageState createState() => _CreateQuestionPageState();
}

class _CreateQuestionPageState extends State<CreateQuestionPage> {

  var _questionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a question'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  autofocus: false,
                  minLines: 1,
                  style: TextStyle(fontSize: 25.0),
                  maxLines: 200,
                  controller: _questionController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Start typing a question you would like to answer here',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 25.0)
                  ),
                ),
              ),
            ),
            MaterialButton(
              minWidth: double.infinity,
              height: 60,
              color: Colors.amber,
              child: Text('RECORD ANSWER',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              onPressed: () {
                Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context)=> CameraExampleHome(incomingQuestion: _questionController.text, orderDocId: null, docId: widget.userDocId,))
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}