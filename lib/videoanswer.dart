import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class VideoAnswer extends StatefulWidget {
  @override
  _VideoAnswerState createState() => _VideoAnswerState();
}

class _VideoAnswerState extends State<VideoAnswer> {
  List<CameraDescription> cameras;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  CameraController controller;
  bool isReady = false;
  bool showCamera = false;

  @override
  void initState() {
    super.initState();
    setupCameras();
  }

  Future<void> setupCameras() async {
    try {
      cameras = await availableCameras();
      controller = new CameraController(cameras[0], ResolutionPreset.medium);
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
  Widget build(BuildContext context) {
    return null;
  }
}
