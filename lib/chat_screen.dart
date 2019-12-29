import 'dart:async';
import 'dart:io';

import 'package:audio_recorder/audio_recorder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as pathDart;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xpert/audiotest.dart';
import 'package:xpert/chat_audio_player.dart';
import 'package:xpert/videoanswerscreen.dart';
import 'package:xpert/web_video_view.dart';
import 'package:thumbnails/thumbnails.dart';

class ChatScreen extends StatefulWidget {
  final botPicUrl;
  final userId;
  final orderDocId;
  final incomingData;
  final xpertData;
  
  ChatScreen({this.botPicUrl, this.orderDocId, this.userId, this.incomingData, this.xpertData});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver{

  String imageUrl;
  String audioUrl;
  File imageFile;
  bool isLoading;
  static bool isSending = false;
  bool _isAudioRecording = false;
  String tempFilename = DateTime.now().millisecondsSinceEpoch.toString(); //"TempRecording"
  File defaultAudioFile;
  bool isVideoPlaying = false;
List<String> _thumbnailPaths = List();

  final TextEditingController textEditingController = new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();
  var width;

  bool isMe = false;
  int messageCounter = 0;
  List<bool> onScreenLoading;
  List<bool> onScreenQuestionsShow;
  List<String> messages = new List();
  List<String> intents = new List();
  List<DocumentSnapshot> scripts = new List();
  // List<DocumentSnapshot> responses = new List();
  List<String> liveResponses = new List();
  List<String> responseTypes = new List();

   Future getImage(var intent) async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    String path;

    if (imageFile != null) {
      path = imageFile.path;
      setState(() {
        setState(() {
          isSending = true;
                liveResponses.add(path);
              responseTypes.add('image');
              });
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

  Future uploadAudioFile(String filePath, var intent) async{
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final file = File(filePath);
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(file);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      audioUrl = downloadUrl;
      isSending = true;
      liveResponses.removeLast();
        responseTypes.removeLast();
      setState(() {
              liveResponses.add(audioUrl);
              responseTypes.add('audio');
              });
      print('The audioUrl is: ' +audioUrl);
      onSendMessage(audioUrl, 'audio', intent);
    }, onError: (err) {
      Fluttertoast.showToast(msg: 'This file is not an audio');
    });
  }

    Future uploadToStorage(String filePath, var intent) async {
    String url;
    try {
      final DateTime now = DateTime.now();
      final int millSeconds = now.millisecondsSinceEpoch;
      final String month = now.month.toString();
      final String date = now.day.toString();
      final String storageId = (millSeconds.toString());
      final String today = ('$month-$date');

//  final file =  await ImagePicker.pickVideo(source: ImageSource.gallery);
      final file = File(filePath);
      StorageReference ref = FirebaseStorage.instance
          .ref()
          .child("video")
          .child(today)
          .child(storageId);
      StorageUploadTask uploadTask =
          ref.putFile(file, StorageMetadata(contentType: 'video/mp4'));
      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
      downloadUrl.ref.getDownloadURL().then((downloadurl){
        url = downloadurl;
        isSending = true;
        liveResponses.removeLast();
        responseTypes.removeLast();
        setState(() {
          liveResponses.add(url);
          responseTypes.add('video');
        });
        print('The Video url: ' + url);
        onSendMessage(url, 'video', intent);
      }, onError: (err) {
      Fluttertoast.showToast(msg: 'This file is not an video');
      });
      // url = (await downloadUrl.ref.getDownloadURL());

      print(url);
    } catch (error) {
      print(error);
      return null;
    }
  }

  void _updateDeliveredStatus() async {
    print('USER ID: ' + widget.userId.toString() + 'ORDER ID: ' + widget.orderDocId.toString());
    await Firestore.instance
        .collection('xpert_master')
        .document(widget.userId.toString())
        .collection('orders')
        .document(widget.orderDocId.toString())
        .updateData(
            {'status': 'delivered'}).whenComplete(() {
      print('Delivered status!');
    });
  }

  void onSendMessage(String content, String type, var intent) async{
    if (content.trim() != '') {
      textEditingController.clear();

// QuerySnapshot result = await Firestore.instance
//     .collection('xpert_master')
//           .document('aamir-khan')
//           .collection('responses')
//     .where('intent', isEqualTo: intent.toString())
//     .limit(1)
//     .getDocuments();

// if(result.documents.length == 0){

  Map<String, dynamic> responseData = new Map();
  responseData["response"] = content;
  responseData["intent"] = intent;
  responseData["response_type"] = type;
  responseData['amp_text_url'] = '';
  responseData['ans_end'] = '';
  responseData['ans_start'] = '';
  responseData['answer_status'] = 'custom';
  responseData['bucket1'] = '';
  responseData['bucket2'] = '';
  responseData['contributor_id'] = '';
  responseData['contributor_name'] = '';
  responseData['contributor_pic'] = '';
  responseData['date'] = '${DateTime.now()}';
  responseData['doc_type'] = '';
  responseData['fan_ltr'] = 0;
  responseData['fan_views'] = 0;
  responseData['fan_votes'] = 0;
  responseData['interest_ltr'] = 0;
  responseData['interest_views'] = 0;
  responseData['interest_votes'] = 0;
  responseData['interview_id'] = 0;
  responseData['language'] = 'en';
  responseData['ltr'] = 0;
  responseData['perishable'] = 'no';
  responseData['profession_ltr'] = 0;
  responseData['profession_views'] = 0;
  responseData['profession_votes'] = 0;
  responseData['question_id'] = 0;
  responseData['total_views'] = 0;
  responseData['total_votes'] = 0;
  responseData['profession'] = '';
  responseData['question'] = messages[messageCounter];
  responseData['source_url'] = '';
  responseData['transcript'] = '';
  responseData['xpert_name'] = widget.xpertData['name'];
  responseData['xpert_pic'] = widget.xpertData['profile_image'];
  responseData['contributor_auth_id'] = '';
  responseData['share_link'] = 'www.xpert.tv/cr/${widget.xpertData['slug']}';

  DocumentReference newIntentDoc = Firestore.instance.collection('xpert_master')
          .document(widget.userId)
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
            if(liveResponses.length >= messages.length){
              if(content != ""){
                setState(() {
                isSending = false;
                onScreenLoading[messageCounter] = true;
              });
              }
              
            }
            if(liveResponses.length < messages.length)
            setState(() {
              // liveResponses.add(content);
              // responseTypes.add(type);
              onScreenLoading[messageCounter] = true;
              messageCounter++;
              // if(messageCounter == messages.length - 1)
              // onScreenLoading[messageCounter] = true;
              onScreenQuestionsShow[messageCounter] = true;
              print('MSG COUNTER: ' + messageCounter.toString());
              if(content != "")
              isSending = false;
              print('LIVE RES LEN: ' + liveResponses.length.toString());
              // listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
            });
          });
        
// } 
// else{
    // var responseDocId = result.documents[0].documentID;

    // await Firestore.instance
    //       .collection('xpert_master')
    //       .document('aamir-khan')
    //       .collection('responses')
    //       .document(responseDocId.toString())
    //       .updateData({
    //         'response' : content,
    //         'response_type' : type
    //       }).whenComplete((){
    //         print('COntent was: '+ content);
    //         print('Type was: '+ type);
    //         print('Intent was: ' + intent.toString());
    //         print("Responses updated!");
    //         if(liveResponses.length < messages.length)
    //         setState(() {
    //           liveResponses.add(content);
    //           responseTypes.add(type);
    //           messageCounter++;
    //           if(content != "")
    //           isSending = false;
    //           print('LIVE RES LEN: ' + liveResponses.length.toString());
    //         });
    //         // listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    //       });
// }  
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

_getThumbnail(videoPathUrl) async {
  var appDocDir = await getApplicationDocumentsDirectory();
  final folderPath = appDocDir.path;
  String thumb = await Thumbnails.getThumbnail(
      thumbnailFolder: folderPath,
      videoFile: videoPathUrl,
      imageType: ThumbFormat.PNG,//this image will store in created folderpath
      quality: 30);
  print(thumb);
  return thumb;
}
int videothumbnailCounter = 0;
// building messages MAP
  _buildMessage(var message, var response, var rsptype, int index) {
    print('Message Build BOT msg: ' + message.toString());
    print('Message Build RESPONSE msg: ' + response.toString());
    print('INDEX: ' + index.toString());
    print(liveResponses.toString());
    print('thubmnailPaths: ' + _thumbnailPaths.toString());

    // if(rsptype == 'video' && index < messages.length)
    // {
    //   videoController = new VideoPlayerController.network(response);
    //   _initializeVideoPlayerFuture = videoController.initialize();
    // }

    // if(!isSending && index>=messages.length){
    //   index = messages.length - 1;
    //   onScreenLoading[index] = true;
    // }

    Container botMessage = message==""?Container(height:0.0):
    onScreenQuestionsShow[index]?Container(
      margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.015, //8.0
              bottom: MediaQuery.of(context).size.height * 0.015, // 8.0
              right: MediaQuery.of(context).size.width * 0.30, // 80.0
              left: MediaQuery.of(context).size.width * 0.012
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
    ):Container(height: 0.0,);

    Container responseMsg = response==""?
    Container(height:0.0)
    :
    rsptype=="video"?
    Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.015, //8.0
              bottom: MediaQuery.of(context).size.height * 0.015, //8.0
              left: MediaQuery.of(context).size.width * 0.30, // 80.0
              right: MediaQuery.of(context).size.width * 0.012),
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        image: DecorationImage(image: videothumbnailCounter<_thumbnailPaths.length?
        FileImage(File(_thumbnailPaths[videothumbnailCounter])):AssetImage('assets/def_prof_pic.png'),
         fit: BoxFit.cover),
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        
      ),
      child: Center(
        child: !onScreenLoading[index]?Container(
            height: 20.0,
            width: 20.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ):Container(
              child: IconButton(
                  color: Colors.amber,
                  iconSize: 50.0,
                  icon: Icon(Icons.play_arrow),
                  onPressed: (){
                    // isVideoPlaying?_stopVideoPlayer():_startVideoPlayer(response);
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>WebViewContainer(response))
                    );
                  },
                ),
            ),
      ),
    )
    // Container(
    //   margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.015, //8.0
    //           bottom: MediaQuery.of(context).size.height * 0.015, //8.0
    //           left: MediaQuery.of(context).size.width * 0.30, // 80.0
    //           right: MediaQuery.of(context).size.width * 0.012),
    //   width: MediaQuery.of(context).size.width * 0.4,
    //   height: MediaQuery.of(context).size.height * 0.3,
    //   child: SizedBox(
    //               child: Stack(
    //                 children: <Widget>[Container(
    //                           child: Center(
    //                             child: AspectRatio(
    //                                   aspectRatio: videoController.value.size != null
    //                                       ? videoController.value.aspectRatio
    //                                       : 1.0,
    //                                   child: VideoPlayer(videoController)),
    //                           ),
    //                           // ),
                              
    //                   // width: 64.0,
    //                   // height: 64.0,
    //           ),
    //           Center(
    //             child: !onScreenLoading[index]?Container(
    //         height: 20.0,
    //         width: 20.0,
    //         child: CircularProgressIndicator(
    //           valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
    //         ),
    //       ):Center(
    //         child: Container(
    //           child: IconButton(
    //               color: Colors.white,
    //               iconSize: 50.0,
    //               icon: Icon(Icons.play_arrow),
    //               onPressed: (){
    //                 // isVideoPlaying?_stopVideoPlayer():_startVideoPlayer(response);
    //                 Navigator.push(context,
    //                 MaterialPageRoute(builder: (context)=>WebViewContainer(response))
    //                 );
    //               },
    //             ),
    //         ),
    //       ),
    //           )
    //                 ],
    //               )),
    //     decoration: BoxDecoration(
    //                         borderRadius:  BorderRadius.all(Radius.circular(15.0))),
                        
    // )
    :
    rsptype=="audio"?
    Container(
      margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.015, //8.0
              bottom: MediaQuery.of(context).size.height * 0.015, //8.0
              left: MediaQuery.of(context).size.width * 0.30, // 80.0
              right: MediaQuery.of(context).size.width * 0.012
            ),
            // padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      height: 50.0,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.all(Radius.circular(15.0),
              ),
      ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('Audio message', style: (TextStyle(fontSize: 20.0)),
                ),
                  !onScreenLoading[index]?Container(
            height: 8.0,
            width: 8.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ):IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.play_arrow),
                    iconSize: 30.0,
                    onPressed: (){
                      Navigator.push(context,
    MaterialPageRoute(builder: (context)=> ChatAudioPlayer(audioUrl: response.toString(),))
    );
                    },
                  ),
              ],
            ),
    )
    :
    rsptype=="image"?
    Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.015, //8.0
              bottom: MediaQuery.of(context).size.height * 0.015, //8.0
              left: MediaQuery.of(context).size.width * 0.30, // 80.0
              right: MediaQuery.of(context).size.width * 0.012),
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        image: DecorationImage(image: FileImage(File(response)), fit: BoxFit.cover),
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        
      ),
      child: Center(
        child: !onScreenLoading[index]?Container(
            height: 20.0,
            width: 20.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ):Container(height: 0.0,),
      ),
    ):
    Container(
      margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.015, //8.0
              bottom: MediaQuery.of(context).size.height * 0.015, //8.0
              left: MediaQuery.of(context).size.width * 0.30, // 80.0
              right: MediaQuery.of(context).size.width * 0.012
            ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.all(Radius.circular(15.0),
              ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child:Text(
            response,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
            maxLines: 6,
          ),),
          !onScreenLoading[index]?Container(
            height: 8.0,
            width: 8.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ):Container(height: 0.0,width: 0.0)
        ],
      ),
    );

    if(rsptype == 'video' && index < messages.length){
      videothumbnailCounter++;
    }

    // MAP of two containers together
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          botMessage,
          responseMsg
        ],
      ),
    );
  }

  bool isBotTrained = false;

  _buildMessageComposer() {
    for(int i =0; i<liveResponses.length; i++){
      print('Questions with index: ' + messages[i].toString()+ i.toString());
      print('Live responses with index: ' + liveResponses[i].toString() + i.toString());
    }
    
    if(liveResponses.length >= messages.length){
      if(!isBotTrained){
        isBotTrained = true;
        _updateDeliveredStatus();
      }
      
      Fluttertoast.showToast(
        msg: 'Thanks for chatting!\nWe will use these responses to appropriately reply back to your fans.',
        backgroundColor: Colors.amber,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG
      );
      //return AlertDialog on finish;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: MediaQuery.of(context).size.height * 0.1,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.videocam),
            iconSize: 25.0,
            color: Colors.grey,
            onPressed: () async{
              if(liveResponses.length<messages.length && !isSending)
              await Navigator.push(context,
              MaterialPageRoute(builder: (context)=> CameraExampleHome(incomingQuestion: messages[messageCounter], docId: null, orderDocId: null,))
              ).then((url){
                if(url != null && url.toString().isNotEmpty){
                setState(() {
                  _getThumbnail(url).then((_url){
                    setState(() {
                      _thumbnailPaths.add(_url);
                    });
                  });
             isSending = true;
             liveResponses.add(url); // actually this is the local path
              responseTypes.add('video');
              // messageCounter++;
           });
           print('Returned video URL: ' + url);
           uploadToStorage(url, intents[messageCounter]);
                }
          //  onSendMessage(url, 'video', intents[messageCounter]);
              });
            }
          ),
          IconButton(
            icon: Icon(Icons.mic),
            iconSize: 25.0,
            color: Colors.grey,
            onPressed: () async{
              if(liveResponses.length<messages.length && !isSending){
                await Navigator.push(context,
                MaterialPageRoute(builder: (context)=>AudioRecPage(incomingQuestion: messages[messageCounter], userDocId: null, orderDocId: null,))
                ).then((url){
                  if(url != null && url.toString().isNotEmpty){
                  setState(() {
                    isSending = true;
                    liveResponses.add(url);
                    responseTypes.add('audio');
                  });
                  print('Returned Audio url: '+ url);
                  uploadAudioFile(url, intents[messageCounter]);
                  }
                  // onSendMessage(url, 'audio', intents[messageCounter]);
                });
              }
              // _isAudioRecording?stopRecording():startRecording();
            }
          ),
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            iconSize: 25.0,
            color: Colors.grey,
            onPressed: () async{
              if(liveResponses.length<messages.length && !isSending)
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
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: isSending?
                          Container(height: 0.0,)
                          :
                          TextField(
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
                      ),
                IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Colors.amber,
            onPressed: (){
              print('Msg counter: ' + messageCounter.toString());
              if(liveResponses.length<messages.length && !isSending){
                setState(() {
                isSending = true;
                liveResponses.add(textEditingController.text);
              responseTypes.add('text');
              });
                onSendMessage(textEditingController.text, 'text', intents[messageCounter]);
              
              }
              
            },
          )
                    ],
                  ),
                  )
              : Text('Thanks for training!', style: TextStyle(color: Colors.black))
                ),
          
          
        ],
      ),
    );
  }

  void _fetchBotIntentMessages() async{
    await Firestore.instance
    .collection('chat_script')
    .document(widget.incomingData['script_id'])
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
      onScreenLoading = List.filled(messages.length, false);
      onScreenQuestionsShow = List.filled(messages.length, false);
      if(messages.isNotEmpty)
      onScreenQuestionsShow[0] = true;
      print(onScreenLoading.toString());
    });
    });
  }

  // void _fetchXpertResponseDocuments() async{
  //   await Firestore.instance
  //         .collection('xpert_master')
  //         .document('aamir-khan')
  //         .collection('responses')
  //         .getDocuments().then((docs){
  //           for(var doc in docs.documents){
  //             responses.add(doc);
  //           }
  //         }).whenComplete((){
  //           print('Xpert Response docs received: '+ responses.length.toString());
  //         });
  // }

  @override
  void initState() {
    super.initState();
    _fetchBotIntentMessages();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    isBotTrained = false;
    super.dispose();
  }
      // @override
      // void didChangeAppLifecycleState(AppLifecycleState state) async{
      //   switch(state){
      // case AppLifecycleState.inactive:
      // case AppLifecycleState.paused:
      // case AppLifecycleState.suspending:
      // case AppLifecycleState.resumed:
      //    if(CHAT_URL != null){
      //      print('Returned video URL: ' + CHAT_URL);
      //      setState(() {
      //        isSending = true;
      //      });
      //      onSendMessage(CHAT_URL, 'video', intents[messageCounter]);
      //      CHAT_URL=null;
      //    }
      //    break;
      //   }
      // }

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
        print('Recording: '+ isRecording.toString());
        Fluttertoast.showToast(msg: 'Recording Your Audio message! Tap the Mic button again to stop.', backgroundColor: Colors.grey, textColor: Colors.white, toastLength: Toast.LENGTH_SHORT);
        _isAudioRecording = isRecording;
        defaultAudioFile = tempAudioFile;
      });
    } catch (e) {
      print(e);
    }
  }

  // stopRecording() async {
  //   await AudioRecorder.stop();
  //   bool isRecording = await AudioRecorder.isRecording;

  //   Directory docDir = await getApplicationDocumentsDirectory();

  //   setState(() {
  //     _isAudioRecording = isRecording;
  //     print('Recorded file: ' + defaultAudioFile.path);
  //     Fluttertoast.showToast(msg: 'Recorded your message!', backgroundColor: Colors.grey, textColor: Colors.white, toastLength: Toast.LENGTH_SHORT);
  //     defaultAudioFile =
  //         File(pathDart.join(docDir.path, this.tempFilename + '.m4a'));
  //         uploadAudioFile(intents[messageCounter]);
  //         liveResponses.add(defaultAudioFile.path); // temporary for UI
  //         responseTypes.add('audio'); 
  //         isSending = true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    videothumbnailCounter = 0;
    if(messages.length != 0)
    Timer(Duration(milliseconds: 300), ()=>listScrollController.jumpTo(listScrollController.position.maxScrollExtent));
    // Timer(Duration(milliseconds: 300), ()=>listScrollController.animateTo(0.0,
    //       curve: Curves.easeOut, duration: const Duration(milliseconds: 300)));
    return messages.length == 0?
    Center(
                                child: Container(
                                  width: 40.0,
                                  height: 40.0,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                                  ),
                                ),
                              )
    :
    Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            CircleAvatar(
          radius: 30.0,
          backgroundImage: widget.botPicUrl!=null?NetworkImage(widget.botPicUrl.toString()):
          AssetImage('assets/def_prof_pic.png'),
        ),
        SizedBox(width: 8.0,),
            Text(
              widget.incomingData["name"]??'',
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
                      // reverse: true,
                      shrinkWrap: true,
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
                        return _buildMessage(message, response, rspType, index);

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