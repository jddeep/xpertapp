import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as pathDart;

class AudioRecordingFragment extends StatefulWidget {
  @override
  _AudioRecordingFragmentState createState() => _AudioRecordingFragmentState();
}

class _AudioRecordingFragmentState extends State<AudioRecordingFragment> {
  bool _isRecording = false;
  String tempFilename = "TempRecording";
  File defaultAudioFile;

  stopRecording() async {
    await AudioRecorder.stop();
    bool isRecording = await AudioRecorder.isRecording;

    Directory docDir = await getApplicationDocumentsDirectory();

    setState(() {
      _isRecording = isRecording;
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
            return Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/profile_pic.jpg'),
                          fit: BoxFit.cover)),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Spacer(flex: 1),
                      Text(_isRecording ? "Recording" : ""),
                      Spacer(),
                      Container(height: 300.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Container(width: 38.0),
                          Column(children: [
                            _isRecording
                                ? new Text('Stop', textScaleFactor: 1.5)
                                : new Text('Record', textScaleFactor: 1.5),
                            Container(height: 12.0),
                            new FloatingActionButton(
                              backgroundColor: Colors.amber,
                              child: _isRecording
                                  ? new Icon(Icons.stop, size: 36.0)
                                  : new Icon(Icons.mic, size: 36.0),
                              disabledElevation: 0.0,
                              onPressed:
                                  _isRecording ? stopRecording : startRecording,
                            ),
                          ]),
                        ],
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ],
            );
        }
      },
    );
  }
}
