import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xpert/profile_options/referral_page.dart';
import 'profile_options/change_price_page.dart';
import 'package:share/share.dart';
import 'profile_options/payment_method_page.dart';
import 'profile_options/xpert_settings_page.dart';

class XpertProfilePage extends StatefulWidget {
  final user;
  final String title;
  XpertProfilePage(this.user, this.title);
  @override
  _XpertProfilePageState createState() => _XpertProfilePageState();
}

class _XpertProfilePageState extends State<XpertProfilePage> {
  Future<File> imageFile;
  FileImage profile_pic;
  String userName;
  String userShortBio;
  String userLongBio;
  String userRating;
  String profImgURL;
  String earned;
  String requests;
  String chats;
  var questionPrice;
  var wishPrice;
  var shoutoutPrice;

  DocumentSnapshot _userDoc;

  @override
  void initState(){
    super.initState();
    _fetchUserProfileData().then((userDoc){
      setState(() {
      // userName = userDoc["name"];
      // userShortBio = userDoc["short_bio"];
      // userLongBio = userDoc["long_bio"];
      // userRating = userDoc["rating"];
      // profImgURL = userDoc["profile_image"];
      this._userDoc = userDoc;
      });
    });
  }

  Future<DocumentSnapshot> _fetchUserProfileData() async{
   DocumentSnapshot userDoc;
    await Firestore.instance.collection('xpert_master')
    .document(widget.title) // bhuvan-bam
    .get().then((_userDoc){
      userName = _userDoc["xpert"];
      userShortBio = _userDoc["short_bio"];
      userLongBio = _userDoc["long_bio"];
      profImgURL = _userDoc["profile_image"];
      questionPrice = _userDoc["question_price"];
      wishPrice = _userDoc["wish_price"];
      shoutoutPrice = _userDoc["shout_price"];
      userDoc = _userDoc;
    });
    await Firestore.instance.collection('xpert_master')
    .document(widget.title) // bhuvan-bam
    .collection('creator_settings')
    .getDocuments()
    .then((_userDoc){
      userRating = _userDoc.documents[0].data["rating"];
      earned = _userDoc.documents[0].data["earned"];
      requests =  _userDoc.documents[0].data["requests"];
      chats = _userDoc.documents[0].data["chats"];
    });
    return userDoc;
  }


  //Open gallery
  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return CircleAvatar(
            radius: 30.0,
            backgroundImage: FileImage(File(snapshot.data.path)),
          );
        } else {
          return CircleAvatar( // default img when no dp is set.
            radius: 30.0,
            backgroundImage: AssetImage('assets/my_prof_pic.jpg'),
            // backgroundImage: NetworkImage('https://avatars2.githubusercontent.com/u/43133646?s=400&v=4'),
          );
        }
      },
    );
  }

  Widget _showUserImagefromURL() {
    if(profImgURL != null){
      return CircleAvatar(
        radius: 30.0,
        backgroundImage: NetworkImage(profImgURL),
      );
    }else{
      return showImage();
    }
  }

  // Widget showImage() {
  //   return FutureBuilder<File>(
  //     future: imageFile,
  //     builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
  //       if (snapshot.connectionState == ConnectionState.done &&
  //           snapshot.data != null) {
  //             setState(() {
  //               profile_pic = FileImage(File(snapshot.data.path));
  //             });
  //         return Image.file(
  //           snapshot.data,
  //           width: 300,
  //           height: 300,
  //         );
  //       } else if (snapshot.error != null) {
  //         return Image(
  //           image: NetworkImage('https://avatars2.githubusercontent.com/u/43133646?s=400&v=4'),
  //         );
  //               } else {
  //         return Image(
  //           image: NetworkImage('https://avatars2.githubusercontent.com/u/43133646?s=400&v=4'),
  //         );
  //       }
  //     },
  //   );
  // }

  // Future<Image> _returnImage() async{
  //   var retImage;
  //   await _showImage().then((onValue)=> retImage = onValue);
  //   return retImage;
  // }

  @override
  Widget build(BuildContext context) {
    if(_userDoc == null){
      return Center(
                                      child: Container(
                                        height: 50.0,
                                        width: 50.0,
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.amber,
                                        ),
                                      ),
                                    );
    } else
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              pickImageFromGallery(ImageSource.gallery);
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 14.0, top: 10.0),
            child: Row(
              children: <Widget>[
                _showUserImagefromURL(),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                          userName??'Please set up one',
                          // userName,
                            // 'Jaideep Prasad',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 26.0),
                          ),
                          Row(
                        children: <Widget>[
                          IconTheme(
                            data:
                                IconThemeData(color: Colors.amber, size: 10.0),
                            child: Icon(Icons.star),
                          ),
                          Text(userRating??'0.0')
                        ],
                      )
                        ],
                      ),
                      Text(userShortBio??'Please set up one',
                        // 'Software Developer', 
                      textAlign: TextAlign.start),
                      Row(
                        children: <Widget>[
                          Text('www.xpert.tv/cr/jaideep-prasad',
                          textAlign: TextAlign.start),
                          IconTheme(
                            data: IconThemeData(color: Colors.white),
                            child: IconButton(
                              onPressed: (){},
                              icon: Icon(Icons.content_copy),
                            ),
                          )
                        ],
                      ),
                     
                      
                    ],
                  ),
                )
              ],
            ),
          ),
           MaterialButton(
             
             minWidth: MediaQuery.of(context).size.width * 0.9,
                        onPressed: (){},
                        color: Colors.amber,
                        padding: EdgeInsets.all(8.0),
                        textColor: Colors.white,
                        child: Text('PROMOTE YOUR XPERT PROFILE', textAlign: TextAlign.center,),
                      ),
          // SizedBox(
          //   height: 25.0,
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    '₹'+ earned??'0',
                    style: TextStyle(color: Colors.amber, fontSize: 20.0),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Earned',
                  )
                ],
              ),
              Container(
                height: 40.0,
                child: VerticalDivider(
                  width: 5.0,
                  color: Colors.grey,
                ),
              ),
              Column(
                children: <Widget>[
                  Text(
                    requests??'0',
                    // '586',
                    style: TextStyle(color: Colors.amber, fontSize: 20.0),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Requests',
                  )
                ],
              ),
              Container(
                height: 40.0,
                child: VerticalDivider(
                  width: 5.0,
                  color: Colors.grey,
                ),
              ),
              Column(
                children: <Widget>[
                  Text(
                    chats??'0',
                    style: TextStyle(color: Colors.amber, fontSize: 20.0),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Chats',
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: IconTheme(
                      data: IconThemeData(color: Colors.grey, size: 35.0),
                      child: Icon(Icons.attach_money),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePricePage(widget.title, questionPrice, wishPrice, shoutoutPrice)));
                    },
                    title: Text('Change Price',
                        style: TextStyle(color: Colors.black)),
                  ),
                  ListTile(
                    leading: IconTheme(
                      data: IconThemeData(color: Colors.grey, size: 35.0),
                      child: Icon(Icons.account_balance),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ManageBankPage()));
                    },
                    title: Text('Settlements',
                        style: TextStyle(color: Colors.black)),
                  ),
                  ListTile(
                    leading: IconTheme(
                      data: IconThemeData(color: Colors.grey, size: 35.0),
                      child: Icon(Icons.headset_mic),
                    ),
                    title: Text('WhatsApp Jacqueline',
                        style: TextStyle(color: Colors.black)),
                  ),
                  ListTile(
                    leading: IconTheme(
                      data: IconThemeData(color: Colors.grey, size: 35.0),
                      child: Icon(Icons.mobile_screen_share),
                    ),
                    onTap: () {
                      // Share.share('Share stuff from Xpert app',
                      //     subject: 'Invite a friend via...');
                      Navigator.push(context, 
                      MaterialPageRoute(builder: (context)=> ReferralPage())
                      );
                    },
                    title: Text('Refer A Friend',
                        style: TextStyle(color: Colors.black)),
                  ),
                  ListTile(
                    leading: IconTheme(
                      data: IconThemeData(color: Colors.grey, size: 35.0),
                      child: Icon(Icons.settings),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsPage()));
                    },
                    title:
                        Text('Settings', style: TextStyle(color: Colors.black)),
                  ),
                  ListTile(
                    leading: IconTheme(
                      data: IconThemeData(color: Colors.grey, size: 35.0),
                      child: Icon(Icons.power_settings_new),
                    ),
                    title:
                        Text('Logout', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
