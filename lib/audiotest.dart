import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:simple_permissions/simple_permissions.dart';

import 'audio_recorder_page.dart';

class AudioRecPage extends StatefulWidget {

  AudioRecPage({Key key}) : super(key: key);

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
        child: AudioRecordingFragment(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  requestPermissions() async {
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.microphone, PermissionGroup.mediaLibrary, PermissionGroup.storage, PermissionGroup.phone]);
    return permissions;
  }
}