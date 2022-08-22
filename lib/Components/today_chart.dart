import 'package:flutter/material.dart';
import 'package:mobile_app/Theme/theme_info.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../constants.dart';
import 'Tab_Views/chart_view.dart';

class TodayChart extends StatelessWidget {
  TodayChart({
    Key? key,
    required this.size,
    required this.max,
    required this.data,
    this.interval,
    this.dataLabelSettings,
    required this.showLabel,
    this.gradient,
    required this.controller,
  }) : super(key: key);
  final Size size;
  final double max;
  final List<ChartData> data;
  final double? interval;
  final TooltipBehavior _tooltip = TooltipBehavior(enable: true);
  final LinearGradient? gradient;
  final DataLabelSettings? dataLabelSettings;
  final ScreenshotController controller;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Screenshot(
        controller: controller,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.grey.shade300,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10, right: 10),
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
                SizedBox(
                  height: size.height * 0.02,
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Center(
                  child: Column(
                    children: [
                      if (!showLabel)
                        Row(
                          children: [
                            const SizedBox(
                              width: 45,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  for (ChartData info in data)
                                    SizedBox(
                                        width: 20,
                                        child: Image.asset(info.image!)),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 250.0,
                        ),
                        child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(
                              majorGridLines: const MajorGridLines(
                                width: 0,
                              ),
                              labelIntersectAction:
                                  AxisLabelIntersectAction.trim,
                              labelRotation: 0,
                              labelStyle: const TextStyle(
                                  color: Colors.black,
                                  overflow: TextOverflow.ellipsis)),
                          primaryYAxis: NumericAxis(
                              title: AxisTitle(text: "Servings"),
                              majorGridLines: const MajorGridLines(
                                width: 0,
                              ),
                              minimum: 0,
                              maximum: max,
                              interval: interval ?? 1),
                          tooltipBehavior: _tooltip,
                          series: <ChartSeries<ChartData, String>>[
                            ColumnSeries<ChartData, String>(
                              dataLabelSettings: DataLabelSettings(
                                isVisible: showLabel,
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              dataSource: data,
                              xValueMapper: (ChartData data, _) {
                                return data.x.toString().substring(0, 3);
                              },
                              isTrackVisible: showLabel,
                              trackColor: ThemeInfo.chartTrackColor,
                              yValueMapper: (ChartData data, _) => data.y,
                              dataLabelMapper: (ChartData data, _) =>
                                  data.y == meals.length && showLabel
                                      ? "✔"
                                      : "",
                              pointColorMapper: (ChartData data, _) =>
                                  data.color,
                              name: 'Gold',
                              animationDuration: 1000,
                              gradient: gradient,
                              color: const Color.fromRGBO(8, 142, 255, 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      direction: Axis.vertical,
                      clipBehavior: Clip.hardEdge,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      //alignment: WrapAlignment.center,
                      children: [
                        for (ChartData info in data)
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 2,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.black,
                                )),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 1),
                            child: Text(
                              "${info.x.toString().substring(0, 3)} - ${info.x}",
                            ),
                          )
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
