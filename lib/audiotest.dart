import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:simple_permissions/simple_permissions.dart';

import 'audio_recorder_page.dart';

class AudioRecPage extends StatefulWidget {
  AudioRecPage({this.incomingQuestion, this.userDocId, this.orderDocId, key})
      : super(key: key);
  final incomingQuestion;
  final userDocId;
  final orderDocId;

  @override
  _AudioRecPageState createState() => _AudioRecPageState();
}

class _AudioRecPageState extends State<AudioRecPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: AudioRecordingFragment(
          incomingQuestion: widget.incomingQuestion,
          userDocId: widget.userDocId,
          orderDocId: widget.orderDocId,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  requestPermissions() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([
      PermissionGroup.microphone,
      PermissionGroup.mediaLibrary,
      PermissionGroup.storage,
      PermissionGroup.phone
    ]);
    return permissions;
  }
}
