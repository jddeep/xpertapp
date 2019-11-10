import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ReferralPage extends StatefulWidget {
  final String refCode;
  ReferralPage(this.refCode);
  @override
  _ReferralPageState createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Refer a Friend'),
      ),
      body: SingleChildScrollView(
              child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Refer a friend and',
                style: TextStyle(color: Colors.black, fontSize: 20.0)
              ),
              Container(
                padding: EdgeInsets.only(top: 4.0),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.rectangle
                ),
                child: Text('Earn 5%', style: TextStyle(color: Colors.white, fontSize: 26.0)),

              ),
              Text(
                'of their annual income',
                style: TextStyle(color: Colors.amber)
              ),
              Row(children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.amber,
                  radius: 5.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    'Share your invite code',
                    style: TextStyle(color: Colors.black)
                  ),
                ),
              ],),
              SizedBox(height: 8.0,),
              Row(children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.amber,
                  radius: 5.0,
                ),
                Expanded(
                                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                        'Request your referral to provide' +widget.refCode+ 'as invite code during sign-up',
                        style: TextStyle(color: Colors.black)
                      ),
                  ),
                ),
              ],),
              SizedBox(height: 8.0,),
              Row(children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.amber,
                  radius: 5.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    'You can earn 5% of their annual revenue',
                    style: TextStyle(color: Colors.black)
                  ),
                ),
              ],),
              SizedBox(height: 8.0,),
              Divider(
                height: 5.0,
                color: Colors.grey,
              ),
              SizedBox(height: 8.0,),
              Text(
                    'Share your Referral Code',
                    style: TextStyle(color: Colors.black)
                  ),
                  SizedBox(height: 4.0,),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: Colors.black, width: 2.0)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          widget.refCode,
                          // 'VIRAXP34',
                          style: TextStyle(color: Colors.black, fontSize: 20.0)
                        ),
                        Container(
                          
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0)
                            )
                          ),
                          child: IconTheme(
                            data: IconThemeData(color: Colors.white, size: 20.0),
                            child: IconButton(
                              onPressed: (){
                                Share.share('Invite code: ' + widget.refCode,
                          subject: 'Invite a friend via...');
                              },
                              icon: Icon(Icons.share),
                            ),
                          ),
                        )
                      ],
                    ),
                  
                  ),
                  SizedBox(height: 4.0,),
                  Text('NOTE: Remember Xperts have to clear our selection criteria to be eligible.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 10.0),
                  )
            ],
          ),
        ),
      ),
    );
  }
}