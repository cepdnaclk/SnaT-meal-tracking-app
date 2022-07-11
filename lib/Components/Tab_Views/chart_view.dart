import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:io';
import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mobile_app/Theme/theme_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'chart_view_components/barChartLegend.dart';
import 'chart_view_components/barchart_model.dart';
import 'chart_view_components/legend_container.dart';
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
  late List<charts.Series<WeekReport, String>> _seriesData1;

  // Color valuess for bar chart
  Color basicColor = const Color(0xff054840);
  // Color eatLessColor = const Color(0xffa80000);
  // Color eatMoreColor = const Color(0xfffff000);

  _generateData() {
    var barColor = [
      basicColor,
      basicColor,
      basicColor,
      basicColor,
      basicColor,
      basicColor,
      basicColor
    ];
    var data1 = [
      WeekReport('Monday', 35, barColor[0]),
      WeekReport('Tuesday', 30, barColor[1]),
      WeekReport('Wednesday', 40, barColor[2]),
      WeekReport('Thursday', 25, barColor[3]),
      WeekReport('Friday', 36, barColor[4]),
      WeekReport('Saturday', 28, barColor[5]),
      WeekReport('Sunday', 29, barColor[6]),
    ];

    // 27
    // 39
    // for (int i = 0; i < 7; i++) {
    //   if (data1[i].serves > 39) {
    //     data1[i].colorVal = eatLessColor;
    //   } else if (data1[i].serves < 27) {
    //     data1[i].colorVal = eatMoreColor;
    //   } else {
    //     data1[i].colorVal = basicColor;
    //   }
    // }
    // var piedata = [
    //   Task('Cereals and Starchy foods', 35.8, const Color(0xff054840)),
    //   Task('Vegetables', 8.3, const Color(0xff16867a)),
    //   Task('Fruits', 10.8, const Color(0xff85dad0)),
    //   Task('Pulses Meat Fish', 15.6, const Color(0xffb1dad6)),
    //   Task('Beverages', 19.2, const Color(0xff7a7979)),
    //   Task('Milk and Milk Products', 10.3, const Color(0xff000000)),
    // ];

    //
    // _seriesPieData.add(
    //   charts.Series(
    //     domainFn: (Task task, _) => task.mealType,
    //     measureFn: (Task task, _) => task.serving,
    //     colorFn: (Task task, _) =>
    //         charts.ColorUtil.fromDartColor(task.colorVal),
    //     id: 'Daily Nutrients',
    //     data: piedata,
    //     labelAccessorFn: (Task row, _) => '${row.serving}',
    //   ),
    // );

    var piedata = [
      WeekReport('Monday', 7, basicColor),
      WeekReport('Tuesday', 6, basicColor),
      WeekReport('Wednesday', 7, basicColor),
      WeekReport('Thursday', 4, basicColor),
      WeekReport('Friday', 3, basicColor),
      WeekReport('Saturday', 5, basicColor),
      WeekReport('Sunday', 1, basicColor),
    ];

    _seriesData.add(
      charts.Series(
        domainFn: (WeekReport pollution, _) => pollution.day,
        measureFn: (WeekReport pollution, _) => pollution.serves,
        id: '2017',
        data: data1,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (WeekReport pollution, _) =>
            charts.ColorUtil.fromDartColor(pollution.colorVal),
      ),
    );
    _seriesData1.add(
      charts.Series(
        domainFn: (WeekReport pollution, _) => pollution.day,
        measureFn: (WeekReport pollution, _) => pollution.serves,
        id: '2018',
        data: piedata,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (WeekReport pollution, _) =>
            charts.ColorUtil.fromDartColor(pollution.colorVal),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _seriesData = <charts.Series<WeekReport, String>>[];
    _seriesData1 = <charts.Series<WeekReport, String>>[];
    // _seriesPieData = <charts.Series<Task, String>>[];
    _generateData();
  }

  final controller = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                child: Flexible(
                  flex: 8,
                  child: SizedBox(
                    height: size.height * 0.67,
                    child: TabBarView(
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.all(10.0),
                        //   child: Container(
                        //     padding: const EdgeInsets.all(3.0),
                        //     decoration: BoxDecoration(
                        //         color: Colors.grey.shade300,
                        //         borderRadius: BorderRadius.circular(20.0)),
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.center,
                        //       children: <Widget>[
                        //         SizedBox(
                        //           height: size.height * 0.01,
                        //         ),
                        //         const Text(
                        //           'Daily Nutrients intake',
                        //           style: TextStyle(
                        //               fontSize: 20.0,
                        //               fontWeight: FontWeight.bold,
                        //               color: Color(0xff0f5951)),
                        //         ),
                        //         SizedBox(
                        //           height: size.height * 0.02,
                        //         ),
                        //         Container(
                        //           height: size.height * 0.13,
                        //           width: size.width * 0.85,
                        //           decoration: BoxDecoration(
                        //             color: Colors.blueGrey.shade300,
                        //             borderRadius: BorderRadius.circular(10.0),
                        //             boxShadow: [
                        //               BoxShadow(
                        //                 color: Colors.grey.shade500,
                        //                 offset: const Offset(0.0, 5.0),
                        //                 blurRadius: 5.0,
                        //                 spreadRadius: 1.0,
                        //               ),
                        //               const BoxShadow(
                        //                   color: Colors.white,
                        //                   offset: Offset(0.0, 0.0))
                        //             ],
                        //           ),
                        //           child: Row(
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceEvenly,
                        //             children: <Widget>[
                        //               Column(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.spaceEvenly,
                        //                 crossAxisAlignment:
                        //                     CrossAxisAlignment.start,
                        //                 children: const <Widget>[
                        //                   Legend(
                        //                     colour: Color(0xff054840),
                        //                     text: 'Cereals and Starchy foods',
                        //                   ),
                        //                   Legend(
                        //                     colour: Color(0xff16867a),
                        //                     text: 'Vegetables',
                        //                   ),
                        //                   Legend(
                        //                     colour: Color(0xff85dad0),
                        //                     text: 'Fruit',
                        //                   ),
                        //                 ],
                        //               ),
                        //               SizedBox(
                        //                 width: 2,
                        //                 height: size.height * 0.12,
                        //                 child: DecoratedBox(
                        //                   decoration: BoxDecoration(
                        //                     color: Colors.blueGrey.shade900,
                        //                   ),
                        //                 ),
                        //               ),
                        //               Column(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.spaceEvenly,
                        //                 crossAxisAlignment:
                        //                     CrossAxisAlignment.start,
                        //                 children: const <Widget>[
                        //                   Legend(
                        //                     colour: Color(0xffb1dad6),
                        //                     text: 'Pulses Meat Fish',
                        //                   ),
                        //                   Legend(
                        //                     colour: Color(0xff7a7979),
                        //                     text: 'Beverages',
                        //                   ),
                        //                   Legend(
                        //                     colour: Color(0xff000000),
                        //                     text: 'Milk and Milk Products',
                        //                   ),
                        //                 ],
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //         Expanded(
                        //           child: charts.PieChart<String>(
                        //             _seriesPieData,
                        //             animate: true,
                        //             animationDuration:
                        //                 const Duration(seconds: 1),
                        //             defaultRenderer: charts.ArcRendererConfig(
                        //               arcWidth: 75,
                        //               arcRendererDecorators: [
                        //                 charts.ArcLabelDecorator(
                        //                     labelPosition:
                        //                         charts.ArcLabelPosition.inside)
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //         Button(
                        //           press: () async {
                        //             final image = await controller.capture();
                        //             if (image == null) return;
                        //
                        //             await saveImage(image);
                        //             await saveAndShare(image);
                        //           },
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        Padding(
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
                                  Container(
                                    height: size.height * 0.2,
                                    width: size.height * 0.2,
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey.shade300,
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade400,
                                          offset: const Offset(0.0, 5.0),
                                          blurRadius: 5.0,
                                          spreadRadius: 1.0,
                                        ),
                                        const BoxShadow(
                                            color: Colors.white,
                                            offset: Offset(0.0, 0.0))
                                      ],
                                    ),
                                    child: Image.asset(
                                      "assets/images/globe.gif",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  Expanded(
                                    child: charts.BarChart(
                                      _seriesData1,
                                      animate: true,
                                      animationDuration:
                                          const Duration(seconds: 1),

                                      /// Assign a custom style for the domain axis.
                                      ///
                                      /// This is an OrdinalAxisSpec to match up with BarChart's default
                                      /// ordinal domain axis (use NumericAxisSpec or DateTimeAxisSpec for
                                      /// other charts).
                                      domainAxis: const charts.OrdinalAxisSpec(
                                          renderSpec:
                                              charts.SmallTickRendererSpec(

                                                  // Tick and Label styling here.
                                                  labelStyle:
                                                      charts.TextStyleSpec(
                                                          fontSize:
                                                              8, // size in Pts.
                                                          color: charts
                                                              .MaterialPalette
                                                              .black),

                                                  // Change the line colors to match text color.
                                                  lineStyle:
                                                      charts.LineStyleSpec(
                                                          color: charts
                                                              .MaterialPalette
                                                              .black))),

                                      /// Assign a custom style for the measure axis.
                                      primaryMeasureAxis: const charts
                                              .NumericAxisSpec(
                                          renderSpec:
                                              charts.GridlineRendererSpec(

                                                  // Tick and Label styling here.
                                                  labelStyle:
                                                      charts.TextStyleSpec(
                                                          fontSize:
                                                              14, // size in Pts.
                                                          color: charts
                                                              .MaterialPalette
                                                              .black),

                                                  // Change the line colors to match text color.
                                                  lineStyle:
                                                      charts.LineStyleSpec(
                                                          color: charts
                                                              .MaterialPalette
                                                              .black))),
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
                        ),
                        Padding(
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
                                  Container(
                                    height: size.height * 0.2,
                                    width: size.height * 0.2,
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey.shade300,
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade400,
                                          offset: const Offset(0.0, 5.0),
                                          blurRadius: 5.0,
                                          spreadRadius: 1.0,
                                        ),
                                        const BoxShadow(
                                            color: Colors.white,
                                            offset: Offset(0.0, 0.0))
                                      ],
                                    ),
                                    child: Image.asset(
                                      "assets/images/globe.gif",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // child: Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceEvenly,
                                  //   children: <Widget>[
                                  //     Column(
                                  //       mainAxisAlignment:
                                  //           MainAxisAlignment.spaceEvenly,
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.center,
                                  //       children: <Widget>[
                                  //         Row(
                                  //           children: const [
                                  //             BoxLegend(
                                  //               colour: Color(0xff054840),
                                  //               text: 'You are on Point 😍',
                                  //             ),
                                  //           ],
                                  //         ),
                                  //         Row(
                                  //           crossAxisAlignment:
                                  //               CrossAxisAlignment.center,
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.spaceEvenly,
                                  //           children: [
                                  //             const BoxLegend(
                                  //               colour: Color(0xffa80000),
                                  //               text: 'Too much 🤨',
                                  //             ),
                                  //             SizedBox(
                                  //                 width: size.width * 0.1),
                                  //             const BoxLegend(
                                  //               colour: Color(0xfffff000),
                                  //               text: 'Not enough 🥲',
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ],
                                  // ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  Expanded(
                                    child: charts.BarChart(
                                      _seriesData,
                                      animate: true,
                                      animationDuration:
                                          const Duration(seconds: 1),

                                      /// Assign a custom style for the domain axis.
                                      ///
                                      /// This is an OrdinalAxisSpec to match up with BarChart's default
                                      /// ordinal domain axis (use NumericAxisSpec or DateTimeAxisSpec for
                                      /// other charts).
                                      domainAxis: const charts.OrdinalAxisSpec(
                                          renderSpec:
                                              charts.SmallTickRendererSpec(

                                                  // Tick and Label styling here.
                                                  labelStyle:
                                                      charts.TextStyleSpec(
                                                          fontSize:
                                                              8, // size in Pts.
                                                          color: charts
                                                              .MaterialPalette
                                                              .black),

                                                  // Change the line colors to match text color.
                                                  lineStyle:
                                                      charts.LineStyleSpec(
                                                          color: charts
                                                              .MaterialPalette
                                                              .black))),

                                      /// Assign a custom style for the measure axis.
                                      primaryMeasureAxis: const charts
                                              .NumericAxisSpec(
                                          renderSpec:
                                              charts.GridlineRendererSpec(

                                                  // Tick and Label styling here.
                                                  labelStyle:
                                                      charts.TextStyleSpec(
                                                          fontSize:
                                                              14, // size in Pts.
                                                          color: charts
                                                              .MaterialPalette
                                                              .black),

                                                  // Change the line colors to match text color.
                                                  lineStyle:
                                                      charts.LineStyleSpec(
                                                          color: charts
                                                              .MaterialPalette
                                                              .black))),
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
                        )
                      ],
                    ),
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
