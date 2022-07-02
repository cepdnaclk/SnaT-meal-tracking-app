import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:io';
import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'chart_view_components/barchart_model.dart';
import 'chart_view_components/pieChart_model.dart';
import 'chart_view_components/share_button.dart';

class ChartView extends StatefulWidget {
  const ChartView({Key? key}) : super(key: key);

  @override
  State<ChartView> createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  late List<charts.Series<Task, String>> _seriesPieData;
  late List<charts.Series<WeekReport, String>> _seriesData;

  _generateData() {
    var data1 = [
      WeekReport('Monday', 35),
      WeekReport('Tuesday', 30),
      WeekReport('Wednesday', 40),
      WeekReport('Thursday', 25),
      WeekReport('Friday', 36),
      WeekReport('Saturday', 28),
      WeekReport('Sunday', 15),
    ];

    var piedata = [
      Task('Cereals and Starchy foods', 35.8, const Color(0xff054840)),
      Task('Vegetables', 8.3, const Color(0xff16867a)),
      Task('Fruits', 10.8, const Color(0xff85dad0)),
      Task('Pulses Meat Fish', 15.6, const Color(0xffb1dad6)),
      Task('Beverages', 19.2, const Color(0xff7a7979)),
      Task('Milk and Milk Products', 10.3, const Color(0xff000000)),
    ];

    _seriesPieData.add(
      charts.Series(
        domainFn: (Task task, _) => task.mealType,
        measureFn: (Task task, _) => task.serving,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorVal),
        id: 'Daily Nutrients',
        data: piedata,
        labelAccessorFn: (Task row, _) => '${row.serving}',
      ),
    );
    _seriesData.add(
      charts.Series(
        domainFn: (WeekReport pollution, _) => pollution.day,
        measureFn: (WeekReport pollution, _) => pollution.serves,
        id: '2017',
        data: data1,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (WeekReport pollution, _) =>
            charts.ColorUtil.fromDartColor(const Color(0xff990099)),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _seriesData = <charts.Series<WeekReport, String>>[];
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
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.075,
                  width: size.width * 0.9,
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "Total intake for this week",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0f5951),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                SizedBox(
                    height: size.height * 0.69,
                    width: size.width * 0.95,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.grey.shade300,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Expanded(
                                child: charts.BarChart(
                                  _seriesData,
                                  animate: true,
                                  animationDuration: const Duration(seconds: 1),

                                  /// Assign a custom style for the domain axis.
                                  ///
                                  /// This is an OrdinalAxisSpec to match up with BarChart's default
                                  /// ordinal domain axis (use NumericAxisSpec or DateTimeAxisSpec for
                                  /// other charts).
                                  domainAxis: const charts.OrdinalAxisSpec(
                                      renderSpec: charts.SmallTickRendererSpec(

                                          // Tick and Label styling here.
                                          labelStyle: charts.TextStyleSpec(
                                              fontSize: 7, // size in Pts.
                                              color:
                                                  charts.MaterialPalette.black),

                                          // Change the line colors to match text color.
                                          lineStyle: charts.LineStyleSpec(
                                              color: charts
                                                  .MaterialPalette.black))),

                                  /// Assign a custom style for the measure axis.
                                  primaryMeasureAxis: const charts
                                          .NumericAxisSpec(
                                      renderSpec: charts.GridlineRendererSpec(

                                          // Tick and Label styling here.
                                          labelStyle: charts.TextStyleSpec(
                                              fontSize: 14, // size in Pts.
                                              color:
                                                  charts.MaterialPalette.black),

                                          // Change the line colors to match text color.
                                          lineStyle: charts.LineStyleSpec(
                                              color: charts
                                                  .MaterialPalette.black))),
                                ),
                                // charts.BarChart(
                                //   _seriesData,
                                //   animate: true,
                                //   barGroupingType:
                                //       charts.BarGroupingType.grouped,
                                //   //behaviors: [new charts.SeriesLegend()],
                                //   animationDuration: const Duration(seconds: 1),
                                // ),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Button(
                                press: () async {
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
                    )),
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
