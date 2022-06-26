import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pretty_gauge/pretty_gauge.dart';
import 'package:url_launcher/url_launcher.dart';

class ScoreScreen extends StatelessWidget {
  final double bmiScore;

  final int age;
  String? bmiStatus;
  String? bmiInterpretation;
  Color? bmiStatusColor;

  ScoreScreen({Key? key, required this.bmiScore, required this.age})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    setBmiInterpretation();
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.all(12),
          child: Card(
              elevation: 12,
              shape: const RoundedRectangleBorder(),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Your BMI Value",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    PrettyGauge(
                      gaugeSize: 300,
                      minValue: 0,
                      maxValue: 40,
                      segments: [
                        GaugeSegment('UnderWeight', 18.5, Colors.red),
                        GaugeSegment('Normal', 6.4, Colors.green),
                        GaugeSegment('OverWeight', 5, Colors.orange),
                        GaugeSegment('Obese', 10.1, Colors.pink),
                      ],
                      valueWidget: Text(
                        bmiScore.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 40),
                      ),
                      currentValue: bmiScore.toDouble(),
                      needleColor: Colors.blue,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      bmiStatus!,
                      style: TextStyle(fontSize: 20, color: bmiStatusColor!),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      bmiInterpretation!,
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Back")),
                        const SizedBox(
                          width: 30,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              // var result = await canLaunchUrl(
                              //   Uri.parse(
                              //     'fb://facewebmodal/f?href=https://www.facebook.com/al.mamun.me12',
                              //   ),
                              // );
                              // print("result$result");
                              String url =
                                  "https://m.facebook.com/muthulingamthanoraj11";
                              print(Platform.isAndroid);
                              if (Platform.isAndroid) {
                                print(
                                    url.startsWith("https://m.facebook.com/"));

                                if (url.startsWith("https://m.facebook.com/")) {
                                  print("in");
                                  final url2 = "fb://facewebmodal/f?href=$url";
                                  // final intent2 = AndroidIntent(
                                  //     action: "action_view", data: url2);
                                  // final canWork =
                                  //     await intent2.canResolveActivity();
                                  // if (canWork) return intent2.launch();
                                  launchUrl(Uri.parse(
                                      "fb://facewebmodal/f?href=https://www.facebook.com/muthulingamthanoraj11"));
                                }
                                // final intent = AndroidIntent(
                                //     action: "action_view", data: url);
                                // return intent.launch();
                              } else {
                                // if (_canLaunch) {
                                //   await launch(url, forceSafariVC: false);
                                // } else {
                                //   throw "Could not launch $url";
                                // }
                              }
                            },
                            child: const Text("Share")),
                      ],
                    )
                  ]))),
    );
  }

  void setBmiInterpretation() {
    if (bmiScore > 30) {
      bmiStatus = "Obese";
      bmiInterpretation = "Your Health is in Danger!";
      bmiStatusColor = Colors.pink;
    } else if (bmiScore >= 25) {
      bmiStatus = "Overweight";
      bmiInterpretation = "Consider About Your Health";
      bmiStatusColor = Colors.orange;
    } else if (bmiScore >= 18.5) {
      bmiStatus = "Normal";
      bmiInterpretation = "You are fit";
      bmiStatusColor = Colors.green;
    } else if (bmiScore < 18.5) {
      bmiStatus = "Underweight";
      bmiInterpretation = "Try to gain weight";
      bmiStatusColor = Colors.red;
    }
  }
}
