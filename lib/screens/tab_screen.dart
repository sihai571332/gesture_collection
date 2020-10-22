import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:gesture_collection_app/main.dart';
import 'package:gesture_collection_app/screens/gesture_screen.dart';
import 'package:gesture_collection_app/screens/home_screen.dart';
import 'package:gesture_collection_app/widgets/label_widget.dart';
import 'package:gesture_collection_app/widgets/new_label_widget_old.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class TabScreen extends StatefulWidget {
  String newLabel;
  TabScreen({Key key, @required this.newLabel}) : super(key: key);

  @override
  //_TabScreenState createState() => _TabScreenState(newLabel: newLabel);
  _TabScreenState createState() => _TabScreenState(newLabel);
}

class _TabScreenState extends State<TabScreen> {
  //static const String _appName = 'Gesture Collection';
  /*final List<Widget> _pages = [
    LabelWidget(),
    GestureScreen(),
  ];*/
  //_TabScreenState({Key key, @required newLabel});

  String _newLabel;

  String get newLabel => _newLabel;

  set newLabel(String newLabel) {
    //_newLabel = newLabel;
    setState(() {
      _newLabel = newLabel;
    });
  }

  //_TabScreenState({Key key, @required this.newLabel});
  _TabScreenState(String newLabel) {
    _newLabel = newLabel;
  }

  String get getNewLabel {
    setState(() {
      _newLabel = newLabel;
    });
    return _newLabel;
  }

  @override
  void initState() {
    /*setState(() {
      _newLabel = newLabel;
    });*/
    updatelabels();
    createUser();
    super.initState();
  }

  static const String LABELS = 'labels';
  SharedPreferences prefs;

  List<String> get labels => <String>[
        'Select Label',
        'Running',
        'Standing',
        'Walking',
        'Walking Upstairs',
        'Walking Downstairs',
        'Laying',
        'Sitting'
      ];

  set labels(List<String> labels) {}

  getPage(String title) {
    final List<Map<String, Object>> _pages = [
      {
        'page': HomeScreen(newLabel: newLabel),
        'title': 'Gesture Collection',
      },
      {
        'page': GestureScreen(),
        'title': 'My Gestures',
      },
    ];
    return _pages[_selectedPageIndex][title];
  }

  /*final List<Map<String, Object>> _pages = [
    {
      'page': HomeScreen(''),
      'title': 'Gesture Collection',
    },
    {
      'page': GestureScreen(),
      'title': 'My Gestures',
    },
  ];*/
  int _selectedPageIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              //_pages[_selectedPageIndex]['title'],
              getPage('title'),
              textAlign: TextAlign.center,
              style: new TextStyle(fontSize: 32.0),
            ),
          ),
        ),
        //body: _pages[_selectedPageIndex]['page'],
        body: getPage('page'),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          //backgroundColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.grey,
          unselectedItemColor: Colors.white,
          //selectedItemColor: Theme.of(context).accentColor,
          selectedItemColor: Colors.yellowAccent,
          currentIndex: _selectedPageIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.bar_chart_sharp),
              title: Text('My Gestures'),
            ),
          ],
        ),
      ),
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Colors.green[800],
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

  readLabels() async {
    prefs = await SharedPreferences.getInstance();
    List<String> _labels = prefs.getStringList(LABELS);
    setState(() {
      labels = _labels;
      _newLabel = newLabel;
    });
  }

  Future<void> updatelabels() async {
    /*setState(() {
      _newLabel = newLabel;
    });*/
    prefs = await SharedPreferences.getInstance();
    List<String> _labels = prefs.getStringList(LABELS);
    if (_labels != null) {
      labels = _labels;
    } else {
      prefs.setStringList(LABELS, this.labels);
    }
  }

  Future<void> createUser() async {
    prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("userId");
    if (userId == null || userId == '') {
      var uuid = Uuid();
      prefs.setString("userId", uuid.v1());
    }
  }
}
