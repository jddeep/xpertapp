import 'package:flutter/material.dart';

class ManageBankPage extends StatefulWidget {
  @override
  _ManageBankPageState createState() => _ManageBankPageState();
}

class _ManageBankPageState extends State<ManageBankPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Bank'),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.all(8.0),
              leading: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.amber)),
                child: IconButton(
                  onPressed: () {},
                  icon: IconTheme(
                      data: IconThemeData(color: Colors.amber),
                      child: Icon(Icons.add)),
                ),
              ),
              title: Text(
                'Add Bank Account',
                style: TextStyle(color: Colors.amber, fontSize: 25.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
