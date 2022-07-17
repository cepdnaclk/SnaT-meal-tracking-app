import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mobile_app/Theme/theme_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../constants.dart';
import 'Tab_Views/chart_view.dart';
import 'Tab_Views/chart_view_components/share_button.dart';

class ChartWidget extends StatelessWidget {
  ChartWidget(
      {Key? key,
      required this.size,
      required this.max,
      required this.data,
      this.controller,
      this.interval,
      this.dataLabelSettings,
      required this.showLabel,
      this.gradient,
      this.image})
      : super(key: key);
  final Size size;
  final double max;
  final List<ChartData> data;
  final double? interval;
  final TooltipBehavior _tooltip = TooltipBehavior(enable: true);
  final controller;
  final LinearGradient? gradient;
  final DataLabelSettings? dataLabelSettings;
  final bool showLabel;
  final String? image;

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

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              const Text(
                "Total intake for this week",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0f5951),
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              if (image != null)
                SizedBox(
                  height: size.height * 0.2,
                  width: size.height * 0.2,
                  child: Image.asset(
                    image!,
                    fit: BoxFit.contain,
                  ),
                ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                      majorGridLines: const MajorGridLines(
                        width: 0,
                      ),
                      labelIntersectAction: AxisLabelIntersectAction.trim,
                      labelRotation: 0,
                      labelStyle: const TextStyle(
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis)),
                  primaryYAxis: NumericAxis(
                      majorGridLines: const MajorGridLines(
                        width: 0,
                      ),
                      minimum: 0,
                      maximum: max,
                      interval: interval ?? 1),
                  tooltipBehavior: _tooltip,
                  series: <ChartSeries<ChartData, String>>[
                    ColumnSeries<ChartData, String>(
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      dataSource: data,
                      xValueMapper: (ChartData data, _) {
                        return data.x;
                      },
                      isTrackVisible: showLabel,
                      trackColor: ThemeInfo.chartTrackColor,
                      yValueMapper: (ChartData data, _) => data.y,
                      dataLabelMapper: (ChartData data, _) =>
                          data.y == meals.length && showLabel ? "✔" : "",
                      pointColorMapper: (ChartData data, _) => data.color,
                      name: 'Gold',
                      animationDuration: 1000,
                      gradient: gradient,
                      color: const Color.fromRGBO(8, 142, 255, 1),
                    ),
                  ],
                ),
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
    );
  }
}
