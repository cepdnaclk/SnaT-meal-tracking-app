import 'dart:io';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mobile_app/Theme/theme_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../constants.dart';
import 'Tab_Views/chart_view.dart';

class WeekChart extends StatelessWidget {
  const WeekChart({
    Key? key,
    required this.size,
    required this.max,
    required this.data,
    required this.controller,
    this.interval,
    this.dataLabelSettings,
    required this.showLabel,
    this.gradient,
  }) : super(key: key);
  final Size size;
  final double max;
  final List<Map> data;
  final double? interval;
  final ScreenshotController controller;
  final LinearGradient? gradient;
  final DataLabelSettings? dataLabelSettings;
  final bool showLabel;

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
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(
            height: size.height * 0.01,
          ),
          Text(
            showLabel ? weekChartText : dailyChartText,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color(0xff0f5951),
            ),
          ),
          Screenshot(
            controller: controller,
            child: CarouselSlider(
                items: [
                  for (int i = 0; i < data.length; i++)
                    SingleMealChart(
                      size: size,
                      data: data[i]['chartData'],
                      max: data[i]['max'],
                      title: meals[i],
                      controller: controller,
                    )
                ],
                options: CarouselOptions(
                    height: 330,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    viewportFraction: 0.90,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false)),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
        ],
      ),
    );
  }
}

class SingleMealChart extends StatelessWidget {
  const SingleMealChart(
      {Key? key,
      required this.size,
      required this.data,
      required this.max,
      required this.title,
      required this.controller})
      : super(key: key);
  final Size size;
  final List<ChartData> data;
  final double max;
  final String title;
  final ScreenshotController controller;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xfff5f4ec),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Spacer(),
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          const Spacer(),
          Center(
            child: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 250.0,
                  ),
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
                        isVisible: true,
                        placeLabelsNearAxisLine: true,
                        anchorRangeToVisiblePoints: true,
                        title: AxisTitle(text: "No. of servings for the date"),
                        majorGridLines: const MajorGridLines(
                          width: 0,
                        ),
                        minimum: 0,
                        maximum: max,
                        interval: max > 0 ? max : 1),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <ChartSeries<ChartData, String>>[
                      ColumnSeries<ChartData, String>(
                        dataLabelSettings: const DataLabelSettings(
                          //isVisible: true,
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
                        isTrackVisible: false,
                        trackColor: ThemeInfo.chartTrackColor,
                        yValueMapper: (ChartData data, _) => data.y,
                        /*dataLabelMapper: (ChartData data, _) =>
                        data.y == meals.length && showLabel
                            ? "✔"
                            : "",*/
                        pointColorMapper: (ChartData data, _) => data.color,
                        name: '',
                        animationDuration: 1000,
                        //gradient: gradient,
                        //color: const Color.fromRGBO(8, 142, 255, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
