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

  final controller = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: controller,
      child: Scaffold(
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
                  FlatButton(
                    child: Text(
                      'share',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    color: Colors.blueAccent,
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

class Task {
  String task;
  double taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
}
