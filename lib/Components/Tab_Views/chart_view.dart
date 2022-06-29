import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'dart:io';
import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ChartView extends StatefulWidget {
  const ChartView({Key? key}) : super(key: key);

  @override
  State<ChartView> createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  late List<charts.Series<Task, String>> _seriesPieData;
  late List<charts.Series<Pollution, String>> _seriesData;

  _generateData() {
    var data1 = [
      new Pollution(1980, 'Monday', 10),
      new Pollution(1980, 'Tuesday', 9),
      new Pollution(1980, 'Wednesday', 1),
      new Pollution(1980, 'Thursday', 10),
      new Pollution(1980, 'Friday', 2),
      new Pollution(1980, 'Saturday', 4),
      new Pollution(1980, 'Sunday', 7),
    ];

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
    _seriesData.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: '2017',
        data: data1,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Pollution pollution, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff990099)),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _seriesData = <charts.Series<Pollution, String>>[];
    _seriesPieData = <charts.Series<Task, String>>[];
    _generateData();
  }

  final controller = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Screenshot(
        controller: controller,
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                        color: Color(0xff629c44),
                        borderRadius: BorderRadius.circular(20.0)),
                    indicatorColor: Color(0xff1976d2),
                    tabs: [
                      Tab(text: "For Today"),
                      Tab(text: "This Week"),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.69,
                  child: TabBarView(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          padding: EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              const Text(
                                'Daily Nutrients intake',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff0f5951)),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Container(
                                height: size.height * 0.13,
                                width: size.width * 0.78,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade500,
                                      offset: Offset(0.0, 5.0),
                                      blurRadius: 5.0,
                                      spreadRadius: 1.0,
                                    ),
                                    BoxShadow(
                                        color: Colors.white,
                                        offset: Offset(0.0, 0.0))
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const <Widget>[
                                          Legend(
                                            colour: Color(0xff054840),
                                            text: 'Cereals and Starchy foods',
                                          ),
                                          Legend(
                                            colour: Color(0xff16867a),
                                            text: 'Vegetables',
                                          ),
                                          Legend(
                                            colour: Color(0xff85dad0),
                                            text: 'Fruit',
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const <Widget>[
                                          Legend(
                                            colour: Color(0xffb1dad6),
                                            text: 'Pulses Meat Fish',
                                          ),
                                          Legend(
                                            colour: Color(0xff7a7979),
                                            text: 'Beverages',
                                          ),
                                          Legend(
                                            colour: Color(0xff000000),
                                            text: 'Milk and Milk Products',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: charts.PieChart<String>(
                                  _seriesPieData,
                                  animate: true,
                                  animationDuration: Duration(seconds: 1),
                                  defaultRenderer: charts.ArcRendererConfig(
                                    arcWidth: 60,
                                    arcRendererDecorators: [
                                      charts.ArcLabelDecorator(
                                          labelPosition:
                                              charts.ArcLabelPosition.inside)
                                    ],
                                  ),
                                ),
                              ),
                              FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Share',
                                  style: TextStyle(fontSize: 12.0),
                                ),
                                color: Colors.teal.shade900,
                                textColor: Colors.white,
                                onPressed: () async {
                                  final image = await controller.capture();
                                  if (image == null) return;

                                  await saveImage(image);
                                  await saveAndShare(image);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.grey.shade300,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Text(
                                "Total intake for this week",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.teal.shade900,
                                ),
                              ),
                              Expanded(
                                child: charts.BarChart(
                                  _seriesData,
                                  animate: true,
                                  barGroupingType:
                                      charts.BarGroupingType.grouped,
                                  //behaviors: [new charts.SeriesLegend()],
                                  animationDuration: Duration(seconds: 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future saveAndShare(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/flutter.png');
    image.writeAsBytesSync(bytes);
    await Share.shareFiles([image.path]);
  }

  Future<String> saveImage(Uint8List bytes) async {
    await [Permission.storage].request();
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '_')
        .replaceAll(':', '_');
    final name = "screenshot_$time";
    final result = await ImageGallerySaver.saveImage(bytes, name: name);

    return result['filePath'];
  }
}

class Legend extends StatelessWidget {
  final String text;
  final Color colour;
  const Legend({
    Key? key,
    required this.text,
    required this.colour,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colour,
          ),
        ),
        SizedBox(
          width: 7.0,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class Task {
  String task;
  double taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
}

class Pollution {
  String place;
  int year;
  int quantity;

  Pollution(this.year, this.place, this.quantity);
}
