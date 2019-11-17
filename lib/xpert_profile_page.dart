import 'dart:io';

import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:xpert/profile_options/edit_payment_method.dart';
import 'package:xpert/profile_options/referral_page.dart';
import 'package:xpert/xpertWelcome.dart';
import 'profile_options/change_price_page.dart';
import 'package:share/share.dart';
import 'package:path/path.dart';
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
  File _dp;
  String userName;
  String userShortBio;
  String userLongBio;
  String userRating;
  String profImgURL;
  String earned;
  String requests;
  String chats;
  String xpertLink;
  String refCode;
  String paymentType;
  String payId;
  var creatorSetDocId;
  var questionPrice;
  var wishPrice;
  var shoutoutPrice;

  DocumentSnapshot _userDoc;

  @override
  void initState() {
    super.initState();
    _fetchUserProfileData().then((userDoc) {
      setState(() {
        // userName = userDoc["name"];
        // userShortBio = userDoc["short_bio"];
        // userLongBio = userDoc["long_bio"];
        // userRating = userDoc["rating"];
        // profImgURL = userDoc["profile_image"];
        this._userDoc = userDoc;
      });
    });
    print(
        'PROF USER ID: ' + widget.title + ' USER DOC: ' + _userDoc.toString());
  }

  Future<DocumentSnapshot> _fetchUserProfileData() async {
    DocumentSnapshot userDoc;
    await Firestore.instance
        .collection('xpert_master')
        .document(widget.title) // bhuvan-bam
        .get()
        .then((_userDoc) {
      xpertLink = 'www.xpert.tv/cr/';
      userName = _userDoc["name"];
      userShortBio = _userDoc["short_bio"];
      userLongBio = _userDoc["long_bio"];
      profImgURL = _userDoc["profile_image"];
      xpertLink += _userDoc["slug"];
      questionPrice = _userDoc["question_price"].toString();
      wishPrice = _userDoc["wish_price"].toString();
      shoutoutPrice = _userDoc["shout_price"].toString();
      refCode = _userDoc["slug"];
      userDoc = _userDoc;
    });
    await Firestore.instance
        .collection('xpert_master')
        .document(widget.title) // bhuvan-bam
        .collection('creator-settings')
        .getDocuments()
        .then((_userDoc) {
      creatorSetDocId = _userDoc.documents[0].documentID;
      userRating = _userDoc.documents[0].data["rating"].toString();
      earned = (NumberFormat.compact().format(_userDoc.documents[0].data["earned"])).toString();
      requests = _userDoc.documents[0].data["requests"].toString();
      chats = _userDoc.documents[0].data["fulfilled"].toString(); //chats
      paymentType = _userDoc.documents[0].data["payment_type"];
      payId = _userDoc.documents[0].data["payment_details_id"];
    });
    return userDoc;
  }

  //Open gallery
  Future pickImageFromGallery(ImageSource source) async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _dp = image;
      });
    });
  }

  void _updateAnswerUrl(String url) async {
    await Firestore.instance
        .collection('xpert_master')
        .document(widget.title)
        .updateData({
      'profile_image': url,
    }).whenComplete(() {
      print('Updated Prof img!');
    });
  }

  Future uploadFile() async {
    print('Path of file _dp: ' + _dp.path);
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('profpics/${_dp.path}}');
    StorageUploadTask uploadTask = storageReference.putFile(_dp);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        profImgURL = fileURL;
        _updateAnswerUrl(profImgURL);
      });
    });
  }

  // Widget showImage() {
  //   return FutureBuilder<File>(
  //     future: imageFile,
  //     builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
  //       if (snapshot.connectionState == ConnectionState.done &&
  //           snapshot.data != null) {
  //         return CircleAvatar(
  //           radius: 30.0,
  //           backgroundImage: FileImage(File(snapshot.data.path)),
  //         );
  //       } else {
  //         return Container(height: 1.0,);
  //         // return CircleAvatar( // default img when no dp is set.
  //         //   radius: 30.0,
  //         //   backgroundImage: AssetImage('assets/my_prof_pic.jpg'),
  //         //   // backgroundImage: NetworkImage('https://avatars2.githubusercontent.com/u/43133646?s=400&v=4'),
  //         // );
  //       }
  //     },
  //   );
  // }

  Widget _showUserImagefromURL(BuildContext context) {
    if (profImgURL != null && profImgURL.isNotEmpty) {
      return CircleAvatar(
        radius: MediaQuery.of(context).size.width / 9,
        backgroundImage: NetworkImage(profImgURL),
      );
    } else {
      // return showImage();
      return CircleAvatar(
        radius: MediaQuery.of(context).size.width / 9,
        backgroundImage: AssetImage('assets/def_prof_pic.png'),
        backgroundColor: Colors.grey,
      );
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

  _logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut().then((value) {
      print("***** log out");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => XpertWelcomePage()));
    });
    // Navigator.popUntil(context, ModalRoute.withName("/login"));
  }

  void _showDialog(BuildContext _context) {
    // flutter defined function
    showDialog(
      context: _context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.white,
          title: new Text("Are you sure you want to Log out?",
              style: TextStyle(color: Colors.black)),
          // content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancel",
                  style: TextStyle(color: Colors.red, fontSize: 18.0)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: Text('Yes',
                  style: TextStyle(color: Colors.black, fontSize: 18.0)),
              onPressed: () {
                // Logout
                _logOut(_context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_userDoc == null) {
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
          title: Text(
            userName ?? 'No user name',
            // userName,
            // 'Jaideep Prasad',
            // textAlign: TextAlign.start,
            // style: TextStyle(
            //     fontWeight: FontWeight.bold, fontSize: 26.0),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                pickImageFromGallery(ImageSource.gallery).then((image) {
                  uploadFile();
                });
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _showUserImagefromURL(context),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            // Text(
                            // userName??'Please set up one',
                            // // userName,
                            //   // 'Jaideep Prasad',
                            //   textAlign: TextAlign.start,
                            //   style: TextStyle(
                            //       fontWeight: FontWeight.bold, fontSize: 26.0),
                            // ),
                            Row(
                              children: <Widget>[
                                IconTheme(
                                  data: IconThemeData(
                                      color: Colors.amber, size: 20.0),
                                  child: Icon(Icons.star),
                                ),
                                Text(
                                  userRating ?? '0.0',
                                  style: TextStyle(fontSize: 21.0),
                                )
                              ],
                            )
                          ],
                        ),
                        // Container(
                        //   width: MediaQuery.of(context).size.width * 0.7,
                        //   child: Text(userShortBio ?? 'Please set up one',
                        //       maxLines: 4,
                        //       style: TextStyle(fontSize: 20.0),
                        //       softWrap: true,
                        //       // 'Software Developer',
                        //       textAlign: TextAlign.start),
                        // ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Row(
                            children: <Widget>[
                              Text(
                                xpertLink,
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 15.0),
                              ),
                              IconTheme(
                                data: IconThemeData(color: Colors.white),
                                child: IconButton(
                                  onPressed: () {
                                    // copy code
                                    ClipboardManager.copyToClipBoard(xpertLink)
                                        .then((result) {
                                      Fluttertoast.showToast(
                                          msg: "URL copied!",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIos: 1,
                                          backgroundColor: Colors.grey,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    });
                                  },
                                  icon: Icon(Icons.content_copy),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width * 0.9,
              onPressed: () {},
              color: Colors.grey,
              padding: EdgeInsets.all(8.0),
              textColor: Colors.white,
              child: Text(
                'AWAITING INTRO VIDEO',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // Column(
                //   children: <Widget>[
                //     Text(
                //       '₹'+ earned??'0',
                //       style: TextStyle(color: Colors.amber, fontSize: 20.0),
                //       textAlign: TextAlign.center,
                //     ),
                //     Text(
                //       'Earned',
                //     )
                //   ],
                // ),
                // Container(
                //   height: 40.0,
                //   child: VerticalDivider(
                //     width: 5.0,
                //     color: Colors.grey,
                //   ),
                // ),
                Column(
                  children: <Widget>[
                    Text(
                      requests ?? '0',
                      // '586',
                      style: TextStyle(color: Colors.amber, fontSize: 26.0),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Requests',
                    )
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.width / 8,
                  child: VerticalDivider(
                    width: 5.0,
                    color: Colors.grey,
                  ),
                ),
                Column(
                  children: <Widget>[
                    Text(
                      chats ?? '0',
                      style: TextStyle(color: Colors.amber, fontSize: 26.0),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Fulfilled', //Chats
                    )
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.width / 8,
                  child: VerticalDivider(
                    width: 5.0,
                    color: Colors.grey,
                  ),
                ),
                Column(
                  children: <Widget>[
                    Text(
                      '₹' + earned ?? '0',
                      style: TextStyle(color: Colors.amber, fontSize: 26.0),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Earned',
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
                      leading: Container(
                        height: 50.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/pricing.png'))),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangePricePage(
                                    widget.title,
                                    questionPrice,
                                    wishPrice,
                                    shoutoutPrice)));
                      },
                      title: Text('Change Price',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      leading: Container(
                        height: 50.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/transactions.png'))),
                      ),
                      onTap: () {
                        if (paymentType == null || (paymentType != null && paymentType.isEmpty)) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditPayMethod(
                                        userDocId: widget.title,
                                        creatorSetDocId: creatorSetDocId,
                                      )));
                        } else
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ManageBankPage(
                                        userDocId: widget.title,
                                        creatorDocId: creatorSetDocId,
                                      )));
                      },
                      title: Text('Settlements',
                          style: TextStyle(color: Colors.black)),
                    ),
                    // ListTile(
                    //   leading: IconTheme(
                    //     data: IconThemeData(color: Colors.grey, size: 35.0),
                    //     child: Icon(Icons.headset_mic),
                    //   ),
                    //   title: Text('WhatsApp Jacqueline',
                    //       style: TextStyle(color: Colors.black)),
                    // ),
                    // ListTile(
                    //   leading: IconTheme(
                    //     data: IconThemeData(color: Colors.grey, size: 35.0),
                    //     child: Icon(Icons.headset_mic),
                    //   ),
                    //   title: Text('WhatsApp Jacqueline',
                    //       style: TextStyle(color: Colors.black)),
                    // ),
                    ListTile(
                      leading: Container(
                        height: 50.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/refer_a_friend.png'))),
                      ),
                      onTap: () {
                        // Share.share('Share stuff from Xpert app',
                        //     subject: 'Invite a friend via...');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReferralPage(refCode)));
                      },
                      title: Text('Refer A Friend',
                          style: TextStyle(color: Colors.black)),
                    ),
                    // ListTile(
                    //   leading: IconTheme(
                    //     data: IconThemeData(color: Colors.grey, size: 35.0),
                    //     child: Icon(Icons.settings),
                    //   ),
                    //   onTap: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => SettingsPage()));
                    //   },
                    //   title:
                    //       Text('Settings', style: TextStyle(color: Colors.black)),
                    // ),
                    ListTile(
                      leading: Container(
                        height: 100.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/logout.png'))),
                      ),
                      onTap: () {
                        _showDialog(context);
                      },
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
