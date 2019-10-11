import 'package:flutter/material.dart';
import 'package:xpert/xpert_profile_page.dart';

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
                              Text('₹500/', style: TextStyle(fontSize: 40.0, color: Colors.black)),
                              Text('answer', style: TextStyle(fontSize: 26.0, color: Colors.black))
                            ],
                          );
}

class _EditPricePageState extends State<EditPricePage> {
  TextEditingController _priceTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Price'),
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
                      Text('New price', style: TextStyle(color: Colors.black, fontSize: 20.0)),
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
    );
  }
}