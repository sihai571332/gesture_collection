import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

var selectedLabel;

class LabelWidget extends StatefulWidget {
  String newLabel;
  LabelWidget({Key key, @required this.newLabel}) : super(key: key);
  String labelName = selectedLabel;

  @override
  _LabelWidgetState createState() => _LabelWidgetState(newLabel);
}

class _LabelWidgetState extends State<LabelWidget> {
  String dropdownValue = 'Select Label';
  SharedPreferences prefs;
  static const String LABELS = 'labels';
  List<String> labels = new List<String>();
  var _isInit = true;

  String _newLabel;
  //HomeScreen({Key key, @required this.newLabel}) : super(key: key);
  /*_LabelWidgetState(newLabel) {
    List<String> startLabels = <String>[
      'Select Label',
      'Running',
      'Standing',
      'Walking',
      'Walking Upstairs',
      'Walking Downstairs',
      'Laying',
      'Sitting'
    ];
    _newLabel = newLabel;
    if (!_isInit){
      
    }
    if (newLabel != null) {
      startLabels.add(newLabel);
      dropdownValue = newLabel;
    }
    labels = labels2;
    //labels.add(newLabel);
    updatelabels();
  }*/

  _LabelWidgetState(newLabel) {
    List<String> startLabels = <String>[
      'Select Label',
      'Running',
      'Standing',
      'Walking',
      'Walking Upstairs',
      'Walking Downstairs',
      'Laying',
      'Sitting'
    ];
    _newLabel = newLabel;
    if (_newLabel == null) {
      labels = startLabels;
      labels.sort((a, b) => a.length.compareTo(b.length));
    } else {
      if (labels.length == 0) {
        readLabels();
      }
    }
    if (newLabel != null) {
      labels.add(newLabel);
      labels.sort((a, b) => a.length.compareTo(b.length));
      dropdownValue = newLabel;
      updatelabels();
    }
    //labels = labels2;
    //labels.add(newLabel);
    //updatelabels();
  }

  List<String> labels2 = <String>[
    'Select Label',
    'Running',
    'Standing',
    'Walking',
    'Walking Upstairs',
    'Walking Downstairs',
    'Laying',
    'Sitting'
  ];

  @override
  void initState() {
    _isInit = false;
    //updatelabels();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DropdownButton<String>(
          value: dropdownValue,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.white, fontSize: 20),
          underline: Container(
            height: 2,
            color: Colors.white70,
          ),
          onChanged: (String labelValue) {
            setState(() {
              dropdownValue = labelValue;
              //_newLabel = newValue;
              selectedLabel = dropdownValue;
            });
          },
          isExpanded: true,
          items: labels.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: SizedBox(
                width: 350.0,
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> readLabels() async {
    prefs = await SharedPreferences.getInstance();
    List<String> _labels = prefs.getStringList(LABELS);
    setState(() {
      if (!_labels
          .map((e) => e.toLowerCase())
          .contains(_newLabel.toLowerCase())) {
        _labels.add(_newLabel);
      }
      labels = _labels.toSet().toList();
      labels.sort((a, b) => a.length.compareTo(b.length));
    });
  }

  Future<void> updatelabels() async {
    prefs = await SharedPreferences.getInstance();
    List<String> _labels = prefs.getStringList(LABELS);
    if (_labels != null && _newLabel != null) {
      if (!_labels
          .map((e) => e.toLowerCase())
          .contains(_newLabel.toLowerCase())) {
        _labels.add(_newLabel);
      }
      //labels = _labels.toSet().toList();
      //dropdownValue = _newLabel;
      prefs.setStringList(LABELS, this.labels);
    } else {}
  }

  Future<List<String>> updatelabels2() async {
    prefs = await SharedPreferences.getInstance();
    List<String> _labels = prefs.getStringList(LABELS);
    if (_labels != null && _newLabel != null) {
      if (!_labels
          .map((e) => e.toLowerCase())
          .contains(_newLabel.toLowerCase())) {
        _labels.add(_newLabel);
      }
      labels = _labels.toSet().toList();
      dropdownValue = _newLabel;
      prefs.setStringList(LABELS, this.labels);
    } else {}

    return labels;
  }
}
