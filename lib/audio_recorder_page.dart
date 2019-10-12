import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as pathDart;

class AudioRecordingFragment extends StatefulWidget {
  final incomingQuestion;
  AudioRecordingFragment({this.incomingQuestion, key}):super(key: key);
  @override
  _AudioRecordingFragmentState createState() => _AudioRecordingFragmentState();
}

class _AudioRecordingFragmentState extends State<AudioRecordingFragment> {
  bool _isRecording = false;
  String tempFilename = "TempRecording";
  File defaultAudioFile;



  stopRecording() async {
    _timeString = '';
        _start = 0;
        _timer.cancel();
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

  void _startTimer() {
    startRecording();
    startTimer();
  }
  String _timeString = '';
  Timer _timer;
  int _start = 0;

  void startTimer(){
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer)  {
        setState(() {
          _start = _start + 1;
          _timeString = formatHHMMSS(_start);
        }
        );
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
                          image: AssetImage('assets/my_prof_pic.jpg'),
                          fit: BoxFit.cover)),

                ),
                Align(
            alignment: AlignmentDirectional.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 26.0),
              child: Text(
                _timeString,
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ),
                Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14.0),
                        topRight: Radius.circular(14.0)
                      )
                      ),
              child: Wrap(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top:8.0, bottom: 8.0),
                      child: Text(
                        widget.incomingQuestion,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16.0)
                      ),
                    ),
                  ),
                          Center(
                            child: FloatingActionButton(
                              backgroundColor: Colors.amber,
                              child: _isRecording
                                  ? new Icon(Icons.stop, size: 36.0)
                                  : new Icon(Icons.mic, size: 36.0),
                              disabledElevation: 0.0,
                              onPressed: (){
                                _isRecording ? stopRecording() : _startTimer();
                              }
                            ),
                          ),
                          Center(
                            child: _isRecording
                                ? new Text('Stop', textScaleFactor: 1.5)
                                : new Text('Record', textScaleFactor: 1.5),
                          )
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
