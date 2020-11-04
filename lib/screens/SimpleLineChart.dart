import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:gesture_collection_app/models/gesture.dart';

class SimpleLineChart extends StatelessWidget {
  //final List<charts.Series> seriesList;
  final List<charts.Series> myList;
  final bool animate;

  SimpleLineChart(this.myList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory SimpleLineChart.withSampleData(List<Gesture> blah, int pick) {
    return new SimpleLineChart(
      drawLineC(blah,pick),
 //     _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  static List<charts.Series<fkme,double>> drawLineC(List<Gesture> blah, int pick){
    final List<fkme> data = [];
    switch(pick){
      case 0:
        for(int i = 0; i< blah.length; i++){
          data.add(new fkme(double.parse(blah[i].xData),i));
        }
        break;
      case 1:
        for(int i = 0; i< blah.length; i++){
          data.add(new fkme(double.parse(blah[i].yData),i));
        }
        break;
      case 2:
        for(int i = 0; i< blah.length; i++){
          data.add(new fkme(double.parse(blah[i].zData),i));
        }
        break;
      default:
        break;
    }
    // for(int i = 0; i< blah.length; i++){
    //   data.add(new fkme(double.parse(blah[i].xData),i));
    // }

    return [
      new charts.Series<fkme, double>(
        id: '',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (fkme lul, _) => lul.maby,
        measureFn: (fkme lul, _) => lul.spot,
        data: data,
      )
    ];

    // @override
    // Widget build(BuildContext context) {
    //   return new charts.LineChart(seriesList, animate: animate);
    // }
  }


  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(myList, animate: animate);
  }



  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      new LinearSales(0, 5),
      new LinearSales(1, 25),
      new LinearSales(2, 100),
      new LinearSales(3, 75),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}
class fkme {
  final double maby;
  final int spot;

  fkme(this.maby,this.spot);
}


/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}