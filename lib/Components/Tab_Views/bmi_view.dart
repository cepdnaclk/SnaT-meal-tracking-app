import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
/*  Custom Widgets  */
import 'package:mobile_app/Components/bmi/gender_widget.dart';
import 'package:mobile_app/Components/bmi/score_screen.dart';
import 'package:mobile_app/Theme/theme_info.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class BmiCalcView extends StatefulWidget {
  const BmiCalcView({Key? key}) : super(key: key);

  @override
  State<BmiCalcView> createState() => _BmiCalcViewState();
}

class _BmiCalcViewState extends State<BmiCalcView> {
  int _gender = 0;
  double _height = 150;
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  int _age = 30.obs.toInt();
  double _weight = 50;
  bool _isFinished = false;
  double _bmiScore = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            //Lets create widget for gender selection
            GenderWidget(
              onChange: (genderVal) {
                _gender = genderVal;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Enter Your Height in Cm',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              keyboardType: TextInputType.number,
              // add controller
              controller: heightController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  hintText: "Your Height(Cm)",
                  filled: true,
                  fillColor: Colors.green[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  )),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Enter Your Weight in Kg',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              keyboardType: TextInputType.number,
              // add controller
              controller: weightController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  hintText: "Your Weight(Kg)",
                  filled: true,
                  fillColor: Colors.green[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  )),
            ),

            const SizedBox(
              height: 15,
            ),

            // pick the age
            NumberPicker(
              value: _age,
              axis: Axis.horizontal,
              minValue: 0,
              maxValue: 100,
              onChanged: (value) => setState(() => _age = value),
            ),
            const SizedBox(
              height: 15,
            ),

            Text(
              'Your Age : $_age',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            Padding(
              padding: const EdgeInsets.all(25),
              child: SwipeableButtonView(
                  isFinished: _isFinished,
                  onFinish: () async {
                    await Navigator.push(
                        context,
                        PageTransition(
                            child: ScoreScreen(
                              bmiScore: _bmiScore,
                              age: _age,
                            ),
                            type: PageTransitionType.leftToRightWithFade));

                    setState(() {
                      _isFinished = false;
                    });
                  },
                  onWaitingProcess: () {
                    //Calculate BMI here
                    calculateBmi();

                    Future.delayed(const Duration(seconds: 1), () {
                      setState(() {
                        _isFinished = true;
                      });
                    });
                  },
                  activeColor: ThemeInfo.primaryColor,
                  buttonWidget: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.black,
                  ),
                  buttonText: "CALCULATE"),
            )
          ],
        ),
      ),
    ));
  }

  void calculateBmi() {
    _height = double.parse(heightController.value.text);
    _weight = double.parse(weightController.value.text);
    _bmiScore = _weight / pow(_height / 100, 2);
  }
}
