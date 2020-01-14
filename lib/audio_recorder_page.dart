import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as pathDart;
import 'package:xpert/videoanswerscreen.dart';

import 'global.dart';

class AudioRecordingFragment extends StatefulWidget {
  final incomingQuestion;
  final userDocId;
  final orderDocId;
  AudioRecordingFragment(
      {this.incomingQuestion, this.userDocId, this.orderDocId, key})
      : super(key: key);
  @override
  _AudioRecordingFragmentState createState() => _AudioRecordingFragmentState();
}

class _AudioRecordingFragmentState extends State<AudioRecordingFragment> {
  bool _isRecording = false;
  String tempFilename = "TempRecording";
  File defaultAudioFile;
  bool showBottom = false;
  bool onlyVideo = false;
  bool isUploading = false;
  bool isChatVideo = false;
  bool _paid = true;

  Future<String> _getProfImg() async {
    String profImgUrl;
    await Firestore.instance
        .collection('xpert_master')
        .document(widget.userDocId.toString())
        .get()
        .then((doc) {
      profImgUrl = doc.data["profile_image"];
    });
    return profImgUrl;
  }

  void _createNewOrder(String url) async{

    if(LAST_ORDER_NO == null)
    LAST_ORDER_NO = 0;

    Map<String, dynamic> order = new Map();
    order["message"] = widget.incomingQuestion;
    order["answer_url"] = url;
    order["date"] = DateFormat("MMMM dd, yyyy 'at' hh:mm:ss aaa").format(DateTime.now()) + ' UTC+' +DateTime.now().timeZoneOffset.toString().substring(0, 4);
    order["answer_type"] = "audio";
    order["status"] = "delivered";
    order["order_no"] = ++LAST_ORDER_NO;


    DocumentReference newOrderDoc = Firestore.instance.collection('xpert_master')
          .document(widget.userDocId)
          .collection('orders')
          .document();

    await Firestore.instance.runTransaction((transaction) async{
      await transaction.set(newOrderDoc, order);
      
    }).whenComplete((){
      isUploading = false;
      print("New order added with doc id: " + newOrderDoc.documentID);
    });
  }

  Future<String> uploadToStorage() async {
    String url;
    try {
      final DateTime now = DateTime.now();
      final int millSeconds = now.millisecondsSinceEpoch;
      final String month = now.month.toString();
      final String date = now.day.toString();
      final String storageId = (millSeconds.toString());
      final String today = ('$month-$date');

//  final file =  await ImagePicker.pickVideo(source: ImageSource.gallery);
      final file = defaultAudioFile;
      StorageReference ref = FirebaseStorage.instance
          .ref()
          .child("audio")
          .child(today)
          .child(storageId);
      StorageUploadTask uploadTask =
          ref.putFile(file, StorageMetadata(contentType: 'audio/m4a'));
      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
      url = (await downloadUrl.ref.getDownloadURL());

      print(url);
    } catch (error) {
      print(error);
      return null;
    }
    return url;
  }

  void _updateAnswerUrl(String url) async {
    print('URL: ' +
        url +
        'DOCID: ' +
        widget.userDocId.toString() +
        'orderDociID ' +
        widget.orderDocId.toString());
    await Firestore.instance
        .collection('xpert_master')
        .document(widget.userDocId.toString())
        .collection('orders')
        .document(widget.orderDocId.toString())
        .updateData({
      'answer_url': url,
      'status': 'delivered',
      'paid' : _paid?'Yes':'No',
      'answer_type': 'audio'
    }).whenComplete(() {
      print('Updated!');
      isUploading = false;
      // Navigator.pop(context);
      // Fluttertoast.showToast(
      //                                     msg: "Audio uploaded!",
      //                                     toastLength: Toast.LENGTH_SHORT,
      //                                     gravity: ToastGravity.BOTTOM,
      //                                     timeInSecForIos: 1,
      //                                     backgroundColor: Colors.grey,
      //                                     textColor: Colors.white,
      //                                     fontSize: 16.0);
    });
  }

  void _updateAcceptedStatus() async {
    await Firestore.instance
        .collection('xpert_master')
        .document(widget.userDocId.toString())
        .collection('orders')
        .document(widget.orderDocId.toString())
        .updateData(
            {'status': 'accepted', 'answer_type': 'audio'}).whenComplete(() {
      print('Accepted status!');
    });
  }

  stopRecording() async {
    _timeString = '';
    _start = 0;
    _timer.cancel();
    await AudioRecorder.stop();
    bool isRecording = await AudioRecorder.isRecording;

    Directory docDir = await getApplicationDocumentsDirectory();

    setState(() {
      _isRecording = isRecording;
      showBottom = true;
      _showSaveDialog();
      defaultAudioFile =
          File(pathDart.join(docDir.path, this.tempFilename + '.m4a'));
    });
  }

  _showSaveDialog() async {
    if (defaultAudioFile != null) {
      String basename = pathDart.basename(defaultAudioFile.path);
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Saved file $basename"),
        duration: Duration(milliseconds: 1400),
      ));

      setState(() {
        _isRecording = false;
      });
    }
  }

  void _startTimer() {
    startRecording();
    startTimer();
  }

  String _timeString = '0';
  Timer _timer;
  int _start = 0;

  ValueNotifier<String> _time = ValueNotifier<String>("");

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        // _time.notifyListeners();

        // _time.addListener((){
        //   _start  = _start + 1;
        //   _time.value = formatHHMMSS(_start);
        // });
        // setState(() {
        _start = _start + 1;
        _time.value = formatHHMMSS(_start);
        // }
        // );
      },
    );
  }

  // String _formatDateTime(DateTime dateTime) {
  //   return DateFormat.ms().format(dateTime);
  //   // return DateFormat('MM/dd/yyyy hh:mm:ss').format(dateTime);
  // }

  String formatHHMMSS(int seconds) {
    int hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (hours == 0) {
      return "$minutesStr:$secondsStr";
    }

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  startRecording() async {
    try {
      Directory docDir = await getApplicationDocumentsDirectory();
      String newFilePath = pathDart.join(docDir.path, this.tempFilename);
      File tempAudioFile = File(newFilePath + '.m4a');
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Recording."),
        duration: Duration(milliseconds: 1400),
      ));
      if (await tempAudioFile.exists()) {
        await tempAudioFile.delete();
      }
      if (await AudioRecorder.hasPermissions) {
        await AudioRecorder.start(
            path: newFilePath, audioOutputFormat: AudioOutputFormat.AAC);
      } else {
        Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text("Error! Audio recorder lacks permissions.")));
      }
      bool isRecording = await AudioRecorder.isRecording;
      setState(() {
        Recording(duration: new Duration(), path: newFilePath);
        _isRecording = isRecording;
        defaultAudioFile = tempAudioFile;
      });
    } catch (e) {
      print(e);
    }
  }

  String _profImgUrl;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.userDocId == null && widget.orderDocId == null)
    isChatVideo = true;
    _getProfImg().then((url) {
      setState(() {
        _profImgUrl = url;
      });
    });
  }

  @override
  void dispose(){
    isChatVideo = false;
    super.dispose();
  }

  /// Toggle recording audio
  Widget _toggleAudioWidget() {
    return showBottom && !_isRecording?Container(height:0.0):
    Row(
      children: <Widget>[
        Text(
          'TURN ON VIDEO',
          style: TextStyle(color: Colors.white, fontSize: 17.0,
          shadows: <Shadow>[
            Shadow(
              offset: Offset(0.0, 0.0),
              blurRadius: 3.0,
              color: Colors.black
            ),
            Shadow(
              offset: Offset(0.0, 0.0),
              blurRadius: 8.0,
              color: Colors.black
            ),
          ]
          ),
        ),
        Container(
          height: 20.0,
          child: CupertinoSwitch(
            activeColor: Colors.white,
            // activeTrackColor: Colors.white24,
            // inactiveThumbColor: Colors.grey,
            // inactiveTrackColor: Colors.blueGrey,
            value: onlyVideo,
            onChanged: (bool value) {
              print(value);
              setState(() {
                onlyVideo = value;
                if (onlyVideo) {
                  // Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CameraExampleHome(
                                incomingQuestion: widget.incomingQuestion,
                                docId: widget.userDocId,
                                orderDocId: widget.orderDocId,
                              )));
                  //           Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => Video(
                  //       incomingQuestion: widget.incomingQuestion,
                  //       userDocId: widget.userDocId,
                  //       orderDocId: widget.orderDocId,
                  //     ),
                  //   ),
                  // );
                }
              });
              // if (controller != null) {
              //   onNewCameraSelected(controller.description);
              // }
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AudioRecorder.isRecording,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Container();
          default:
            _isRecording = snapshot.data;
    //         return isUploading?
    //         Scaffold(
    //   body: Center(
    //     child: Container(
    //       height: 50.0,
    //       width: 50.0,
    //       child: CircularProgressIndicator(
    //         backgroundColor: Colors.amber,
    //       ),
    //     ),
    //   )
    // )
            return Stack(
              children: <Widget>[
                Align(
                  alignment: AlignmentDirectional.center,
                  child: Container(
                    child: IconTheme(
                      data: IconThemeData(
                          color: Colors.grey,
                          size: MediaQuery.of(context).size.width * 0.6),
                      child: Icon(Icons.mic),
                    ),
                    // decoration: BoxDecoration(
                    //     image: DecorationImage(
                    //         image: _profImgUrl!=null?NetworkImage(_profImgUrl):
                    //         AssetImage('assets/welcome1.png'),
                    //         fit: BoxFit.contain)),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.45),
                          child: _isRecording?Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle
            ),
            child: Center(
              child:
                   ValueListenableBuilder(
                                valueListenable: _time,
                                builder: (BuildContext context, String value,
                                    Widget child) {
                                  return Text(
                                          _time.value, //_timeString,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0),
                                        );
                                },
                              ),
            ),
          ):Container(height: 0.0,),
                        ),
                        // Row(
                        //   children: <Widget>[
                        //     IconTheme(
                        //       data: IconThemeData(color: Colors.red),
                        //       child: _isRecording
                        //           ? Icon(Icons.fiber_manual_record)
                        //           : Container(height: 1.0),
                        //     ),
                        //     ValueListenableBuilder(
                        //       valueListenable: _time,
                        //       builder: (BuildContext context, String value,
                        //           Widget child) {
                        //         return _isRecording
                        //             ? Text(
                        //                 _time.value, //_timeString,
                        //                 style: TextStyle(
                        //                     color: Colors.white,
                        //                     fontSize: 20.0),
                        //               )
                        //             : Container(
                        //                 height: 1.0,
                        //               );
                        //       },
                        //     ),
                        //   ],
                        // ),
                        isChatVideo?Container(height: 0.0):_isRecording
                            ? Container(height: 1.0)
                            : _toggleAudioWidget()
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Container(
                    child: Wrap(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
                          child:Container(
                                  height: MediaQuery.of(context).size.height * 0.17,
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  child: Card(
                                    elevation: 8.0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                                    color: _isRecording?Colors.transparent:Colors.white,
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            height: showBottom?MediaQuery.of(context).size.height * 0.09:MediaQuery.of(context).size.height * 0.12,
                                            child: SingleChildScrollView(
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    // 'sdasfbdkfbksdfksdjhfgkjdhflhfjf;lsjf;ljd;lgjf;lmbvmf;ljv;lrguvljfvl;m;fljgv;lmfv;lfbv;lfd;lb;aljfgotugjporeugpoerogju;dflbjmd bl,dvssmgc;,oa;dlka;ifpaovmrpvr,ef.',
                                                    widget.incomingQuestion,
                                                    textAlign: TextAlign.start,
                                                    // maxLines: 3,
                                                    style: TextStyle(
                                                        color: _isRecording?Colors.white:Colors.black, fontSize: 17.0,)),
                                                ),
                                              ),
                                          ),
                                          showBottom && !isChatVideo?Divider(
                                            color: Colors.grey,
                                            height: 5.0,
                                            thickness: 1.0,
                                          ):Container(height: 0.0,),
                                          showBottom && !isChatVideo?
                                            // padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
                                            Container(
                                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text('MARK ANSWER AS: ',
                                style: TextStyle(color: Colors.black, fontSize: 12.0)),
                            Text("PAID", style: TextStyle(color: Colors.black, fontSize: 12.0)),
                            CupertinoSwitch(
                                value: _paid,
                                onChanged: (value) {
                                  setState(() {
                                    _paid = value;
                                  });
                                },
                              ),
                          ],
                        ),
                                          ):Container(height: 0.0,),
                                        ],
                                      ),
                                  ),
                                ),),
                        // SingleChildScrollView(
                        //   child: Padding(
                        //     padding:
                        //         const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        //     child: Text(widget.incomingQuestion,
                        //         textAlign: TextAlign.center,
                        //         style: TextStyle(
                        //             color: Colors.white, fontSize: 16.0)),
                        //   ),
                        // ),
                        showBottom
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.refresh),
                                    iconSize: 40.0,
                                    onPressed: () {
                                      setState(() {
                                        // onResumeButtonPressed();
                                        showBottom = false;
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left:10.0),
                                    child: FlatButton(
                                      onPressed: () {
                                        print(
                                            "videoPath: ${defaultAudioFile.path}");
                                        setState(() {
                                          showBottom = false;
                                          isUploading = true;
                                        });
                                        if(widget.orderDocId != null){
                                          _updateAcceptedStatus();
                                        uploadToStorage().then((url) {
                                          _updateAnswerUrl(url);
                                        });
                                        } else if (widget.orderDocId==null && widget.userDocId == null){
                                          // setState(() {
                                          //   isChatAudio = true;
                                          // });
                                          Navigator.pop(context, defaultAudioFile.path);
                                          // uploadToStorage().then((url){
                                            
                                          //   // isChatAudio = false;
                                          // });
                                        } else {
                                          uploadToStorage().then((url){
                                            _createNewOrder(url);
                                          });
                                        }
                                        
                                        
                                        if(widget.orderDocId == null && widget.userDocId == null){
                                          Fluttertoast.showToast(
                                          msg: "Thanks! Sending your video message...",  
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIos: 2,
                                          backgroundColor: Colors.grey,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                        }else{
                                          Fluttertoast.showToast(
                                          msg: "Thanks! We are uploading your answer in the background - which will take a few minutes. In the meantime feel free to browse/answer other requests.",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIos: 2,
                                          backgroundColor: Colors.grey,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                        }

                                        if(!isChatVideo)
                                        Navigator.pop(context);
                                        
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(360.0)),
                                      color: Colors.white,
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              "Tap to send",
                                              style:
                                                  TextStyle(color: Colors.black, fontSize: 18.0),
                                            ),
                                          ),
                                          Icon(
                                            Icons.send,
                                            color: Colors.amber,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )
                              :
                              Padding(
                                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.2,
                                 right: MediaQuery.of(context).size.width * 0.2, top: 8.0, bottom: 8.0),
                                child: FlatButton(
                                  color: Colors.red,
                                  padding: EdgeInsets.all(10.0),
                                  shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(360.0)),
                                              child: Center(
                                                child: Text(
                                                  _isRecording?'Stop recording':'Tap to record',
                                                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                                                ),
                                              ),
                                              onPressed: (){
                                                _isRecording
                                          ? stopRecording()
                                          : _startTimer();
                                              },
                                ),
                              )
                            // : Center(
                            //     child: Container(
                            //       decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.circular(20.0),
                            //           border: Border.all(
                            //               width: 4.0, color: Colors.white)),
                            //       child: IconButton(
                            //         icon: _isRecording
                            //             ? Icon(Icons.stop)
                            //             : Icon(Icons.fiber_manual_record),
                            //         iconSize: 30.0,
                            //         color: Colors.red,
                            //         onPressed: () {
                            //           _isRecording
                            //               ? stopRecording()
                            //               : _startTimer();
                            //         },
                            //       ),
                            //     ),
                            //   ),
                        // Center(
                        //   child: FloatingActionButton(
                        //       backgroundColor: Colors.amber,
                        //       child: _isRecording
                        //           ? new Icon(Icons.stop, size: 36.0)
                        //           : new Icon(Icons.mic, size: 36.0),
                        //       disabledElevation: 0.0,
                        //       onPressed: () {
                        //         _isRecording ? stopRecording() : _startTimer();
                        //       }),
                        // ),
                        // showBottom?Container(height: 1.0,):
                        // Center(
                        //   child: _isRecording
                        //       ? new Text('Stop', textScaleFactor: 1.5)
                        //       : new Text('Record', textScaleFactor: 1.5),
                        // )
                      ],
                    ),
                  ),
                ),
              ],
            );
        }
      },
    );
  }
}
