import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.5,
          child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text('Discover your Impact'),
              ),
              body: Container(
                // child: ListView(
                //   children: <Widget>[
                //     ListTile(
                //       title: Text('Duhita liked your answer',
                //           style: TextStyle(color: Colors.black)),
                //     ),
                //     ListTile(
                //       title: Text('Duhita liked your answer',
                //           style: TextStyle(color: Colors.black)),
                //     ),
                //   ],
                // ),
              )),
        ),
        Align(
          alignment: AlignmentDirectional.center,
          child: IconTheme(
            data: IconThemeData(color: Colors.white, size: 150.0),
            child: Icon(Icons.lock_outline),
          ),
        )
      ],
    );
  }
}
