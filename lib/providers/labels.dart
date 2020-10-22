import 'package:flutter/material.dart';

class Labels with ChangeNotifier {
  List<String> _labels = [];

  List<String> get labels {
    _labels = [
      'Select Label',
      'Running',
      'Standing',
      'Walking',
      'Walking Upstairs',
      'Walking Downstairs',
      'Laying',
      'Sitting'
    ];

    return _labels;
  }

  void addLabel() {
    notifyListeners();
  }
}
