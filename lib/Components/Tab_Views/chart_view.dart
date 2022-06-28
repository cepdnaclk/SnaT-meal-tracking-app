import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ChartView extends StatefulWidget {
  const ChartView({Key? key}) : super(key: key);

  @override
  State<ChartView> createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  late List<charts.Series<Task, String>> _seriesPieData;

  _generateData() {
    var piedata = [
      new Task('Cereals and Starchy foods', 35.8, Color(0xff054840)),
      new Task('Vegetables', 8.3, Color(0xff16867a)),
      new Task('Fruits', 10.8, Color(0xff85dad0)),
      new Task('Pulses Meat Fish', 15.6, Color(0xffb1dad6)),
      new Task('Beverages', 19.2, Color(0xff7a7979)),
      new Task('Milk and Milk Products', 10.3, Color(0xff000000)),
    ];

    _seriesPieData.add(
      charts.Series(
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: 'Air Pollution',
        data: piedata,
        labelAccessorFn: (Task row, _) => '${row.taskvalue}',
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _seriesPieData = <charts.Series<Task, String>>[];
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                const Text(
                  'Daily Nutrients intake',
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0f5951)),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Expanded(
                  child: charts.PieChart<String>(
                    _seriesPieData,
                    animate: true,
                    animationDuration: Duration(seconds: 1),
                    behaviors: [
                      charts.DatumLegend(
                        outsideJustification:
                            charts.OutsideJustification.endDrawArea,
                        horizontalFirst: false,
                        desiredMaxRows: 3,
                        cellPadding:
                            const EdgeInsets.only(right: 10.0, bottom: 10.0),
                        entryTextStyle: charts.TextStyleSpec(
                            color: charts.MaterialPalette.purple.shadeDefault,
                            fontFamily: 'Georgia',
                            fontSize: 12),
                      )
                    ],
                    defaultRenderer: charts.ArcRendererConfig(
                      arcWidth: 75,
                      arcRendererDecorators: [
                        charts.ArcLabelDecorator(
                            labelPosition: charts.ArcLabelPosition.inside)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Task {
  String task;
  double taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
}
