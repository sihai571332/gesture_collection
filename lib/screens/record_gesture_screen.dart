import 'package:flutter/material.dart';
import 'package:gesture_collection_app/main.dart';
import 'package:gesture_collection_app/models/gesture.dart';
import 'package:gesture_collection_app/services/gesture_service.dart';
import 'package:gesture_collection_app/widgets/label_widget.dart';
import 'package:gesture_collection_app/screens/SimpleLineChart.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:sensors/sensors.dart';
import 'dart:async';

import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:vibration/vibration.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class RecordGestureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CountDownTimer(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        accentColor: Colors.indigo,
      ),
    );
  }
}

class CountDownTimer extends StatefulWidget {
  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  String selecteLabel = LabelWidget().labelName;
  AnimationController controller;

  @override
  bool get wantKeepAlive => true;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  int count = 0;
  String userId = '';
  var xyz = [];
  var abc = [];
  List<Gesture> gestures = [];
  var a = [];
  var x_data = [];
  var y_data = [];
  var z_data = [];
  int temp = 0;
  AccelerometerEvent event;
  Timer timer;
  StreamSubscription accel;
  SharedPreferences prefs;
  GestureService gestureService;

  Future<void> createUser() async {
    prefs = await SharedPreferences.getInstance();
    String _userId = prefs.getString("userId");
    if (_userId == null || userId == '') {
      var uuid = Uuid();
      prefs.setString("userId", uuid.v1());
    }
    userId = _userId;
  }

  var l;

  // List<MeasuredDataObject> l = [];
  @override
  void initState() {
    super.initState();
    gestureService = new GestureService();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..stop();
  }

  @override
  Widget build(BuildContext mainContext) {
    ThemeData themeData = Theme.of(mainContext);
    return Scaffold(
      backgroundColor: Colors.white10,
      body: AnimatedBuilder(
          animation: controller,
          builder: (mainContext, child) {
            return Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.white10,
                    height: controller.value *
                        MediaQuery.of(mainContext).size.height,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.center,
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: CustomPaint(
                                      painter: CustomTimerPainter(
                                    animation: controller,
                                    backgroundColor: Colors.white,
                                    color: themeData.indicatorColor,
                                  )),
                                ),
                                Align(
                                  alignment: FractionalOffset.center,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Recording Gesture",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        timerString,
                                        style: TextStyle(
                                            fontSize: 112.0,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      AnimatedBuilder(
                          animation: Tween<double>(begin: 0, end: 3)
                              .animate(controller),
                          builder: (mainContext, child) {
                            return FloatingActionButton.extended(
                                onPressed: () {
                                  if (controller.isAnimating) {
                                    controller.stop();
                                  } else {
                                    AssetsAudioPlayer.playAndForget(
                                        Audio("assets/audio/test.wav"));
                                    accel = accelerometerEvents.listen(
                                        (AccelerometerEvent event) async {
                                      print(event);
                                      x_data.add(new fkme(event.x,temp));
                                      y_data.add(new fkme(event.y,temp));
                                      z_data.add(new fkme(event.z,temp));
                                      temp++;
                                      xyz.add(DateTime.now()
                                          .millisecondsSinceEpoch);
                                      if (userId == '') {
                                        createUser();
                                      }
                                      print(selecteLabel);
                                      int dateAdded =
                                          DateTime.now().millisecondsSinceEpoch;
                                      Gesture gesture = new Gesture(
                                          userId,
                                          selecteLabel,
                                          event.x.toString(),
                                          event.y.toString(),
                                          event.z.toString(),
                                          dateAdded);
                                      gestures.add(gesture);
                                      count++;

                                      if (!controller.isAnimating) {
                                        count = 0;
                                        Vibration.vibrate(duration: 1000);
                                        showCharts(mainContext, gestures);
                                        // for(int i = 0; i< x_data.length;i++){
                                        //   print(x_data[i].maby+" "+x_data[i].spot);
                                        // }
                                        print("Showing Charts");
                                        ciller(mainContext,gestures);
                                        //completeDialog(mainContext, gesture);

                                        x_data = [];
                                        y_data = [];
                                        z_data = [];
                                        temp = 0;
                                        accel.cancel();
                                        return abc;
                                      }
                                    });

                                    controller.reverse(
                                        from: controller.value == 0.0
                                            ? 1.0
                                            : controller.value);
                                  }//after else




                                  //before rest
                                },
                                icon: Icon(controller.isAnimating
                                    ? Icons.stop
                                    : Icons.play_arrow),
                                label: Text(controller.isAnimating
                                    ? "Stop"
                                    : "Start Recording"));
                          }),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
    @override
    void dispose() {
      timer?.cancel();
      accel?.cancel();
    }
  }
}

void ciller(BuildContext context, List<Gesture> gesture) {
  switch (showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return new GestureDetector(onDoubleTap: () {
          //print("Double Tap Detected");
          completeDialog(context, gesture);
        });
      })) {
  }
}

void completeDialog(BuildContext context, List<Gesture> gesture) {
  switch (showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return new
        // GestureDetector(onDoubleTap: () {
        //   print("Double Tap Detected");
          SimpleDialog(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Do you want to save this gesture?'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            print('Cancelled');
                            Navigator.pop(dialogContext);
                          },
                          textColor: Colors.white,
                          color: Colors.redAccent,
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            child: const Text('Cancel',
                                style: TextStyle(fontSize: 20)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            GestureService().addGesture(gesture);
                            Navigator.pop(dialogContext);
                          },
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            child: const Text('Save',
                                style: TextStyle(fontSize: 20)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
  //      });
      })) {
  }
}

void showCharts(BuildContext context, List<Gesture> gesture) {
  switch (showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return new Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              "Charts",
              style: TextStyle(color: Colors.blueGrey),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.blueGrey),
          ),
          body: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  // X plot
                  Container(
                      width: 200.0,
                      height: 200.0,
                      child: SimpleLineChart.withSampleData(gesture,0)),
                  // Y plot
                  Container(
                      width: 200.0,
                      height: 200.0,
                      child: SimpleLineChart.withSampleData(gesture,1)),
                  // Z plot
                  Container(
                    height: 200.0,
                    width: 200.0,
                    child: SimpleLineChart.withSampleData(gesture,2),
                  ),
                ],
              ),
            ],
          ), //<-- I've added this line
        );
      })) {
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);

    // Accelerometer events come faster than we need them so a timer is used to only proccess them every 200 milliseconds
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
