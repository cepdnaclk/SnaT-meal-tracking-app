// Import the test package and Counter class
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_app/Components/Tab_Views/bmi_view.dart';
import 'package:mobile_app/main.dart';
import 'package:test/test.dart';

void main() {
  test('Tests BMI value calculated according to height and weight', () async {
    // arrange
    const widget = BmiCalcView();

    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(const MyApp());

    final element = widget.createElement();
    final state = element.state as BmiCalcViewState;
    expect(state.calculateBmi(178.0,55.0),55.0 / pow(178.0 / 100, 2) );

  });
}