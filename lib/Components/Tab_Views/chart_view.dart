import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
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
                height: size.height * 0.66,
                child: TabBarView(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Container(
                        padding: EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              'Daily Nutrients intake',
                              style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff0f5951)),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Container(
                              height: size.height * 0.15,
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(20.0),
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
                                      children: <Widget>[
                                        Legend(
                                          colour: _seriesPieData.,
                                          text: 'Cereals and Starchy foods',
                                        ),
                                        Legend(
                                          colour: Colors.blue,
                                          text: 'Vegetables',
                                        ),
                                        Legend(
                                          colour: Colors.green,
                                          text: 'Fruit',
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Legend(
                                          colour: Colors.black,
                                          text: 'Pulses Meat Fish',
                                        ),
                                        Legend(
                                          colour: Colors.blue,
                                          text: 'Beverages',
                                        ),
                                        Legend(
                                          colour: Colors.green,
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
                                // behaviors: [
                                //   charts.DatumLegend(
                                //     outsideJustification:
                                //         charts.OutsideJustification.endDrawArea,
                                //     horizontalFirst: false,
                                //     desiredMaxRows: 3,
                                //     cellPadding: const EdgeInsets.only(
                                //         top: 5.0,
                                //         bottom: 5.0,
                                //         right: 5.0,
                                //         left: 5.0),
                                //     entryTextStyle: charts.TextStyleSpec(
                                //         color: charts
                                //             .MaterialPalette.blue.shadeDefault,
                                //         fontFamily: 'Georgia',
                                //         fontSize: 12),
                                //   )
                                // ],
                                defaultRenderer: charts.ArcRendererConfig(
                                  arcWidth: 75,
                                  arcRendererDecorators: [
                                    charts.ArcLabelDecorator(
                                        labelPosition:
                                            charts.ArcLabelPosition.inside)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Container(
                        color: Colors.teal,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colour,
          ),
        ),
        SizedBox(
          width: 5.0,
        ),
        Text(
          text.toUpperCase(),
          style: TextStyle(fontSize: 10),
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

// import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
//
// class ChartView extends StatefulWidget {
//   const ChartView({Key? key}) : super(key: key);
//
//   @override
//   State<ChartView> createState() => _ChartViewState();
// }
//
// class _ChartViewState extends State<ChartView> {
//   late List<charts.Series<Task, String>> _seriesPieData;
//
//   _generateData() {
//     var piedata = [
//       new Task('Cereals and Starchy foods', 35.8, Color(0xff054840)),
//       new Task('Vegetables', 8.3, Color(0xff16867a)),
//       new Task('Fruits', 10.8, Color(0xff85dad0)),
//       new Task('Pulses Meat Fish', 15.6, Color(0xffb1dad6)),
//       new Task('Beverages', 19.2, Color(0xff7a7979)),
//       new Task('Milk and Milk Products', 10.3, Color(0xff000000)),
//     ];
//
//     _seriesPieData.add(
//       charts.Series(
//         domainFn: (Task task, _) => task.task,
//         measureFn: (Task task, _) => task.taskvalue,
//         colorFn: (Task task, _) =>
//             charts.ColorUtil.fromDartColor(task.colorval),
//         id: 'Air Pollution',
//         data: piedata,
//         labelAccessorFn: (Task row, _) => '${row.taskvalue}',
//       ),
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _seriesPieData = <charts.Series<Task, String>>[];
//     _generateData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           bottom: TabBar(
//             indicatorColor: Color(0xff1976d2),
//             tabs: [
//               Tab(text: "For Today"),
//               Tab(text: "This Week"),
//             ],
//           ),
//         ),
//         body: TabBarView(children: [
//           Padding(
//             padding: EdgeInsets.all(10.0),
//             child: Center(
//               child: Column(
//                 children: <Widget>[
//                   const Text(
//                     'Daily Nutrients intake',
//                     style: TextStyle(
//                         fontSize: 24.0,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xff0f5951)),
//                   ),
//                   SizedBox(
//                     height: 20.0,
//                   ),
//                   Expanded(
//                     child: charts.PieChart<String>(
//                       _seriesPieData,
//                       animate: true,
//                       animationDuration: Duration(seconds: 1),
//                       behaviors: [
//                         charts.DatumLegend(
//                           outsideJustification:
//                           charts.OutsideJustification.endDrawArea,
//                           horizontalFirst: false,
//                           desiredMaxRows: 3,
//                           cellPadding:
//                           const EdgeInsets.only(right: 10.0, bottom: 10.0),
//                           entryTextStyle: charts.TextStyleSpec(
//                               color: charts.MaterialPalette.purple.shadeDefault,
//                               fontFamily: 'Georgia',
//                               fontSize: 12),
//                         )
//                       ],
//                       defaultRenderer: charts.ArcRendererConfig(
//                         arcWidth: 75,
//                         arcRendererDecorators: [
//                           charts.ArcLabelDecorator(
//                               labelPosition: charts.ArcLabelPosition.inside)
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(10.0),
//             child: Center(
//               child: Column(
//                 children: <Widget>[
//                   const Text(
//                     'Daily Nutrients intake',
//                     style: TextStyle(
//                         fontSize: 24.0,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xff0f5951)),
//                   ),
//                   SizedBox(
//                     height: 20.0,
//                   ),
//                   Expanded(
//                     child: charts.PieChart<String>(
//                       _seriesPieData,
//                       animate: true,
//                       animationDuration: Duration(seconds: 1),
//                       behaviors: [
//                         charts.DatumLegend(
//                           outsideJustification:
//                           charts.OutsideJustification.endDrawArea,
//                           horizontalFirst: false,
//                           desiredMaxRows: 3,
//                           cellPadding:
//                           const EdgeInsets.only(right: 10.0, bottom: 10.0),
//                           entryTextStyle: charts.TextStyleSpec(
//                               color: charts.MaterialPalette.purple.shadeDefault,
//                               fontFamily: 'Georgia',
//                               fontSize: 12),
//                         )
//                       ],
//                       defaultRenderer: charts.ArcRendererConfig(
//                         arcWidth: 75,
//                         arcRendererDecorators: [
//                           charts.ArcLabelDecorator(
//                               labelPosition: charts.ArcLabelPosition.inside)
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }
//
// class Task {
//   String task;
//   double taskvalue;
//   Color colorval;
//
//   Task(this.task, this.taskvalue, this.colorval);
// }
