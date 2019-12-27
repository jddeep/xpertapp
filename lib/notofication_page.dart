import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {

  final userDocId;

  NotificationPage({this.userDocId});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  QuerySnapshot result;

  Widget _buildList(BuildContext context, DocumentSnapshot document) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              radius: 25.0,
              backgroundImage: document.data['profile_image']??AssetImage('assets/def_prof_pic.png'),
              backgroundColor: (document.data['profile_image']!=null && document.data['profile_image'].toString().isNotEmpty)?Colors.grey:Colors.transparent,
            ),
            Container(
              padding: EdgeInsets.only(left: 4.0),
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(document.data['sender']+' gave a ' + document.data['reaction_type'] + ' to your answer to ' + '"' + document.data['question'] + '"',
        style: TextStyle(color: Colors.black, fontSize: 16.0),
        maxLines: 4,
      ),
            )
          ],
        ),
    );
    //   subtitle: Text(document.data['sender']+' gave a ' + document.data['reaction_type'] + ' to your answer to ' + '"' + document.data['question'] + '"',
    //   style: TextStyle(color: Colors.black, fontSize: 17.0),
      
    //   // subtitle: Text(document['body']),
    // );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text('Discover your Impact'),
              ),
              body: StreamBuilder(
        stream: Firestore.instance
        .collection('user_activity')
        .where('xpert_slug', isEqualTo: widget.userDocId)
        .snapshots(),
        // .snapshots(),
        //print an integer every 2secs, 10 times
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Container(
                height: 40.0,
                width: 40.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                ),
              ),
            );
          }
          List<DocumentSnapshot> notifications = snapshot.data.documents.toList();

          print('Notification data: ' +notifications[0].data.toString());
          return ListView.builder(
            // itemExtent: 80.0,
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return _buildList(context, notifications[index]);
            },
          );
        },
      ),
    );
    // return Stack(
    //   children: <Widget>[
    //     Opacity(
    //       opacity: 0.5,
    //       child: Scaffold(
    //           backgroundColor: Colors.white,
    //           appBar: AppBar(
    //             title: Text('Discover your Impact'),
    //           ),
    //           body: Container(
    //             margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.17),
    //             decoration: BoxDecoration(
    //               image: DecorationImage(image: AssetImage(
    //                 'assets/notification_screen.png',
    //               ),
    //               fit: BoxFit.contain
    //               )
    //             ),
    //             // child: ListView(
    //             //   children: <Widget>[
    //             //     ListTile(
    //             //       title: Text('Duhita liked your answer',
    //             //           style: TextStyle(color: Colors.black)),
    //             //     ),
    //             //     ListTile(
    //             //       title: Text('Duhita liked your answer',
    //             //           style: TextStyle(color: Colors.black)),
    //             //     ),
    //             //   ],
    //             // ),
    //           )),
    //     ),
    //     Align(
    //       alignment: AlignmentDirectional.center,
    //       child: IconTheme(
    //         data: IconThemeData(color: Colors.white, size: 150.0),
    //         child: Icon(Icons.lock_outline),
    //       ),
    //     )
    //   ],
    // );
  }
}
