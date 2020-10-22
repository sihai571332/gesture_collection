import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gesture_collection_app/screens/tab_screen.dart';
import 'screens/record_gesture_screen.dart';
//import 'screens/recording.dart';
import 'dart:convert';

void main() {
  runApp(TabScreen());
}

class GestureApp extends StatelessWidget {
  static const String _appName = 'Gesture Collection';

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => RecordGestureScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              _appName,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        body: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: FittedBox(
                fit: BoxFit.contain, // otherwise the logo will be tiny
                child: const FlutterLogo(),
              ),
            ),
            /*new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(child: Container(height: 75, child: LabelWidget())),
              ],
            ),*/
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 75,
                    child: FloatingActionButton.extended(
                      heroTag: 'next1',
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      onPressed: () => _asyncInputDialog(context),
                      icon: Icon(Icons.add),
                      label: Text('Add a New Label'),
                    ),
                  ),
                ),
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 75,
                    child: FloatingActionButton.extended(
                      heroTag: 'next2',
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.black,
                      onPressed: () {
                        _navigateToNextScreen(context);
                      },
                      icon: Icon(Icons.play_arrow),
                      label: Text('Start Recording'),
                    ),
                  ),
                ),
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                    child: Container(height: 75, child: NewLabelWidget2())),
              ],
            ),
          ],
        ),
      ),
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],

        // Define the default font family.
        fontFamily: 'Raleway',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Raleway'),
        ),
      ),
    );
  }
}

class NewLabelWidget2 extends StatefulWidget {
  NewLabelWidget2({Key key}) : super(key: key);

  @override
  _NewLabelWidgetState createState() => _NewLabelWidgetState();
}

class _NewLabelWidgetState extends State<NewLabelWidget2> {
  TextEditingController _controller;

  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextField(
          controller: _controller,
          onSubmitted: (String value) async {
            await showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Adding "$value".'),
                  content: Text('Click OK to add "$value".'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

Future _asyncInputDialog(BuildContext context) async {
  String gestureName = '';

  return showDialog(
    context: context,
    barrierDismissible:
        false, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Input Label Name'),
        content: new Row(
          children: [
            new Expanded(
                child: new TextField(
              autofocus: true,
              decoration:
                  new InputDecoration(labelText: 'Label', hintText: 'Running'),
              onChanged: (value) {
                gestureName = value;
              },
            ))
          ],
        ),
        actions: [
          FlatButton(
            child: Text('Add'),
            onPressed: () {
              Navigator.of(context).pop(gestureName);
            },
          ),
        ],
      );
    },
  );
}
