import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xpert/homepage.dart';
import 'package:xpert/videoanswerscreen.dart' as prefix0;

class XpertInviteScreen extends StatefulWidget {
  var cameras;
  FirebaseUser user;

  XpertInviteScreen({this.cameras, @required this.user});
  @override
  _XpertInviteScreenState createState() => _XpertInviteScreenState();
}

class _XpertInviteScreenState extends State<XpertInviteScreen> {
  TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> _socialAccounts = <String>[
    '',
    'Twitter',
    'LinkedIn',
    'Youtube',
    'GitHub'
  ];
  String _socialAccount = '';
  final dataBaseRef = Firestore.instance;
  String _fname;
  String _lname;
  String _mobile;
  String _email;
  String _sname = '';
  String _shandle;
  String _sfollowers;
  String _source = 'app';
  String _status = 'underReview';

  Future<void> _registerUser({
    String firstname,
    String lastname,
    String mobile,
    String email,
    String sname,
    String shandle,
    String sfollowers,
    String source,
    String status,
  }) async {
    await dataBaseRef.collection('invite_requests').document(widget.user.uid).setData({
      'uid': widget.user.uid,
      'date': DateTime.now(),
      'fname': firstname,
      'lname': lastname,
      'mobile': mobile,
      'email': email,
      'sname': sname,
      'shandle': shandle,
      'sfollowers': sfollowers,
      'source': source,
      'status': status,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        top: true,
        minimum: EdgeInsets.only(top: 50),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: <Widget>[
                    Text('Request an Xpert Invite',
                        style: TextStyle(color: Colors.white, fontSize: 26.0)),
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 160,
                          child: TextFormField(
                            onChanged: (value){
                              setState(() {
                                _fname = value;
                              });
                            },
                            autofocus: false,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              labelText: 'First Name',
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            keyboardType: TextInputType.text,
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ),
                        Container(
                          width: 160,
                          child: TextFormField(
                            onChanged: (value){
                              setState(() {
                                _lname = value;
                              });
                            },
                            autofocus: false,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              labelText: 'Last Name',
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            keyboardType: TextInputType.text,
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                    new TextFormField(
                      onChanged: (value){
                              setState(() {
                                _email = value;
                              });
                            },
                      decoration: const InputDecoration(
                        hintText: 'Enter a email address',
                        labelText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    Row(
                      children: <Widget>[
                        new CountryCodePicker(
                          onChanged: print,
                          // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                          initialSelection: '+91',
                          favorite: ['+91', 'IN'],
                          // optional. Shows only country name and flag
                          showCountryOnly: false,
                          // optional. Shows only country name and flag when popup is closed.
                          //  showOnlyCountryCodeWhenClosed: false,
                          // optional. aligns the flag and the Text left
                          alignLeft: false,
                        ),
                        Container(
                          width: 240,
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Enter your phone number',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                            onChanged: print,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    new FormField(
                      builder: (FormFieldState state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Social Media',
                          ),
                          isEmpty: _sname == '',
                          child: new DropdownButtonHideUnderline(
                            child: new DropdownButton(
                              value: _socialAccount,
                              isDense: true,
                              onChanged: (String newValue) {
                                setState(() {
                                  print(newValue);
                                  // newContact.favoriteColor = newValue;
                                  _sname = newValue;
                                  state.didChange(newValue);
                                });
                              },
                              items: _socialAccounts.map((String value) {
                                return new DropdownMenuItem(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                    new TextFormField(
                      onChanged: (value){
                              setState(() {
                                _shandle = value;
                              });
                            },
                      decoration: const InputDecoration(
                        hintText: 'Enter your handle',
                        labelText: 'Your handle',
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    new TextFormField(
                      onChanged: (value){
                              setState(() {
                                _sfollowers = value;
                              });
                            },
                      decoration: const InputDecoration(
                        hintText: 'Enter the number of your followers',
                        labelText: 'How many followers do you have?',
                      ),
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
                child: Text('Submit',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                onPressed: () {
                  // Move to Account form Page
                  _registerUser(
                    firstname: _fname,
                    lastname: _lname,
                    mobile: _controller.text,
                    email: _email,
                    sname: _sname,
                    shandle: _shandle,
                    sfollowers: _sfollowers,
                    source: _source,
                    status: _status,
                  ).whenComplete((){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(
                          cameras: widget.cameras,
                        ),
                      ));
                  });

                },
              ),
            ],
          ),
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
