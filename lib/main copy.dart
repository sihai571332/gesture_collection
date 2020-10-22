import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'screens/record_gesture_screen.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appName = 'Gesture Collection';

    return MaterialApp(
      title: appName,
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
      home: MyHomePage(
        title: appName,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => RecordGestureScreen()));
  }

  MyHomePage({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var json = JsonDecoder().convert(data);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(height: 100),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(child: Container(height: 75, child: MyStatefulWidget())),
            ],
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 75,
                  child: FloatingActionButton.extended(
                    heroTag: 'next1',
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.black,
                    onPressed: () => _asyncInputDialog(context),
                    icon: Icon(Icons.add),
                    label: Text('Add Label'),
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
        ],
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  String dropdownValue = 'Select a Label';
  List<String> item = <String>['Select Label', 'Running', 'Standing', 'Stairs'];
  // Future<void> addItemToList() async {
  //   final String name = await _asyncInputDialog(context);
  //   setState(() {
  //     item.insert(0,name);
  //
  //   });
  // }
  // var tagsJson = jsonDecode(arrayText)['tags'];
  // List<String> tags = tagsJson != null ? List.from(tagsJson) : null;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 30,
      elevation: 16,
      style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'Raleway',
          fontWeight: FontWeight.bold),
      underline: Container(
        height: 2,
        color: Colors.white,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: item.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
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
// class label{
//   final List<String> item = <String>[];
//   label({this.item});
// }
//
// List<label> parseJosn(String response) {
//   if(response==null){
//     return [];
//   }
//   final parsed =
//   json.decode(response.toString()).cast<Map<String, dynamic>>();
//   return parsed.map<Country>((json) => new Country.fromJson(json)).toList();
// }
// }
