import 'package:flutter/material.dart';
import 'package:mobile_app/Components/today_chart.dart';
import 'package:mobile_app/Services/firebase_services.dart';
import 'package:mobile_app/Theme/theme_info.dart';
import 'package:mobile_app/constants.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
  List<ChartData> weekChartData = [];
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
      i++;
    }
    for (Map data in weekStat.reversed) {
      weekChartData.add(ChartData(data['date'].toString().substring(5),
          data['count'].toDouble(), Colors.green));
      weekMax = weekMax < data['count'].toDouble()
          ? data['count'].toDouble()
          : weekMax;
    }
  }

  @override
  void initState() {
    super.initState();
    _generateData = generateData();
    _tooltip = TooltipBehavior(enable: true);
  }

  final controller = ScreenshotController();

  late List<ChartData> data;
  late TooltipBehavior _tooltip;

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
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      const Spacer(
                        flex: 1,
                      ),
                      Flexible(
                        flex: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: TabBar(
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
                      ),
                      const Spacer(),
                      Screenshot(
                        controller: controller,
                        child: SizedBox(
                          height: size.height * 0.67,
                          child: TabBarView(
                            children: [
                              ChartWidget(
                                image: image,
                                size: size,
                                max: todayMax,
                                data: todayChartData,
                                controller: controller,
                                interval: todayMax == 0 ? 1 : todayMax,
                                showLabel: false,
                              ),
                              ChartWidget(
                                size: size,
                                max: meals.length.toDouble(),
                                gradient: LinearGradient(
                                    colors: ThemeInfo.weekChartGradient,
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter),
                                data: weekChartData,
                                controller: controller,
                                interval: meals.length.toDouble(),
                                showLabel: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(
                        flex: 1,
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
