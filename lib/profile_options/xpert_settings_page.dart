import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: IconTheme(
                data: IconThemeData(color: Colors.amber, size: 35.0),
                child: Icon(Icons.question_answer),
              ),
              title: Text('FAQ', style: TextStyle(color: Colors.black)),
            ),
            ListTile(
              leading: IconTheme(
                data: IconThemeData(color: Colors.amber, size: 35.0),
                child: Icon(Icons.language),
              ),
              title: Text('Language', style: TextStyle(color: Colors.black)),
            ),
            ListTile(
              leading: IconTheme(
                data: IconThemeData(color: Colors.amber, size: 35.0),
                child: Icon(Icons.info_outline),
              ),
              title: Text('App info', style: TextStyle(color: Colors.black)),
            ),
            ListTile(
              leading: IconTheme(
                data: IconThemeData(color: Colors.amber, size: 35.0),
                child: Icon(Icons.notifications),
              ),
              title:
                  Text('Notifications', style: TextStyle(color: Colors.black)),
            ),
            ListTile(
              leading: IconTheme(
                data: IconThemeData(color: Colors.amber, size: 35.0),
                child: Icon(Icons.list),
              ),
              title: Text('Terms and Privacy Policy',
                  style: TextStyle(color: Colors.black)),
            ),
            ListTile(
              leading: IconTheme(
                data: IconThemeData(color: Colors.amber, size: 35.0),
                child: Icon(Icons.delete_forever),
              ),
              title:
                  Text('Delete Account', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
