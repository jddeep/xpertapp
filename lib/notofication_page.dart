import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';

class NotificationPage extends StatefulWidget {

  final userDocId;

  NotificationPage({this.userDocId});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  QuerySnapshot result;

  Widget _buildList(BuildContext context, DocumentSnapshot document) {
    var data = document.data;
    var unescape = new HtmlUnescape();
    var initials = 'X'; //default
    if(data['first_name'].toString().length != 0)
    initials = data['first_name'].toString()[0];

    if(data['reaction_type']=='downvote' || data['reaction_type']=='flag')
    return Container(height: 0.0,);
    
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
          children: <Widget>[
            CircularProfileAvatar(
          data['profile_image']??'', //sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
          radius: 25.0, // sets radius, default 50.0              
          backgroundColor: Colors.amber,
          initialsText: Text(
            initials.toUpperCase(),
            style: TextStyle(fontSize: 22.0, color: Colors.white),
          ),  // sets initials text, set your own style, default Text('')
          // borderColor: Colors.brown, // sets border color, default Colors.white
          // elevation: 5.0, // sets elevation (shadow of the profile picture), default value is 0.0
          // foregroundColor: Colors.brown.withOpacity(0.5), //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
          cacheImage: true, // allow widget to cache image against provided url
          
          showInitialTextAbovePicture: true, // setting it true will show initials text above profile picture, default false  
          ),
            // CircleAvatar(
            //   radius: 25.0,
            //   backgroundImage: document.data['profile_image']??AssetImage('assets/def_prof_pic.png'),
            //   backgroundColor: (document.data['profile_image']!=null && document.data['profile_image'].toString().isNotEmpty)?Colors.grey:Colors.transparent,
            // ),
            Container(
              padding: EdgeInsets.only(left: 4.0),
              width: MediaQuery.of(context).size.width * 0.8,
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(text: data['first_name'], style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: data['reaction_type']=='like'?' liked your answer to':
                data['reaction_type']=='view'? ' viewed your answer for':
                data['reaction_type']=='save'? ' saved your answer for':
                data['reaction_type']=='follow'? ' has started following you':
                data['reaction_type']=='comment'? ' shared a comment "${data['user_comment']}" for your answer to':
                data['reaction_type']=='share'? ' has shared your answer for':
                data['reaction_type']=='messaged'? ' chatted with your bot and said "${data['utterance']}"':
                data['reaction_type']=='chat'? ' has started a chat with your bot':''
                    ),
                    TextSpan(text: data['reaction_type']=='messaged'? '':
                data['reaction_type']=='chat'? '':' "'+unescape.convert(data['question'].toString()) + '"',
                style: TextStyle(fontWeight: FontWeight.bold)
                    )
                  ]
                ),
                // data['reaction_type']=='like'?data['first_name'] + ' liked your answer to "' + data['question']+'"':
                // data['reaction_type']=='view'?data['first_name'] + ' viewed your answer for "' + data['question']+'"':
                // data['reaction_type']=='save'?data['first_name'] + ' saved your answer for "' + data['question']+'"':
                // data['reaction_type']=='follow'?data['first_name'] + ' has started following you':
                // data['reaction_type']=='comment'?data['first_name'] + ' shared a comment "${data['user_comment']}" for your answer to ${data['question']}':
                // data['reaction_type']=='share'?data['first_name'] + ' has shared your answer for "' + data['question'] + '"':
                // data['reaction_type']=='messaged'?data['first_name'] + ' chatted with your bot and said "${data['utterance']}"':
                // data['reaction_type']=='chat'?data['first_name'] + ' has started a chat with your bot':'',
        // document.data['sender']+' gave a ' + document.data['reaction_type'] + ' to your answer to ' + '"' + document.data['question'] + '"',
        // style: TextStyle(color: Colors.black, fontSize: 16.0),
        maxLines: 4,
      ),
            )
          ],
        ),
    );
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

          if(notifications.length == 0)
          return Center(
            child: Text('No Notifications', style: TextStyle(color: Colors.grey, fontSize: 16.0)),
          );

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
