import 'package:flutter/material.dart';
import 'package:new_trend/widgets/timer_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RecorderScreen extends StatefulWidget {
  @override
  _RecorderScreenState createState() => _RecorderScreenState();
}

class _RecorderScreenState extends State<RecorderScreen> {
  Stopwatch stopwatch = new Stopwatch();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.orangeAccent.withOpacity(0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildRecordingStatus(),
            buildTimerText(),
            buildButtonRow(context),
          ],
        ),
      ),
    );
  }

  void stopButtonPressed() {
    setState(() {
      stopwatch
        ..stop()
        ..reset();
    });
  }

  void rightButtonPressed() {
    setState(() {
      if (stopwatch.isRunning) {
        stopwatch.stop();
      } else {
        stopwatch.start();
      }
    });
  }

  Widget buildTimerText(){
    return Container(
        height: 200.0,
        child: new Center(
          child: new TimerText(stopwatch: stopwatch),
        ));
  }

  Widget buildRecordingStatus(){
    return Container(
        height: 100.0,
        width: 100.0,
        child: stopwatch.isRunning
            ? Center(
          child: SpinKitWave(
              color: Colors.black87.withOpacity(0.7),
              type: SpinKitWaveType.start),
        )
            : Image.asset("assets/recorder.png"));
  }

  Widget buildButtonRow(BuildContext context){
    return Row(children: <Widget>[
      buildButton(
          stopButtonPressed,
          Colors.redAccent,
          context,
          Icons.stop),
      buildButton(
          rightButtonPressed,
          Colors.blueAccent,
          context,
          stopwatch.isRunning ? Icons.pause : Icons.play_arrow),
    ]);
  }

  Widget buildButton(
      VoidCallback callback, Color color, BuildContext context, IconData icon) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width * 0.5,
        alignment: Alignment.center,
        child: RaisedButton(
          elevation: 0.0,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(36.0)),
          color: color,
          onPressed: callback,
          child: Container(
            width: size.width * 0.5 - 80.0,
            height: MediaQuery.of(context).size.width * 0.15,
            child: Icon(
              icon,
              color: Colors.white,
              size: 32.0,
            ),
          ),
        ));
  }
}
