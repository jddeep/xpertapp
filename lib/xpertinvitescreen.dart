import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xpert/global.dart';
import 'package:xpert/homepage.dart';
import 'package:xpert/otpscreen.dart';
import 'package:xpert/underReview_page.dart';

class XpertInviteScreen extends StatefulWidget {
  // bool isRegisteredInDataBase = true;
  // var cameras;
  FirebaseUser user;
  String phoneNumber;

  XpertInviteScreen({
    this.phoneNumber,
    @required this.user,
  });
  @override
  _XpertInviteScreenState createState() => _XpertInviteScreenState();
}

class _XpertInviteScreenState extends State<XpertInviteScreen> {
  TextEditingController _phoneNumberController = TextEditingController();
  var _emailController = TextEditingController();
  var _fnameController = TextEditingController();
  var _lnameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isProfOther = false;
  String profImgURL = '';
  bool _submit = false;
  bool _invalidCode = true;
  bool _isReging = false;
  File _dp;
  List<String> _professions = new List();
  Map<String, String> _saveProfessionMap = new Map();
  List<String> referralCodes = new List();
  List<String> _socialAccounts = <String>[
    '',
    'Twitter',
    'Instagram',
    'Youtube',
    'Facebook'
  ];
  String _socialAccount = '';
  final dataBaseRef = Firestore.instance;
  String _fname;
  String _lname;
  String _mobile;
  String _email;
  String _shortbio;
  String _sname = '';
  String _shandle;
  String _sfollowers;
  String _profession;
  String _inviteCode;
  String _source = 'app';
  String _status = 'pending';

  Future<void> _registerUser({
    String firstname,
    String lastname,
    String mobile,
    String email,
    String shortBio,
    String sname,
    String shandle,
    String sfollowers,
    String profession,
    String inviteCode,
    String source,
    String status,
  }) async {
    await dataBaseRef
        .collection('invite_requests')
        .document(widget.user.uid)
        .setData({
      'auth_id': widget.user.uid,
      'date': DateTime.now(),
      'fname': firstname,
      'lname': lastname,
      'mobile': mobile,
      'email': email,
      'short_bio' : shortBio,
      'sname': sname,
      'shandle': shandle,
      'profile_image' : profImgURL,
      'sfollowers': sfollowers,
      'profession': profession,
      'invite_code': inviteCode,
      'source': source,
      'status': status,
    });
  }

  Future<List<DocumentSnapshot>> _getProfessionList() async {
    List<DocumentSnapshot> _docs;
    await Firestore.instance
        .collection('profession')
        .getDocuments()
        .then((docs) {
      _docs = docs.documents;
    });
    return _docs;
  }

  Future<List<DocumentSnapshot>> _getReferralList() async {
    List<DocumentSnapshot> _docs;
    await Firestore.instance
        .collection('xpert_master')
        .getDocuments()
        .then((docs) {
      _docs = docs.documents;
    });
    return _docs;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _phoneNumberController.text = widget.phoneNumber;
    _emailController.text = widget.user.email;
    if(widget.user.displayName != null && widget.user.displayName != ''){
    _fnameController.text = widget.user.displayName.toString().split(' ')[0];
    _lnameController.text = widget.user.displayName.toString().split(' ')[1];
    }
    _getProfessionList().then((docs) {
      for (int i = 0; i < docs.length; i++) {
        _professions.add(docs[i].data['sname'].toString());
        _saveProfessionMap[docs[i].data['sname'].toString()] = docs[i].data['profession'].toString();
      }
      
      setState(() {
        print('Profs length: ' + _professions.length.toString());
        print('Profs Map Length: ' + _saveProfessionMap.length.toString());
        // _professions.add('Other');
      });
    });

    _getReferralList().then((docs){
        for (int i = 0; i < docs.length; i++) {
        referralCodes.add(docs[i].data['slug'].toString());
      }
      }).whenComplete((){
        print('Referral codes length: ' + referralCodes.length.toString());
      });
  }

    void _showDialog(BuildContext _context) {
    // flutter defined function
    showDialog(
      context: _context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.white,
          title: new Text("Invite Code Missing",
              style: TextStyle(color: Colors.black)),
          // content: new Text("Alert Dialog body"),
          content: Text("Since you have not provided an invite code, your application will be reviewed manually by us. Press OK to proceed.",
              style: TextStyle(color: Colors.black)),
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
              child: Text('OK',
                  style: TextStyle(color: Colors.black, fontSize: 18.0)),
              onPressed: () {
                _regUser();
              },
            )
          ],
        );
      },
    );
  }

  void _regUser(){
    print('Profession value: ' +_saveProfessionMap[_profession]);
                      // Move to Account form Page
                  _registerUser(
                    firstname: _fnameController.text, //_fname
                    lastname: _lnameController.text,
                    mobile: _phoneNumberController.text,
                    email: _emailController.text, //_email
                    shortBio: _shortbio,
                    sname: _sname,
                    shandle: _shandle,
                    sfollowers: _sfollowers,
                    profession: _saveProfessionMap[_profession], //_profession
                    inviteCode: _inviteCode,
                    source: _source,
                    status: _status,
                  ).whenComplete(() async{
                    print('invite-code: ' + _inviteCode);
                    if(_inviteCode != null || _inviteCode != ''){
                      // final String pingurl = 'https://www.google.com';
                    final String pingurl = 'https://xpert.chat/apiJob.php?for=api&key=JhtuhGTgTRMj7lKyhhhTEJjFGk&auth_id=${widget.user.uid}';
await get(pingurl).then((res){
  print('RES STATUS CODE: ' + res.statusCode.toString());
  if(res.statusCode == 200){
    print('RAW RES BODY: ' + res.body.toString());

    Map<String, dynamic> body = jsonDecode(res.body);
    print('Decoded body: ' + body["status"].toString());
    if(body["status"] == 1){
    FROM_INVITE_PAGE = true;
    Navigator.pushReplacement(context,
    MaterialPageRoute(builder: (context)=> OTPScreen(null, null, ''))
    );
    }
    else
    Navigator.pushReplacement(context,
                        MaterialPageRoute(
                          builder: (context) => UnderReviewPage(),
                        ));
                    
  }
});

// print('RES STATUS CODE: ' + res.statusCode.toString());
// await ping("google.com").whenComplete((){
// Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => UnderReviewPage(),
//                         ));
// });
                    }

                      
                  });
  }

  //Open gallery
  Future pickImageFromGallery(ImageSource source) async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _dp = image;
      });
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
      });
    });
  }

  Widget _showUserImagefromURL(BuildContext context) {
    if (profImgURL != null && profImgURL.isNotEmpty) {
      return CircleAvatar(
        radius: MediaQuery.of(context).size.width / 6,
        backgroundImage: NetworkImage(profImgURL),
      );
    } else {
      // return showImage();
      return CircleAvatar(
        radius: MediaQuery.of(context).size.width / 6,
        backgroundImage: AssetImage('assets/def_prof_pic.png'),
        backgroundColor: Colors.grey,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //  if (_isReging) {
    //   return Center(
    //     child: Container(
    //       height: 50.0,
    //       width: 50.0,
    //       child: CircularProgressIndicator(
    //         backgroundColor: Colors.amber,
    //       ),
    //     ),
    //   );
    // } else
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Register as an Xpert'),
      ),
      body: Opacity(
        opacity: _isReging?0.5:1.0,
              child: Stack(
                children: <Widget>[
                  _isReging?Center(
        child: Container(
          height: 50.0,
          width: 50.0,
          child: CircularProgressIndicator(
            backgroundColor: Colors.amber,
          ),
        ),
      ):Container(height: 0.0,),
                  SafeArea(
          top: true,
          minimum: EdgeInsets.only(top: 20),
          child: Form(
            key: _formKey,
            autovalidate: true,
            child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        children: <Widget>[
                          // Text('Request an Xpert Invite',
                          //     style: TextStyle(color: Colors.white, fontSize: 26.0)),
                          // SizedBox(
                          //   height: 24,
                          // ),

                          Center(
                            child: GestureDetector(
                            child: Container(
                              child: Stack(
                                children: <Widget>[
                                  _showUserImagefromURL(context),
                                  Positioned(
                                    left: MediaQuery.of(context).size.width * 0.21,
                                    top: MediaQuery.of(context).size.height * 0.121,
                                    child: Container(
                                      height: 30.0,
                                      width: 30.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(300.0),
                                        color: Colors.amber
                                      ),
                                      child: IconTheme(
                                        data: IconThemeData(color: Colors.white, size: 20.0),
                                        child: Icon(Icons.camera_alt),
                                      ),
                                    ),
                                  )
                                ],
                              )
                              ),
                            onTap: (){
                        pickImageFromGallery(ImageSource.gallery).then((image) {
                        uploadFile();
                      });
                            },
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 160,
                                child: TextFormField(
                                  validator: (value) {
    if (_submit && value == '') {
        return 'Please enter your first name';
    }
    return null;
  },
                                  controller: _fnameController,
                                  onChanged: (value) {
                                    setState(() {
                                      _fname = value;
                                    });
                                  },
                                  autofocus: false,
                                  decoration: InputDecoration(
                                    labelText: 'First Name',
                                    hintText: 'First Name'
                                  ),
                                  keyboardType: TextInputType.text,
                                  style:
                                      TextStyle(color: Colors.white, fontSize: 16.0),
                                ),
                              ),
                              Container(
                                width: 160,
                                child: TextFormField(
                                  validator: (value) {
    if (_submit && value == '') {
        return 'Please enter your last name';
    }
    return null;
  },
                                  controller: _lnameController,
                                  onChanged: (value) {
                                    setState(() {
                                      _lname = value;
                                    });
                                  },
                                  autofocus: false,
                                  decoration: InputDecoration(
                                    hintText: 'Last Name',
                                    labelText: 'Last Name',
                                  ),
                                  keyboardType: TextInputType.text,
                                  style:
                                      TextStyle(color: Colors.white, fontSize: 16.0),
                                ),
                              ),
                            ],
                          ),
                          // new TextFormField(
                          //   controller: _emailController,
                          //   onChanged: (value) {
                          //     setState(() {
                          //       _email = value;
                          //     });
                          //   },
                          //   decoration: const InputDecoration(
                          //     hintText: 'Enter a email address',
                          //     labelText: 'Email',
                          //   ),
                          //   keyboardType: TextInputType.emailAddress,
                          // ),
                         
                          // Row(
                          //   children: <Widget>[
                          //     new CountryCodePicker(
                          //       onChanged: print,
                          //       // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                          //       initialSelection: '+91',
                          //       favorite: ['+91', 'IN'],
                          //       // optional. Shows only country name and flag
                          //       showCountryOnly: false,
                          //       // optional. Shows only country name and flag when popup is closed.
                          //       //  showOnlyCountryCodeWhenClosed: false,
                          //       // optional. aligns the flag and the Text left
                          //       alignLeft: false,
                          //     ),
                          //     Container(
                          //       width: 240,
                          //       child: TextField(
                          //         controller: _phoneNumberController,
                          //         decoration: InputDecoration(
                          //           hintText: 'Enter your phone number',
                          //           hintStyle: TextStyle(color: Colors.white),
                          //         ),
                          //         onChanged: (value) {
                          //           _mobile = value;
                          //         },
                          //         keyboardType: TextInputType.number,
                          //         style: TextStyle(color: Colors.white),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // new FormField(
                          //   builder: (FormFieldState state) {
                          //     return InputDecorator(
                          //       decoration: InputDecoration(
                          //         labelText: 'Social Media',
                          //       ),
                          //       isEmpty: _sname == '',
                          //       child: new DropdownButtonHideUnderline(
                          //         child: new DropdownButton(
                          //           value: _sname,
                          //           isDense: true,
                          //           style: TextStyle(color: Colors.white),
                          //           onChanged: (String newValue) {
                          //             setState(() {
                          //               print(newValue);
                          //               // newContact.favoriteColor = newValue;
                          //               _sname = newValue;
                          //               state.didChange(newValue);
                          //             });
                          //           },
                          //           items: _socialAccounts.map((String value) {
                          //             return new DropdownMenuItem(
                          //               value: value,
                          //               child: new Text(
                          //                 value,
                          //                 style: TextStyle(color: Colors.white),
                          //               ),
                          //             );
                          //           }).toList(),
                          //         ),
                          //       ),
                          //     );
                          //   },
                          // ),
                          // new TextFormField(
                          //   onChanged: (value) {
                          //     setState(() {
                          //       _shandle = value;
                          //     });
                          //   },
                          //   decoration: const InputDecoration(
                          //     hintText: 'Enter your handle',
                          //     labelText: 'Your handle',
                          //   ),
                          //   keyboardType: TextInputType.text,
                          // ),
                          // new TextFormField(
                          //   onChanged: (value) {
                          //     setState(() {
                          //       _sfollowers = value;
                          //     });
                          //   },
                          //   decoration: const InputDecoration(
                          //     hintText: 'Enter the number of your followers',
                          //     labelText: 'How many followers do you have?',
                          //   ),
                          //   keyboardType: TextInputType.text,
                          // ),
                          FormField(
                          validator: (value) {
    if (_submit && value == '') {
        return 'Please enter your profession';
    }
    return null;
  },
                            builder: (FormFieldState state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Profession',
                                ),
                                isEmpty: _profession == '',
                                child: new DropdownButtonHideUnderline(
                                  child: new DropdownButton(
                                    value: _profession,
                                    isDense: true,
                                    style: TextStyle(color: Colors.white),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        print(newValue);
                                        // newContact.favoriteColor = newValue;
                                        _profession = newValue;
                                        if (_profession == 'Other')
                                          _isProfOther = true;
                                        else
                                          _isProfOther = false;

                                        state.didChange(newValue);
                                      });
                                    },
                                    items: _professions.map((String value) {
                                      return new DropdownMenuItem(
                                        value: value,
                                        child: new Text(
                                          value,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                          _isProfOther
                              ? TextFormField(
                                validator: (value) {
    if (_submit && value == '') {
        return 'Please enter your profession';
    }
    return null;
  },
                                  onChanged: (value) {
                                    setState(() {
                                      _profession = value;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                      labelText: 'Other Profession',
                                      alignLabelWithHint: true),
                                  keyboardType: TextInputType.text,
                                )
                              : SizedBox(
                                  height: 1.0,
                                ),
                                 new TextFormField(
                                   validator: (value) {
    if (_submit && value == '') {
        return 'Please enter your short bio';
    }
    return null;
  },
                            onChanged: (value) {
                              setState(() {
                                _shortbio = value;
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: 'Short Bio',
                              labelText: 'Short Bio',
                            ),
                            keyboardType: TextInputType.text,
                          ),
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                _inviteCode = value;
                              });
                            },
                            decoration: const InputDecoration(
                                labelText: 'Have an Invite Code?',
                                alignLabelWithHint: true),
                            keyboardType: TextInputType.text,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child:
                          Text('We will use this information to review your account'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: Text('and get in touch with you to get you live.'),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      color: Colors.amber,
                      child: Text('PROCEED',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onPressed: () {
                        if(_formKey.currentState.validate()){
                          _submit = true;
                        if(_inviteCode == null || _inviteCode == '')
                        _showDialog(context);
                        else{
                          setState(() {
                            _isReging = true;
                          });
                          for(var i in referralCodes){
                            print('Referral: ' +i);
                            if(_inviteCode == i){
                              _regUser();
                              _invalidCode = false;
                              break;
                            }
                          }
                          if(_invalidCode)
                          Fluttertoast.showToast(
                              msg: 'Invalid referral code! Please check again and proceed.',
                              textColor: Colors.white,
                              backgroundColor: Colors.grey,
                              toastLength: Toast.LENGTH_SHORT
                            );
                          // _regUser();
                        }
                        
                        }
                      },
                    ),
                  ],
            ),
          ),
        ),
                ],
              ),
      ),
      ///////////
      ///
      //     Form(
      //       key: _formKey,
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: <Widget>[
      //           Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //       children: <Widget>[
      //         TextFormField(
      //           autofocus: false,
      //           decoration: InputDecoration(
      //             alignLabelWithHint: true,
      //             labelText: 'First Name',
      //             labelStyle: TextStyle(
      //               color: Colors.white
      //             ),
      //           ),
      //           keyboardType: TextInputType.text,
      //           style: TextStyle(color: Colors.white, fontSize: 16.0),
      //         ),
      //         TextFormField(
      //           autofocus: false,
      //           decoration: InputDecoration(
      //             alignLabelWithHint: true,
      //             labelText: 'Last Name',
      //             labelStyle: TextStyle(
      //               color: Colors.white
      //             ),
      //           ),
      //           keyboardType: TextInputType.text,
      //           style: TextStyle(color: Colors.white, fontSize: 16.0),
      //         ),
      //       ],
      //     ),
      //     TextFormField(
      //           autofocus: false,
      //           decoration: InputDecoration(
      //             alignLabelWithHint: true,
      //             labelText: 'Email',
      //             labelStyle: TextStyle(
      //               color: Colors.white
      //             ),
      //           ),
      //           keyboardType: TextInputType.emailAddress,
      //           style: TextStyle(color: Colors.white, fontSize: 16.0),
      //         ),
      //         Row(
      //             children: <Widget>[
      //               new CountryCodePicker(
      //    onChanged: print,
      //    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
      //    initialSelection: '+91',
      //    favorite: ['+91','IN'],
      //    // optional. Shows only country name and flag
      //    showCountryOnly: false,
      //    // optional. Shows only country name and flag when popup is closed.
      //   //  showOnlyCountryCodeWhenClosed: false,
      //    // optional. aligns the flag and the Text left
      //    alignLeft: false,
      //  ),
      //  Container(
      //             width: 200,
      //             child: TextField(
      //             controller: _controller,
      //             decoration: InputDecoration(
      //               labelText: 'Enter your phone number',
      //               labelStyle: TextStyle(color: Colors.white),
      //             ),
      //             onChanged: print,
      //             keyboardType: TextInputType.number,
      //             style: TextStyle(color: Colors.white),
      //         ),
      //           ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     ),

      //   ],
      // ),
    );
  }
}
