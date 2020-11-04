import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GestureScreen extends StatefulWidget {
  String newLabel;

  GestureScreen({Key key}) : super(key: key);

  @override
  _GestureScreenState createState() => _GestureScreenState();
}

class _GestureScreenState extends State {
  var _isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      //Provider.of<GestureService>(context).getGestures();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Gestures Analytics',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
