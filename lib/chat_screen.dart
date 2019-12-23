import 'dart:io';

import 'package:audio_recorder/audio_recorder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as pathDart;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'fullphoto.dart';

class ChatScreen extends StatefulWidget {
  final botPicUrl;
  final userId;
  final orderDocId;
  final incomingData;
  
  ChatScreen({this.botPicUrl, this.orderDocId, this.userId, this.incomingData});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

    String imageUrl;
    File imageFile;
  bool isLoading;
  static bool isSending = false;
  bool _isAudioRecording = false;
  String tempFilename = "TempRecording";
  File defaultAudioFile;

  final TextEditingController textEditingController = new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();

  bool isMe = false;
  int messageCounter = 0;
  List<String> messages = new List();
  List<String> intents = new List();
  List<DocumentSnapshot> scripts = new List();
  List<DocumentSnapshot> responses = new List();
  List<String> liveResponses = new List();
  List<String> responseTypes = new List();

   Future getImage(var intent) async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
        isSending = true;
      });
      uploadFile(intent);
    }
  }

  Future uploadFile(var intent) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      isSending = true;
       onSendMessage(imageUrl, 'image', intent);
    }, onError: (err) {
      // setState(() {
      //   isLoading = false;
      // });
      Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }

  Future uploadAudioFile(var intent) async{
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(defaultAudioFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      isSending = true;
       onSendMessage(imageUrl, 'audio', intent);
    }, onError: (err) {
      // setState(() {
      //   isLoading = false;
      // });
      Fluttertoast.showToast(msg: 'This file is not an audio');
    });
  }

  void onSendMessage(String content, String type, var intent) async{
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

QuerySnapshot result = await Firestore.instance
    .collection('xpert_master')
          .document('aamir-khan')
          .collection('responses')
    .where('intent', isEqualTo: intent.toString())
    .limit(1)
    .getDocuments();

if(result.documents.length == 0){

  Map<String, dynamic> responseData = new Map();
  responseData["response"] = content;
  responseData["intent"] = intent;
  responseData["response_type"] = type;

  DocumentReference newIntentDoc = Firestore.instance.collection('xpert_master')
          .document('aamir-khan')
          .collection('responses')
          .document();

          Firestore.instance.runTransaction((transaction) async{
            await transaction.set(newIntentDoc, responseData);
            print('Doc instance created!');
          }).whenComplete((){
            print('COntent was: '+ content);
            print('Type was: '+ type);
            print('Intent was: ' + intent.toString());
            print("Responses updated!");
            if(liveResponses.length < messages.length)
            setState(() {
              liveResponses.add(content);
              responseTypes.add(type);
              messageCounter++;
              if(content != "")
              isSending = false;
              print('LIVE RES LEN: ' + liveResponses.length.toString());
            });
          });
} else{
    var responseDocId = result.documents[0].documentID;

    await Firestore.instance
          .collection('xpert_master')
          .document('aamir-khan')
          .collection('responses')
          .document(responseDocId.toString())
          .updateData({
            'response' : content,
            'response_type' : type
          }).whenComplete((){
            print('COntent was: '+ content);
            print('Type was: '+ type);
            print('Intent was: ' + intent.toString());
            print("Responses updated!");
            if(liveResponses.length < messages.length)
            setState(() {
              liveResponses.add(content);
              responseTypes.add(type);
              messageCounter++;
              if(content != "")
              isSending = false;
              print('LIVE RES LEN: ' + liveResponses.length.toString());
            });
            // listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
          });
}  
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

// building messages MAP
  _buildMessage(var message, var response, var rsptype) {
    print('Message Build BOT msg: ' + message.toString());
    print('Message Build RESPONSE msg: ' + response.toString());
    
    Container botMessage = message==""?Container(height:0.0):
    Container(
      margin: EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              right: 40.0
            ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15.0),
              ),
              border: Border.all(color: Colors.black)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
            maxLines: 6,
          ),
        ],
      ),
    );

    Container responseMsg = response==""?isSending?
    Container(
      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.12),
      child: Container(
                              child: Center(
                                child: Container(
                                  width: 40.0,
                                  height: 40.0,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                                  ),
                                ),
                              ),
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: MediaQuery.of(context).size.height * 0.1,
                              // padding: EdgeInsets.all(70.0),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                            ),
    )
    :
    Container(height:0.0)
    :
    rsptype=="image"?
    Container(
      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.12),
                      child: FlatButton(
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: Center(
                                child: Container(
                                  width: 40.0,
                                  height: 40.0,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                                  ),
                                ),
                              ),
                              width: MediaQuery.of(context).size.width * 0.65,
                              height: MediaQuery.of(context).size.height * 0.3,
                              // padding: EdgeInsets.all(70.0),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Material(
                              child: Text('Image Not available', textAlign: TextAlign.center),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            imageUrl: response.toString(),
                            width: MediaQuery.of(context).size.width * 0.65,
                            height: MediaQuery.of(context).size.height * 0.3,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => FullPhoto(url: response.toString())));
                        },
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0)
                    )
    :
    Container(
      margin: EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 80.0,
            ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.all(Radius.circular(15.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            response,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
            maxLines: 6,
          ),
        ],
      ),
    );

    // if(response!="" && message!="")
    // isSending = false;

    // MAP of two containers together
    return Container(
      child: Column(
        children: <Widget>[
          botMessage,
          responseMsg
        ],
      ),
    );
  }

  _buildMessageComposer() {
    for(int i =0; i<liveResponses.length; i++){
      print('Questions with index: ' + messages[i].toString()+ i.toString());
      print('Live responses with index: ' + liveResponses[i].toString() + i.toString());
    }
    

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.videocam),
            iconSize: 25.0,
            color: Colors.grey,
            onPressed: () {}
          ),
          IconButton(
            icon: Icon(Icons.mic),
            iconSize: 25.0,
            color: Colors.grey,
            onPressed: () {
              _isAudioRecording?stopRecording():startRecording();
            }
          ),
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            iconSize: 25.0,
            color: Colors.grey,
            onPressed: () async{
              getImage(intents[messageCounter]);
              // messageCounter++;
            }
          ),
          Expanded(
            child: (liveResponses.length<messages.length)?
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    border: Border.all(color: Colors.black)
                  ),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: textEditingController,
                        minLines: 1,
                        maxLines: 6,
                        onChanged: (value) {},
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Aa',
                          hintStyle: TextStyle(color: Colors.grey)
                        ),
                ),
                      ),
                IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Colors.amber,
            onPressed: (){
              print('Msg counter: ' + messageCounter.toString());
              onSendMessage(textEditingController.text, 'text', intents[messageCounter]);
              isSending = true;
            },
          )
                    ],
                  ),
                  
                  )
              :(Text('Thanks for training!', style: TextStyle(color: Colors.black))),
          ),
          
        ],
      ),
    );
  }

  void _fetchBotIntentMessages() async{
    await Firestore.instance
    .collection('chat_script')
    .document('1')
    .collection('script')
    .getDocuments()
    .then((docs){
      for(var doc in docs.documents){
        scripts.add(doc);
        messages.add(doc.data["utterance"]);
        intents.add(doc.data["intent"]);
      }
    }).whenComplete((){
    setState(() {
      print('Bot messages received: '+ messages.length.toString());
    });
    });
  }

  void _fetchXpertResponseDocuments() async{
    await Firestore.instance
          .collection('xpert_master')
          .document('aamir-khan')
          .collection('responses')
          .getDocuments().then((docs){
            for(var doc in docs.documents){
              responses.add(doc);
            }
          }).whenComplete((){
            print('Xpert Response docs received: '+ responses.length.toString());
          });
  }

  @override
  void initState() {
    super.initState();
    _fetchBotIntentMessages();
    _fetchXpertResponseDocuments();
  }

  startRecording() async {
    try {
      Directory docDir = await getApplicationDocumentsDirectory();
      String newFilePath = pathDart.join(docDir.path, this.tempFilename);
      File tempAudioFile = File(newFilePath + '.m4a');
      // Scaffold.of(context).showSnackBar(new SnackBar(
      //   content: new Text("Recording."),
      //   duration: Duration(milliseconds: 1400),
      // ));
      if (await tempAudioFile.exists()) {
        await tempAudioFile.delete();
      }
      if (await AudioRecorder.hasPermissions) {
        await AudioRecorder.start(
            path: newFilePath, audioOutputFormat: AudioOutputFormat.AAC);
      } else {
        Fluttertoast.showToast(msg: "Error! Audio recorder lacks permissions.", backgroundColor: Colors.grey, textColor: Colors.white, toastLength: Toast.LENGTH_SHORT);
      }
      bool isRecording = await AudioRecorder.isRecording;
      setState(() {
        Recording(duration: new Duration(), path: newFilePath);
        Fluttertoast.showToast(msg: 'Recording: ' + isRecording.toString(), backgroundColor: Colors.grey, textColor: Colors.white, toastLength: Toast.LENGTH_SHORT);
        _isAudioRecording = isRecording;
        defaultAudioFile = tempAudioFile;
      });
    } catch (e) {
      print(e);
    }
  }

  stopRecording() async {
    await AudioRecorder.stop();
    bool isRecording = await AudioRecorder.isRecording;

    Directory docDir = await getApplicationDocumentsDirectory();

    setState(() {
      _isAudioRecording = isRecording;
      Fluttertoast.showToast(msg: 'Recorded: ' + defaultAudioFile.path, backgroundColor: Colors.grey, textColor: Colors.white, toastLength: Toast.LENGTH_SHORT);
      defaultAudioFile =
          File(pathDart.join(docDir.path, this.tempFilename + '.m4a'));
    });
  }

  @override
  Widget build(BuildContext context) {
    isMe = false;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            CircleAvatar(
          radius: 30.0,
          backgroundImage: widget.botPicUrl!=null?NetworkImage(widget.botPicUrl.toString()):
          AssetImage('assets/my_prof_pic.jpg'),
        ),
        SizedBox(width: 8.0,),
            Text(
              widget.incomingData["name"]??'Jaideep',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        elevation: 10.0,
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.more_horiz),
          //   iconSize: 30.0,
          //   color: Colors.white,
          //   onPressed: () {},
          // ),
        ],
      ),
      body: Theme(
        data: ThemeData(
          brightness: Brightness.dark
        ),
              child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 15.0),
                      itemCount: liveResponses.length + 1,
                      // itemCount: liveResponses.isEmpty? messageCounter+1:messageCounter+2, //messages.length
                      controller: listScrollController,
                      itemBuilder: (BuildContext context, int index) {
                        print('MESSAGES LENGTH: ' + messages.length.toString());
                        print('RESPONSES LENGTH: ' + liveResponses.length.toString());
                        
                        
                        String message = "";
                        String response = "";
                        String rspType = "text"; // default


                        if(index < messages.length){
                          message = messages[index];
                        }

                        if(index < liveResponses.length){
                          print('RSP type LEN: '+responseTypes.length.toString());
                          response = liveResponses[index];
                          rspType = responseTypes[index];
                        }

                        return _buildMessage(message, response, rspType);

                        // if(!isMe){
                        //   // messageCounter++;
                        //    return _buildMessage(message, isMe);
                        // }else {
                        //   if(response == "")
                        //   return Container(height: 0.0);
                        //   else
                        //   return _buildMessage(response, isMe);
                        // }
                       
                      },
                    ),
                  ),
                ),
              ),
              _buildMessageComposer(),
            ],
          ),
        ),
      ),
    );
  }
}