import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/Services/IamageStoreService.dart';

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  test('IamageStoreService_setImageUrl_abcd', () async {
    // TODO: Implement test
    //arrange
    imageStorage storage = imageStorage();
    //act
    storage.setImageUrl("2021-08-02", "dinner", "imageurl");
    expect(storage.email,"govinnachiran@gmail.com");
  });
  test('IamageStoreService_setImageUrl_abcd', () async {
    // TODO: Implement test
    //arrange
    imageStorage storage = imageStorage();
    //act
    storage.setImageUrl("2021-08-02", "dinner", "imageurl");
    expect(storage.email,"govinnachiran@gmail.com");


  });
}