import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class EditProfPicPage extends StatefulWidget {
  var imgFile;
  EditProfPicPage({this.imgFile});

  @override
  _EditProfPicPageState createState() => _EditProfPicPageState();
}

class _EditProfPicPageState extends State<EditProfPicPage> {
  File profPic;
  bool _isPicSelected = false;
  PanelController _panelController = new PanelController();
  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(10.0),
    topRight: Radius.circular(10.0),
  );

  Future pickImageFromGallery(ImageSource source, BuildContext context) async {
    await ImagePicker.pickImage(source: source).then((image) {
      setState(() {
        profPic = image;
        widget.imgFile = profPic;
        _isPicSelected = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _isPicSelected = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Edit Profile Picture'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _panelController.open();
            },
          )
        ],
      ),
      body: SlidingUpPanel(
        controller: _panelController,
        borderRadius: radius,
        backdropEnabled: true,
        minHeight: 0.0,
        maxHeight: MediaQuery.of(context).size.height * 0.35,
        collapsed: Container(height: 0.0),
        panel: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('Profile Photo',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.12,
                        height: MediaQuery.of(context).size.height * 0.12,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/gallery.png'))),
                      ),
                      onTap: () {
                        pickImageFromGallery(ImageSource.gallery, context)
                            .then((image) {
                          _panelController.close();
                          // uploadFile();
                        });
                      },
                    ),
                    Text(
                      'Gallery',
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.12,
                        height: MediaQuery.of(context).size.height * 0.12,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/camera.png'))),
                      ),
                      onTap: () {
                        pickImageFromGallery(ImageSource.camera, context)
                            .then((image) {
                          // uploadFile();
                          _panelController.close();
                        });
                      },
                    ),
                    Text(
                      'Camera',
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.12,
                        height: MediaQuery.of(context).size.height * 0.12,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/remove_pic.png'))),
                      ),
                      onTap: () {
                        _panelController.close();
                        setState(() {
                          widget.imgFile = '';
                          profPic = null;
                        });
                      },
                    ),
                    Text(
                      'Remove',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                    ),
                  ],
                ),
              ],
            ),

            GestureDetector(
              onTap: () {
                _panelController.close();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black, fontSize: 18.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(width: 1.0, color: Colors.grey))),
              ),
            ),

            // Divider(
            //   height: 4.0,
            //   thickness: 1.0,
            //   color: Colors.grey,
            // ),
            // GestureDetector(
            //   onTap: (){
            //     _panelController.close();
            //   },
            //   child: Container(
            //     child: Text('Cancel', style: TextStyle(color: Colors.black),),
            //   ),
            // )
          ],
        ),
        body: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.15,
                ),
                child: (widget.imgFile != null && widget.imgFile != '')
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: _isPicSelected
                                    ? FileImage(widget.imgFile)
                                    : NetworkImage(widget.imgFile),
                                fit: BoxFit.cover)),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: MediaQuery.of(context).size.width,
                        child: Center(child: Text('NO PROFILE PHOTO')),
                      )),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.045),
              child: MaterialButton(
                minWidth: double.infinity,
                height: 60,
                color: Colors.amber,
                child: Text('UPDATE PROFILE PICTURE',
                    style: TextStyle(color: Colors.white, fontSize: 22)),
                onPressed: () {
                  Navigator.pop(context, profPic);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
