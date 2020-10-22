import 'package:flutter/material.dart';
import 'package:gesture_collection_app/models/gesture.dart';
import 'package:gesture_collection_app/services/gesture_service.dart';
import 'package:provider/provider.dart';

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
