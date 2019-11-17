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
              Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Refer a friend and',
                          style:
                              TextStyle(color: Colors.black, fontSize: 22.0)),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                            color: Colors.amber, shape: BoxShape.rectangle),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Earn 5%',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 35.0)),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: Text('of their annual',
                            style:
                                TextStyle(color: Colors.amber, fontSize: 22.0)),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: Text('income',
                            style:
                                TextStyle(color: Colors.amber, fontSize: 22.0)),
                      ),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/in_refer_page.png'))),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 7.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.amber,
                      radius: 5.0,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 4.0),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text('Share your invite code',
                        maxLines: 3,
                        softWrap: true,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.black, fontSize: 20.0)),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 7.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.amber,
                      radius: 5.0,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.only(left: 4.0),
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 20.0),
                          children: <TextSpan>[
                            TextSpan(text: 'Request your referral to provide '),
                            TextSpan(
                                text: widget.refCode,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: ' as invite code during sign-up')
                          ]),
                    ),
                    // child: Text(
                    //     'Request your referral to provide ' +widget.refCode+ ' as invite code during sign-up',
                    //     maxLines: 3,
                    //     softWrap: true,
                    //     textAlign: TextAlign.start,
                    //     style: TextStyle(color: Colors.black, fontSize: 20.0)
                    //   ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 7.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.amber,
                      radius: 5.0,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text('You can earn 5% of their annual revenue',
                        textAlign: TextAlign.start,
                        maxLines: 3,
                        softWrap: true,
                        style: TextStyle(color: Colors.black, fontSize: 20.0)),
                  ),
                ],
              ),
              SizedBox(
                height: 18.0,
              ),
              Divider(
                height: 5.0,
                color: Colors.grey,
              ),
              SizedBox(
                height: 8.0,
              ),
              Text('Share your Referral Code',
                  style: TextStyle(color: Colors.black, fontSize: 24.0)),
              SizedBox(
                height: 4.0,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.black, width: 2.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.refCode,
                          // 'VIRAXP34',
                          style:
                              TextStyle(color: Colors.black, fontSize: 26.0)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12.0),
                              bottomRight: Radius.circular(12.0))),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.white, size: 30.0),
                        child: IconButton(
                          onPressed: () {
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
              SizedBox(
                height: 4.0,
              ),
              Text(
                'NOTE: Remember Xperts have to clear our selection criteria to be eligible.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black,),
              )
            ],
          ),
        ),
      ),
    );
  }
}
