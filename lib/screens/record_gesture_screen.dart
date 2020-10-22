import 'package:flutter/material.dart';
import 'package:gesture_collection_app/main.dart';
import 'package:gesture_collection_app/models/gesture.dart';
import 'package:gesture_collection_app/services/gesture_service.dart';
import 'package:gesture_collection_app/widgets/label_widget.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:sensors/sensors.dart';
import 'dart:async';

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
  var gestures = [];
  var a = [];
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
    gestureService = new GestureService();
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..stop();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white10,
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.white10,
                    height:
                        controller.value * MediaQuery.of(context).size.height,
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
                          animation: Tween<double>(begin: 0, end: 5)
                              .animate(controller),
                          builder: (context, child) {
                            return FloatingActionButton.extended(
                                onPressed: () {
                                  if (controller.isAnimating) {
                                    controller.stop();
                                  } else {
                                    accel = accelerometerEvents
                                        .listen((AccelerometerEvent event) {
                                      print(event);
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
                                      //xyz.add(event.x.toString());
                                      //xyz.add(event.y.toString());
                                      //xyz.add(event.z.toString());
                                      //abc.add(xyz);
                                      gestureService.addGesture(gesture);
                                      gestures.add(gesture);
                                      //GestureService.addGesture(gesture);
                                      /*Provider.of<GestureService>(context,
                                              listen: false)
                                          .addProduct(gesture);*/
                                      count++;
                                      //xyz = [];
                                      print(count);
                                      if (!controller.isAnimating) {
                                        count = 0;
                                        //print(abc);
                                        print(gestures);
                                        accel.cancel();
                                        return abc;
                                      }
                                    });

                                    controller.reverse(
                                        from: controller.value == 0.0
                                            ? 1.0
                                            : controller.value);
                                  }
                                },
                                icon: Icon(controller.isAnimating
                                    ? Icons.stop
                                    : Icons.play_arrow),
                                label: Text(
                                    controller.isAnimating ? "Stop" : "Play"));
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
