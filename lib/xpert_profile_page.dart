import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xpert/profile_options/change_price_page.dart';
import 'package:share/share.dart';
import 'package:xpert/profile_options/manage_bank_page.dart';
import 'package:xpert/profile_options/xpert_settings_page.dart';

class XpertProfilePage extends StatefulWidget {
  @override
  _XpertProfilePageState createState() => _XpertProfilePageState();
}

class _XpertProfilePageState extends State<XpertProfilePage> {
  Future<File> imageFile;
  FileImage profile_pic;

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
          return CircleAvatar(
            radius: 30.0,
            backgroundImage: AssetImage('assets/my_prof_pic.jpg'),
            // backgroundImage: NetworkImage('https://avatars2.githubusercontent.com/u/43133646?s=400&v=4'),
          );
        }
      },
    );
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
                showImage(),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Jaideep Prasad',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 26.0),
                      ),
                      Text('Software Developer', textAlign: TextAlign.start),
                      Row(
                        children: <Widget>[
                          IconTheme(
                            data:
                                IconThemeData(color: Colors.amber, size: 10.0),
                            child: Icon(Icons.star),
                          ),
                          Text('5.0')
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 25.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    '₹30K',
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
                    '586',
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
                    '120',
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
                              builder: (context) => ChangePricePage()));
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
                    title: Text('Manage Bank',
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
                      Share.share('Share stuff from Xpert app',
                          subject: 'Invite a friend via...');
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
