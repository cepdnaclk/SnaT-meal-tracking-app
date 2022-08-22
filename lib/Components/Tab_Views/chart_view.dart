import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mobile_app/Components/today_chart.dart';
import 'package:mobile_app/Components/week_chart.dart';
import 'package:mobile_app/Services/firebase_services.dart';
import 'package:mobile_app/Theme/theme_info.dart';
import 'package:mobile_app/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'chart_view_components/share_button.dart';

Map todayStat = {};
List<Map<String, dynamic>> weekStat = [];

class ChartView extends StatefulWidget {
  const ChartView({Key? key}) : super(key: key);

  @override
  State<ChartView> createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  late Future _generateData;
  List<ChartData> todayChartData = [];
  List<Map> weekChartData = [];
  double todayMax = 0;
  double weekMax = 0;
  String image = happyImage;
  generateData() async {
    await FirebaseServices.fetchStats();
    int i = 0;
    for (String meal in meals) {
      Color valueColor = todayStat[meal] < limits[meal]![0]
          ? ThemeInfo.chartBelowColor
          : todayStat[meal] > limits[meal]![1]
              ? ThemeInfo.chartExceededColor
              : ThemeInfo.chartExpectedColor;
      if (valueColor == ThemeInfo.chartExceededColor) {
        image = disappointedImage;
      } else if (valueColor == ThemeInfo.chartBelowColor) {
        image = sadImage;
      } else {
        image = happyImage;
      }

      todayChartData.add(
        ChartData(
          meal,
          todayStat[meal].toDouble(),
          valueColor,
          image: image,
        ),
      );
      todayMax = todayMax < todayStat[meal].toDouble()
          ? todayStat[meal].toDouble()
          : todayMax;
      try {
        weekChartData.add({});
      } on Exception catch (e) {
        print(e);
      }
      weekChartData[i]['chartData'] = <ChartData>[];
      for (Map data in weekStat.reversed) {
        Color valueColor1 = data[meal] < limits[meal]![0]
            ? ThemeInfo.chartBelowColor
            : data[meal] > limits[meal]![1]
                ? ThemeInfo.chartExceededColor
                : ThemeInfo.chartExpectedColor;
        if (valueColor == ThemeInfo.chartExceededColor) {
          image = disappointedImage;
        } else if (valueColor == ThemeInfo.chartBelowColor) {
          image = sadImage;
        } else {
          image = happyImage;
        }
        weekChartData[i]['chartData'].add(ChartData(
            data['dayOfWeek'].toString().substring(0, 3),
            data[meal].toDouble(),
            valueColor1,
            image: image));
        weekMax =
            weekMax < data[meal].toDouble() ? data[meal].toDouble() : weekMax;
      }
      weekChartData[i]['max'] = weekMax;
      weekMax = 0;
      i++;
    }
  }

  @override
  void initState() {
    super.initState();
    _generateData = generateData();
    _tooltip = TooltipBehavior(enable: true);
  }

  final controller1 = ScreenshotController();
  final controller2 = ScreenshotController();

  late List<ChartData> data;
  late TooltipBehavior _tooltip;

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

  int tabPosition = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
        future: _generateData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return DefaultTabController(
              length: 2,
              child: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: TabBar(
                          onTap: (tab) {
                            tabPosition = tab;
                          },
                          indicator: BoxDecoration(
                              color: ThemeInfo.primaryColor,
                              borderRadius: BorderRadius.circular(20.0)),
                          indicatorColor: const Color(0xff1976d2),
                          tabs: const [
                            Tab(text: "For Today"),
                            Tab(text: "This Week"),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.6,
                        child: TabBarView(
                          children: [
                            TodayChart(
                              size: size,
                              max: todayMax,
                              data: todayChartData,
                              interval: todayMax == 0 ? 1 : todayMax,
                              showLabel: false,
                              controller: controller1,
                            ),
                            WeekChart(
                              size: size,
                              max: meals.length.toDouble(),
                              gradient: LinearGradient(
                                colors: ThemeInfo.weekChartGradient,
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              data: weekChartData,
                              controller: controller2,
                              interval: meals.length.toDouble(),
                              showLabel: true,
                            ),
                          ],
                        ),
                      ),
                      Button(
                        press: () async {
                          Uint8List? image;
                          if (tabPosition == 0) {
                            image = await controller1.capture();
                          } else {
                            image = await controller2.capture();
                          }
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
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color, {this.image});

  final String x;
  final double y;
  final Color color;
  final String? image;
}
