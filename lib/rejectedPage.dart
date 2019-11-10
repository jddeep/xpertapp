import 'package:flutter/material.dart';

class RejectedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Your application is rejected',
                style: TextStyle(fontSize: 20.0),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.grey,
                child: Row(
                  children: <Widget>[
                    Expanded(child: Text('XPERTS NEED TO CLEAR ATLEAST 3 GUIDELINES')),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              ListTile(
                leading: Icon(Icons.star_border),
                title: Text('POPULAR', style: TextStyle(fontSize: 18.0)),
                subtitle: Row(
                  children: <Widget>[
                    Expanded(child: Text('100K+ social media followers or wikipedia', style: TextStyle(color: Colors.grey))),
                  ],
                ),
              ),
              Divider(height: 3.0, color: Colors.grey,),
              SizedBox(height: 6.0),
              ListTile(
                leading: Icon(Icons.speaker_notes),
                title: Text('IN THE NEWS', style: TextStyle(fontSize: 18.0)),
                subtitle: Row(
                  children: <Widget>[
                    Expanded(child: Text('Has atleast 10 credible news mentions', style: TextStyle(color: Colors.grey))),
                  ],
                ),
              ),
              Divider(height: 3.0, color: Colors.grey,),
              SizedBox(height: 6.0),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('AWARDED', style: TextStyle(fontSize: 18.0)),
                subtitle: Row(
                  children: <Widget>[
                    Expanded(child: Text('Is recognized by industry bodies', style: TextStyle(color: Colors.grey))),
                  ],
                ),
              ),
              Divider(height: 3.0, color: Colors.grey,),
              SizedBox(height: 6.0),
              ListTile(
                leading: Icon(Icons.mic),
                title: Text('SPOKEN', style: TextStyle(fontSize: 18.0)),
                subtitle: Row(
                  children: <Widget>[
                    Expanded(child: Text('Has spoken at famed conferences(TEDX)', style: TextStyle(color: Colors.grey))),
                  ],
                ),
              ),
              Divider(height: 3.0, color: Colors.grey,),
              SizedBox(height: 6.0),
              ListTile(
                leading: Icon(Icons.receipt),
                title: Text('SUCCESSFULLY PETITIONED', style: TextStyle(fontSize: 18.0)),
                subtitle: Row(
                  children: <Widget>[
                    Expanded(child: Text('Their Xpert petition crosses 200+', style: TextStyle(color: Colors.grey))),
                  ],
                ),
              ),
              Divider(height: 3.0, color: Colors.grey,),
            ],
          ),
      ),),
    );
  }
}