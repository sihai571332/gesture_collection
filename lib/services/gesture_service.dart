import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import 'package:gesture_collection_app/models/gesture.dart';
import 'package:firebase_database/firebase_database.dart';

class GestureService extends Service {
  final _firebase = FirebaseDatabase.instance.reference();
  static const url = 'https://gesturedata-76273.firebaseio.com/gestures.json';

  List<Gesture> _gestures = [];

  Future<void> addGesture(List<Gesture> gestures) async {
    try {
      int temp = 0;
      while(gestures.length>temp) {
        Gesture gesture = gestures[temp];
        final response = await http.post(url,
            body: json.encode({
              'userId': gesture.userId,
              'label': gesture.label,
              'xData': gesture.xData,
              'yData': gesture.yData,
              'zData': gesture.zData,
              'dateAdded': gesture.dateAdded
            }));
        temp ++;
      }
    } catch (e) {
      // TODO
    }
  }

  Future<void> getGestures() async {
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Gesture> loadedGestures = [];
      extractedData.forEach((userId, gestureData) {
        loadedGestures.add(Gesture(
          userId,
          gestureData['label'],
          gestureData['xData'],
          gestureData['yData'],
          gestureData['zData'],
          gestureData['dateAdded'],
        ));
      });
      return loadedGestures;
    } catch (error) {
      throw (error);
    }

    //id, label, xData, yData, zData, dateAdded
  }

  // Future<void> addGesture(Gesture gesture) async {
  //   try {
  //     _firebase.set({
  //       'userId': gesture.userId,
  //       'label': gesture.label,
  //       'xData': gesture.xData,
  //       'yData': gesture.yData,
  //       'zData': gesture.zData,
  //       'dateAdded': gesture.dateAdded
  //     });
  //   } catch (e) {
  //     // TODO: close
  //   }
  // }

  // Future getGestures() async {
  //   try {
  //     _firebase.child('gestures').once().then((DataSnapshot snapshot) {
  //       final List<Gesture> loadedGestures = [];
  //       Map<dynamic, dynamic> extractedData = snapshot.value;
  //       extractedData.forEach((userId, gestureData) {
  //         loadedGestures.add(Gesture(
  //           userId,
  //           gestureData['label'],
  //           gestureData['xData'],
  //           gestureData['yData'],
  //           gestureData['zData'],
  //           gestureData['dateAdded'],
  //         ));
  //       });
  //
  //       print('Here is loaded gesture $loadedGestures');
  //       return loadedGestures;
  //     });
  //   } catch (error) {
  //     throw (error);
  //   }
  // }

  /*Future<void> addProduct(Gesture gesture) async {
    try {
      final response = await http.post(url,
          body: json.encode({
            'userId': gesture.userId,
            'label': gesture.label,
            'xData': gesture.xData,
            'yData': gesture.yData,
            'zData': gesture.zData,
            'dateAdded': gesture.dateAdded
          }));
    } catch (e) {
      // TODO
    }
  }*/

  /*Future<void> updateGesture(String id, Gesture gesture) async {
    final gestureIndex = _gestures.indexWhere((element) => element.id == id);
    final url = 'https://gesture-collection.firebaseio.com/gestures/$id.json';
    try {
      if (gestureIndex >= 0) {
        await http.patch(url,
            body: json.encode({
              'userId': gesture.userId,
              'label': gesture.label,
              'xData': gesture.xData,
              'yData': gesture.yData,
              'zData': gesture.zData,
              'dateAdded': gesture.dateAdded
            }));
      }
    } catch (e) {
      // TODO
    }
  }*/

  /*void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }*/

  /*Future<void> deleteGesture(String id) async {
    final gestureIndex = _gestures.indexWhere((element) => element.id == id);
    final url = 'https://gesture-collection.firebaseio.com/gestures/$id.json';
    var existingGesture = _gestures[gestureIndex];
    _gestures.removeAt(gestureIndex);
    try {
      http.delete(url).then((value) => existingGesture = null);
    } catch (e) {
      _gestures.insert(gestureIndex, existingGesture);
    }
    //notifyListeners();
  }*/
}
