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

class WeekChart extends StatefulWidget {
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

  @override
  State<WeekChart> createState() => _WeekChartState();
}

class _WeekChartState extends State<WeekChart> {
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

  final CarouselController carouselController = CarouselController();
  final CarouselController carouselController1 = CarouselController();
  int currentCard = 10000;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(
            height: widget.size.height * 0.01,
          ),
          Text(
            widget.showLabel ? weekChartText : dailyChartText,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color(0xff0f5951),
            ),
          ),
          Screenshot(
            controller: widget.controller,
            child: Column(
              children: [
                CarouselSlider(
                  items: [
                    for (int i = 0; i < widget.data.length; i++)
                      SingleMealChart(
                        size: widget.size,
                        data: widget.data[i]['chartData'],
                        max: widget.data[i]['max'],
                        title: meals[i],
                        controller: widget.controller,
                      ),
                  ],
                  options: CarouselOptions(
                      height: 330,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      viewportFraction: 0.90,
                      enlargeCenterPage: true,
                      onScrolled: (val) {
                        if (currentCard > (val?.round() ?? currentCard)) {
                          carouselController.previousPage();
                          currentCard = val!.round();
                        } else if (currentCard <
                            (val?.round() ?? currentCard)) {
                          carouselController.nextPage();
                          currentCard = val!.round();
                        }
                      },
                      onPageChanged: (val, _) {
                        print(val);
                      }),
                ),
                const SizedBox(
                  height: 20,
                ),
                CarouselSlider(
                  carouselController: carouselController,
                  items: [
                    for (int i = 0; i < widget.data.length; i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Opacity(
                            opacity: 0.5,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              width: width / 4,
                              alignment: Alignment.center,
                              child: Text(
                                meals[i - 1 < 0 ? 7 : i - 1],
                                overflow: TextOverflow.ellipsis,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: ThemeInfo.secondaryColor,
                                    width: 1,
                                  )),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.center,
                            child: Text(meals[i]),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: ThemeInfo.secondaryColor,
                                  width: 1,
                                )),
                          ),
                          Opacity(
                            opacity: 0.5,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              width: width / 4,
                              alignment: Alignment.center,
                              child: Text(
                                meals[i + 1 > 6 ? 0 : i + 1],
                                overflow: TextOverflow.ellipsis,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: ThemeInfo.secondaryColor,
                                    width: 1,
                                  )),
                            ),
                          ),
                        ],
                      ),
                  ],
                  options: CarouselOptions(
                    height: 30,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    viewportFraction: 1,
                    enlargeCenterPage: true,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: widget.size.height * 0.01,
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
