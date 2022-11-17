import 'package:flutter/material.dart';
import 'package:xpert/xpert_profile_page.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class EditPricePage extends StatefulWidget {
  final oldPrice;
  EditPricePage({this.oldPrice});
  @override
  _EditPricePageState createState() => _EditPricePageState();
}

Widget _currPrice(){

  return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('₹500/', style: TextStyle(fontSize: 40.0, color: Colors.amber)),
                              Text('answer', style: TextStyle(fontSize: 26.0, color: Colors.black))
                            ],
                          );
}

class _EditPricePageState extends State<EditPricePage> {
  PanelController _pc = new PanelController();
  TextEditingController _priceTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Price'),
      ),
      body: SlidingUpPanel(
        maxHeight: 500.0,
        backdropEnabled: true,
        controller: _pc,
        panel: Center(
        child: Text("Note: The Average price xperts ask is Rs. xxxxxx for questions",
        style: TextStyle(color: Colors.black),
        ),
      ),

      collapsed: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0)
        ),
        child: Center(
          child: Text(
            "Note: The Average price xperts ask...",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
              body: Column(
          children: <Widget>[
            Expanded(
                        child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Old price', style: TextStyle(color: Colors.black, fontSize: 20.0)),
                        _currPrice(),
                        
                        Divider(color: Colors.grey, height: 5.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('New price', style: TextStyle(color: Colors.black, fontSize: 20.0)),
                            IconTheme(
                              data: IconThemeData(color: Colors.black),
                              child: IconButton(
                                icon: Icon(Icons.info_outline),
                                onPressed: (){
                                  _pc.open();
                                },
                              )
                            )
                          ],
                        ),
                        TextField(
                          controller: _priceTextController,
                          autofocus: false,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.black, fontSize: 24.0),
                          decoration: InputDecoration(
                            hintText: 'Enter new price',
                            hintStyle: TextStyle(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black,),),
                            // border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 5.0), ),

                          ),
                        )
                      ],
                    ),
                  ),
                ),
            ),
            MaterialButton(
              minWidth: double.infinity,
              height: 60,
              color: Colors.amber,
              child: Text('Update Price',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              onPressed: () {
                // Move to OTP Page
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}