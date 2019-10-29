import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:audio_recorder/audio_recorder.dart';
// import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:xpert/audiotest.dart';
import 'package:xpert/homepage.dart';

class CameraExampleHome extends StatefulWidget {
  // List<CameraDescription> cameras;
  String incomingQuestion;
  final LocalFileSystem localFileSystem;
  var orderDocId;
  var docId;

  CameraExampleHome({this.incomingQuestion, this.orderDocId, this.docId, localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _CameraExampleHomeState createState() {
    return _CameraExampleHomeState();
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  throw ArgumentError('Unknown lens direction');
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _CameraExampleHomeState extends State<CameraExampleHome>
    with WidgetsBindingObserver {
  CameraController controller;
  String imagePath;
  String videoPath;
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;
  bool onlyVideo = true;
  Recording _recording = new Recording();
  bool isRecording = false;
  Random random = new Random();
  TextEditingController _controller = new TextEditingController();
  bool isReady = false;
  bool showBottom = true;
  bool _paid = false;

  List<CameraDescription> cameras;

  Future<String> uploadToStorage(String filePath) async {
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
      url = (await downloadUrl.ref.getDownloadURL());

      print(url);
    } catch (error) {
      print(error);
      return null;
    }
    return url;
  }

  Future<void> setupCameras() async {
    try {
      cameras = await availableCameras();
      controller = new CameraController(cameras[1], ResolutionPreset.medium);
      await controller.initialize();
    } on CameraException catch (_) {
      setState(() {
        isReady = false;
      });
    }
    setState(() {
      isReady = true;
    });
  }

  @override
  void initState() {
    setupCameras();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // CameraDescription cameraDescription = CameraDescription(lensDirection: CameraLensDirection.front);
    // onNewCameraSelected(cameraDescription);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _stopVideoPlayer();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller.description);
      }
    }
  }
  
  void _updateAnswerUrl(String url) async{
    print('URL: ' + url + 'DOCID: ' + widget.docId.toString() + 'orderDociID ' + widget.orderDocId.toString());
    await Firestore.instance
    .collection('xpert_master')
    .document(widget.docId.toString())
    .collection('orders')
    .document(widget.orderDocId.toString())
    .updateData({
      'answer_url': url,
      'status': 'delivered',
      'answer_type' : 'video'
    }).whenComplete((){
      print('Updated!');
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          Container(
            child: _cameraPreviewWidget(),
          ),
          Align(
            alignment: AlignmentDirectional.topStart,
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconTheme(
                        data: IconThemeData(color: Colors.red),
                        child: isRecording?Icon(Icons.fiber_manual_record):Container(height: 1.0),
                      ),
                      Text(
                _timeString,
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
                    ],
                  ),
                  
                  _cameraTogglesRowWidget(),
                ],
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                !showBottom? Container(
                  decoration: BoxDecoration(
                      color: Colors.grey
                   ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text('MARK ANSWER AS: ', style: TextStyle(color: Colors.black)),
                    Text(_paid? "PAID" : "FREE", style: TextStyle(color: Colors.black)),
                    CupertinoSwitch(
                      value: _paid,
                      onChanged: (value){
                        setState(() {
                         _paid = value;
                        });
                      },
                    ),
                  ],
                )
                ):Container(),
                Container(
                    decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(14.0),
                            topRight: Radius.circular(14.0))),
                    child: showBottom
                        ? Wrap(
                            children: <Widget>[
                              SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8.0, left: 8.0),
                                  child: Text(widget.incomingQuestion,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.0)),
                                ),
                              ),
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(
                                          width: 4.0, color: Colors.white)),
                                  child: IconButton(
                                    icon: isRecording
                                        ? Icon(Icons.stop)
                                        : Icon(Icons.fiber_manual_record),
                                    iconSize: 30.0,
                                    color: Colors.red,
                                    onPressed: () {
                                      _startTimer();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Wrap(
                            children: <Widget>[
                              SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8.0, left: 8.0),
                                  child: Text(widget.incomingQuestion,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.0)),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.refresh),
                                    onPressed: () {
                                      setState(() {
                                        // onResumeButtonPressed();
                                        showBottom = true;
                                      });
                                    },
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      print("videoPath: $videoPath");
                                      setState(() {
                                        showBottom = true;
                                      });
                                      uploadToStorage(videoPath).then((url){
                                        _updateAnswerUrl(url);
                                      });
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(360.0)),
                                    color: Colors.white,
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Tap to send",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        Icon(
                                          Icons.send,
                                          color: Colors.amber,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ) //todo,
                    ),
              ],
            ),
          ),
          // Align(
          //   alignment: AlignmentDirectional.bottomCenter,
          //   child: Container(
          //     decoration: BoxDecoration(
          //             color: Colors.black54,
          //             borderRadius: BorderRadius.only(
          //               topLeft: Radius.circular(14.0),
          //               topRight: Radius.circular(14.0)
          //             )
          //             ),
          //     height: MediaQuery.of(context).size.height * 1/6,
          //     child: Column(
          //       children: <Widget>[
          //           Container(
          //             padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
          //             child: Text(
          //               widget.incomingQuestion,
          //               textAlign: TextAlign.center,
          //               style: TextStyle(color: Colors.white, fontSize: 16.0),
          //             ),
          //           ),
          //         Container(
          //             decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(20.0),
          //                 border: Border.all(width: 4.0, color: Colors.white)),
          //             child: IconButton(
          //               icon: Icon(Icons.fiber_manual_record),
          //               iconSize: 30.0,
          //               color: Colors.red,
          //               onPressed: () {
          //                 _startTimer();
          //               },
          //             ),
          //           ),
          //       ],
          //     ),
          //   ),
          // ),

          //////////////////
          // Align(
          //     alignment: AlignmentDirectional.bottomCenter,
          //     child: Container(
          //       padding: const EdgeInsets.only(bottom: 10.0),
          //       child: Container(
          //         decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(20.0),
          //             border: Border.all(width: 4.0, color: Colors.white)),
          //         child: IconButton(
          //           icon: Icon(Icons.fiber_manual_record),
          //           iconSize: 30.0,
          //           color: Colors.red,
          //           onPressed: () {
          //             _startTimer();
          //           },
          //         ),
          //       ),
          //     )
          //     ),
          // Align(
          //   alignment: AlignmentDirectional.topCenter,
          //   child: Padding(
          //     padding: const EdgeInsets.only(top: 26.0),
          //     child: Text(
          //       _timeString,
          //       style: TextStyle(color: Colors.white, fontSize: 20.0),
          //     ),
          //   ),
          // ),
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0, right: 10.0),
              child: _thumbnailWidget(),
            ),
          )
        ],
      ),
    );
  }

  // Widget _onlyAudioButton() {
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         if (onlyAudio)
  //           onlyAudio = false;
  //         else
  //           onlyAudio = true;
  //       });
  //     },
  //     child: Container(
  //         decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(50.0),
  //             color: onlyAudio ? Colors.amber : Colors.grey),
  //         height: 50.0,
  //         width: 50.0,
  //         child: Icon(
  //           Icons.keyboard_voice,
  //         )),
  //   );
  // }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return Center(
        child: Container(
          padding: EdgeInsets.all(10.0),
          color: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(),
          ),
          // child: Text(
          //   'Choose front or rear camera from above to record your message!',
          //   style: TextStyle(
          //     color: Colors.white,
          //     fontSize: 24.0,
          //     fontWeight: FontWeight.w900,
          //   ),
          // ),
        ),
      );
    } else {
      return Center(
        child: Transform.scale(
          scale: 1 / controller.value.aspectRatio,
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(controller),
          ),
        ),
      );
    }
  }

  /// Toggle recording audio
  Widget _toggleAudioWidget() {
    return Row(
      children: <Widget>[
        Switch(
            activeColor: Colors.amber,
            activeTrackColor: Colors.amberAccent,
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.blueGrey,
            value: onlyVideo,
            onChanged: (bool value) {
              print(value);
              setState(() {
                onlyVideo = value;
                if(!onlyVideo){
                  Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AudioRecPage(
              incomingQuestion: widget.incomingQuestion,
              userDocId: widget.docId,
              orderDocId: widget.orderDocId,
            ),
          ),
        );
                }
              });
              // if (controller != null) {
              //   onNewCameraSelected(controller.description);
              // }
            },
          ),
        IconButton(
          icon: Icon(Icons.videocam),
          color: Colors.white,
          onPressed: () {},
        )
      ],
    );
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    return Container(
      height: 70.0,
      width: 70.0,
      child: Row(
        children: <Widget>[
          videoController == null && imagePath == null
              ? Container()
              : SizedBox(
                  child: (videoController == null)
                      ? Image.file(File(imagePath))
                      : Container(
                          child: Center(
                            child: AspectRatio(
                                aspectRatio: videoController.value.size != null
                                    ? videoController.value.aspectRatio
                                    : 1.0,
                                child: VideoPlayer(videoController)),
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.amber)),
                        ),
                  width: 64.0,
                  height: 64.0,
                ),
        ],
      ),
    );
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.camera_alt),
          color: Colors.blue,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  !controller.value.isRecordingVideo
              ? onTakePictureButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.videocam),
          color: Colors.blue,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  !controller.value.isRecordingVideo
              ? onVideoRecordButtonPressed
              : null,
        ),
        IconButton(
          icon: controller != null && controller.value.isRecordingPaused
              ? Icon(Icons.play_arrow)
              : Icon(Icons.pause),
          color: Colors.blue,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  controller.value.isRecordingVideo
              ? (controller != null && controller.value.isRecordingPaused
                  ? onResumeButtonPressed
                  : onPauseButtonPressed)
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          color: Colors.red,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  controller.value.isRecordingVideo
              ? onStopButtonPressed
              : null,
        )
      ],
    );
  }
static int cameraDir = 0;
  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    final List<Widget> toggles = <Widget>[];
    
    // List<CameraDescription> cameras;

    if (cameras == null) {
      return const Text('No camera found');
    } else {
      List<CameraDescription> camerasDesc = new List();
      for(CameraDescription cameraDescription in cameras) {
        camerasDesc.add(cameraDescription);
      }
      toggles.add( CircleAvatar(
        backgroundColor: Colors.grey,
              child: IconTheme(
              data: IconThemeData(color: Colors.white),
              child: IconButton(tooltip: 'Switch Camera',
                onPressed:(){
                    onNewCameraSelected(camerasDesc.elementAt(cameraDir));
                    if(cameraDir == 0)
                    cameraDir = 1;
                    else
                    cameraDir = 0;
                },
                icon: Icon(Icons.switch_camera),
              ),
        ),
      ));
      // for (CameraDescription cameraDescription in cameras) {
      //   toggles.add(
      //     SizedBox(
      //       width: 80.0,
      //       child: RadioListTile<CameraDescription>(
      //         title: Icon(
      //           getCameraLensIcon(cameraDescription.lensDirection),
      //           color: Colors.amber,
      //         ),
      //         activeColor: Colors.red,
      //         groupValue: controller?.description,
      //         value: cameraDescription,
      //         onChanged: controller != null && controller.value.isRecordingVideo
      //             ? null
      //             : onNewCameraSelected,
      //       ),
      //     ),
      //   );
      // }
      toggles.add(_toggleAudioWidget());
    }

    return Container(color: Colors.transparent, child: Row(children: toggles, mainAxisAlignment: MainAxisAlignment.end,));
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  String _timeString = '';
  Timer _timer;
  int _start = 0;

  //   void _getTime() {
  //   _start = _start + 1;
  //   final DateTime now = DateTime.fromMillisecondsSinceEpoch(_start * 1000);
  //   final String formattedDateTime = _formatDateTime(now);
  //   setState(() {
  //     _timeString = formattedDateTime;
  //   });
  // }

  void _startTimer() {
    if (isRecording) {
      setState(() {
        isRecording = false;
        _timeString = '';
        _start = 0;
        _timer.cancel();
        // if(!onlyAudio)
        onStopButtonPressed();
        // else _stopAudioRec();
      });
    } else {
      isRecording = true;
      startTimer();
      if (onlyVideo)
        onVideoRecordButtonPressed();
      else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AudioRecPage(
              incomingQuestion: widget.incomingQuestion,
              userDocId: widget.docId,
              orderDocId: widget.orderDocId,
            ),
          ),
        );
      }

      //   _timeString = _formatDateTime(DateTime.fromMillisecondsSinceEpoch(_start * 1000));
      // Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    }
  }

  // void _stopTimer() {
  //   setState(() {
  //     isRecording = false;
  //     _timeString = '';
  //   });
  // }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          _start = _start + 1;
          _timeString = formatHHMMSS(_start);
        },
      ),
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

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: true,
    );
    print('${controller.description}');

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
          videoController?.dispose();
          videoController = null;
        });
        if (filePath != null) showInSnackBar('Picture saved to $filePath');
      }
    });
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((String filePath) {
      if (mounted) setState(() {});
      // if (filePath != null) showInSnackBar('Saving video to $filePath');
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((_) {
      if (mounted)
        setState(() {
          showBottom = false;
        });
      // showInSnackBar('Video recorded to: $videoPath');
    });
  }

  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recording paused');
    });
  }

  void onResumeButtonPressed() {
    resumeVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recording resumed');
    });
  }

  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/XpertTV/Movies';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      videoPath = filePath;
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.stopVideoRecording();
      // setState(() {
      //   //todo
      // });
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    // await _startVideoPlayer();
  }

  Future<void> pauseVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> _stopVideoPlayer() async {
    videoController?.removeListener(videoPlayerListener);
    await videoController?.dispose();
  }

  Future<void> _startVideoPlayer() async {
    final VideoPlayerController vcontroller =
        VideoPlayerController.file(File(videoPath));
    videoPlayerListener = () {
      if (videoController != null && videoController.value.size != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        videoController.removeListener(videoPlayerListener);
      }
    };
    vcontroller.addListener(videoPlayerListener);
    await vcontroller.setLooping(true);
    await vcontroller.initialize();
    await videoController?.dispose();
    if (mounted) {
      setState(() {
        imagePath = null;
        videoController = vcontroller;
      });
    }
    await vcontroller.play();
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}

class CameraApp extends StatelessWidget {
  // var cameras;
  var incomingQuestion;
  var orderDocId;
  var docId;

  CameraApp(this.incomingQuestion, this.orderDocId, this.docId);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CameraExampleHome(
        incomingQuestion: incomingQuestion,
        orderDocId: orderDocId,
        docId: docId,
      ),
      theme: new ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.amber,
          primarySwatch: Colors.amber),
    );
  }
}