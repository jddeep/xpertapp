import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:xpert/guideline_page.dart';

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
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
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
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/in_refer_page.png'))),
                        )
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.001),
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
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('Identify an Xpert (', style: TextStyle(color: Colors.black, fontSize: 20.0)),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context,
                                    MaterialPageRoute(builder: (context)=>GuideLinePage())
                                    );
                                  },
                                  child:Text('Guideline', style: TextStyle(color: Colors.amber, fontSize: 16.0))),
                                Text(')', style: TextStyle(color: Colors.black, fontSize: 20.0))
                            ],
                          ) 
                          // RichText(
                          //   maxLines: 3,
                          //   softWrap: true,
                          //   textAlign: TextAlign.start,
                          //   text: TextSpan(
                          //     children: [
                          //       TextSpan(text: 'Identify an Xpert ('),
                          //       GestureDetector(child:TextSpan(text: 'Guideline', style: TextStyle(color: Colors.amber))),
                          //       TextSpan(text: ')')
                          //     ],
                          //     // 'Identify an Xpert (',
                          //       // maxLines: 3,
                          //       // softWrap: true,
                          //     //   textAlign: TextAlign.start,
                          //       style: TextStyle(color: Colors.black, fontSize: 20.0)),
                          // ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
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
                                  TextSpan(text: 'Request them to provide '),
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
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
                          child: Text('Get 5% of their Xpert income in the first year',
                              textAlign: TextAlign.start,
                              maxLines: 3,
                              softWrap: true,
                              style: TextStyle(color: Colors.black, fontSize: 20.0)),
                        ),
                      ],
                    ),
                    // SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    
                    
                  ],
                ),
                
              ),
          ),
            Expanded(
              flex: 0,
                          child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Divider(
                      thickness: 3.0,
                      color: Colors.grey,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Text('Share your Referral Code',
                          style: TextStyle(color: Colors.black, fontSize: 24.0)),
                      SizedBox(
                        height: 4.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.2),
                            border: Border.all(color: Colors.black, width: 1.0)),
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
                              width: MediaQuery.of(context).size.width * 0.21,
                              decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(MediaQuery.of(context).size.height * 0.2),
                                      bottomRight: Radius.circular(MediaQuery.of(context).size.height * 0.2))),
                              child: IconTheme(
                                data: IconThemeData(color: Colors.white),
                                child: IconButton(
                                  iconSize: 30.0,
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
            )
        ],
      ),
    );
  }
}
