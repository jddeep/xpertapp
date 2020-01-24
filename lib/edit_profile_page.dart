import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final docID;
  EditProfilePage({this.docID});
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _shortbioController = TextEditingController();
  TextEditingController _longbioController = TextEditingController();

  void _updateProfileData() async {
    print('NAME: ' + _nameController.text);
    await Firestore.instance
        .collection('xpert_master')
        .document(widget.docID.toString())
        .updateData({
      "name": _nameController.text,
      "email": _emailController.text,
      "short_bio": _shortbioController.text,
      "long_bio": _longbioController.text
    }).whenComplete(() {
      print('Profile updated!');
      Navigator.pop(context);
    });
  }

  void _fetchXpertProfDetails() async {
    await Firestore.instance
        .collection('xpert_master')
        .document(widget.docID.toString())
        .get()
        .then((_userDoc) {
      setState(() {
        _nameController.text = _userDoc["name"];
        _emailController.text = _userDoc["email"];
        _shortbioController.text = _userDoc["short_bio"];
        _longbioController.text = _userDoc["long_bio"];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchXpertProfDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Theme(
                  data: ThemeData(
                      primaryColor: Colors.black, accentColor: Colors.black),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Name', style: TextStyle(color: Colors.grey)),
                        TextField(
                          controller: _nameController,
                          autofocus: false,
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                          decoration: InputDecoration(
                            hintText: 'Enter name',
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text('Email', style: TextStyle(color: Colors.grey)),
                        TextField(
                          controller: _emailController,
                          autofocus: false,
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                          decoration: InputDecoration(
                            hintText: 'Enter email',
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text('Short Bio', style: TextStyle(color: Colors.grey)),
                        TextField(
                          controller: _shortbioController,
                          autofocus: false,
                          keyboardType: TextInputType.text,
                          minLines: 1,
                          maxLines: 3,
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                          decoration: InputDecoration(
                            hintText: 'Enter short bio',
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text('Long Bio', style: TextStyle(color: Colors.grey)),
                        TextField(
                          controller: _longbioController,
                          autofocus: false,
                          minLines: 7,
                          maxLines: 15,
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                          decoration: InputDecoration(
                            hintText: 'Enter long bio',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          MaterialButton(
            minWidth: double.infinity,
            height: 60,
            color: Colors.amber,
            child: Text('UPDATE PROFILE',
                style: TextStyle(color: Colors.white, fontSize: 20)),
            onPressed: () {
              _updateProfileData();
            },
          ),
        ],
      ),
    );
  }
}
