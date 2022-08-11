import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';

class imageStorage {
  User? user = FirebaseAuth.instance.currentUser;
  var email = "";
  var id;

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  String url = "";
  late UploadTask uploadTask;
  late final _firestore;

  imageStorage() {
    email = user?.email as String;
    id = user?.uid;
    _firestore = FirebaseFirestore.instance;

    print(
        "=========++++++++++++++++++================++++++++++++++============--------------");
    print(email);
    print(id);
  }
  // add iamge url to firebase
  Future<void> setImageUrl(
      String date, String mealtime, String imageurl) async {
    _firestore
        .collection('user_Images')
        .doc(id)
        .collection('ImageURls')
        .doc(date)
        .collection(mealtime)
        .add({
      'url': imageurl,
    });
    // DatabaseReference ref = FirebaseDatabase.instance.ref("user_Images/$id/$date/$mealtime");
    //DatabaseReference ref = FirebaseDatabase.instance.ref("user_Images");
    // await ref.set({
    //   "date": imageurl
    // }).then((value) => print("================================url set"));
  }

  Future<List<String>> getUrl(String date, String mealtime) async {
    List<String> urlList = [];
    final urls = await _firestore
        .collection('user_Images')
        .doc(id)
        .collection('ImageURls')
        .doc(date)
        .collection(mealtime)
        .get();
    for (var url in urls.docs) {
      print(url.data()['url']);
      urlList.add(url.data()['url'].toString());
    }
    print(urlList);
    return urlList;
  }

  // for upload a image
  Future<String> uploadFile(String filepath, String filename) async {
    final Reference storageReference =
        FirebaseStorage.instance.ref('images/$email/$filename');
    File file = File(filepath);
    try {
      ///images
      url = await (await storage.ref('images/$email/$filename').putFile(file))
          .ref
          .getDownloadURL();
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
    return url;
  }

  Future<firebase_storage.ListResult> listimages() async {
    firebase_storage.ListResult result =
        await storage.ref('images/$email').listAll();
    result.items.forEach((firebase_storage.Reference ref) {
      print("image : $ref");
    });
    return result;
  }

  // this is for when image is delete replace that with this iamge
  // the image opath is /System images/delete
  Future<firebase_storage.ListResult> deleteimages() async {
    firebase_storage.ListResult result =
        await storage.ref('/System images/delete').listAll();
    result.items.forEach((firebase_storage.Reference ref) {
      print("image : $ref");
    });
    return result;
  }

  // download images from firebase
  Future<String> dowmloadURL(String imageName) async {
    String downloadURL =
        await storage.ref('images/$email/$imageName').getDownloadURL();
    return downloadURL;
  }

  // for load images
  Future<List<String>> loadImages() async {
    List<String> files = [];
    List<String> reversedList = [];

    final ListResult result = await storage.ref('images/$email').list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      files.add(fileUrl);
    });
    reversedList = List.from(files.reversed);
    return reversedList;
  }

  Future<List<String>> takeMealTimeAndDateFromUrl(
      String urlserch, List<String> datelist) async {
    print("+======+");
    print(datelist);
    List<String> details = [];

    List<String> mealTimes = [
      "Breakfast",
      "Morning Snacks",
      "Lunch",
      "Evening Snacks",
      "Dinner",
      "Other Meals"
    ];
    for (var date in datelist) {
      for (var mealTime in mealTimes) {
        final urls = await _firestore
            .collection('user_Images')
            .doc(id)
            .collection('ImageURls')
            .doc(date)
            .collection(mealTime)
            .get()
            .catchError((error) => print("Failed to delete user: $error"));

        for (var url in urls.docs) {
          if (url.data()['url'].toString() == urlserch.toString()) {
            details.add(date);
            details.add(mealTime);
          } else {
            print("no");
          }
          //print(url.data()['url']);
          //urlList.add(url.data()['url'].toString());
        }
      }
    }
    print("=======================");
    print(details);
    return details;
  }

  // delete images with url stored in  after push delete button
  Future<String> deletefromfirebase(
      String date, String mealtime, String urldelete) async {
    print("deletefromfirebase");

    final urls = await _firestore
        .collection('user_Images')
        .doc(id)
        .collection('ImageURls')
        .doc(date)
        .collection(mealtime)
        .get()
        .catchError((error) => print("Failed to delete user: $error"));

    print("\n ============ \n urldelete = " + urldelete + "   \n\n");

    for (var url in urls.docs) {
      print("a\n");
      print("\n url = from urls => " + url.data()['url'].toString());
      if (url.data()['url'].toString() == urldelete.toString()) {
        print(url.data()['url'].toString() + "\n selected \n");
        await _firestore
            .collection('user_Images')
            .doc(id)
            .collection('ImageURls')
            .doc(date)
            .collection(mealtime)
            .doc(url.reference.id)
            .delete()
            .catchError((error) => print("Failed to delete user: $error"));
      } else {
        print("\n not selected \n");
      }
    }
    print("\n deletefromfirebase finished \n ");
    return urldelete;
  }

  //--------------------------------------------------------------------------------------------------------------------------
  Future<List<String>> allImagesListofADate(
      List<String> datelist, List<String> mealTimes) async {
    List<String> urlList = [];
    // List<String> mealTimes = [
    //   "Breakfast",
    //   "Morning Snacks",
    //   "Lunch",
    //   "Evening Snacks",
    //   "Dinner",
    //   "Others"
    // ];
    if (mealTimes.isEmpty) {
      mealTimes = [
        "Breakfast",
        "Morning Snacks",
        "Lunch",
        "Evening Snacks",
        "Dinner",
        "Other Meals"
      ];
    }
    for (var date in datelist) {
      for (var mealTime in mealTimes) {
        final urls = await _firestore
            .collection('user_Images')
            .doc(id)
            .collection('ImageURls')
            .doc(date)
            .collection(mealTime)
            .get()
            .catchError((error) => print("Failed to delete user: $error"));

        for (var url in urls.docs) {
          print(url.data()['url']);
          urlList.add(url.data()['url'].toString());
        }
      }
    }
    return urlList;
  }
  //-------------------------------------------------------------------------------------------------------------------------
  // // delete image with the stored url after a month
  // Future<void> deleteAfterExpire() async {
  //   var date = DateTime.now();
  //   var prevMonth = DateTime(date.year, date.month - 1, date.day);
  //   String premonthFromToday = prevMonth.toString().split(' ')[0];
  //   print(premonthFromToday);
  //
  //   List<String> mealTimes = [
  //     "Breakfast",
  //     "Morning Snacks",
  //     "Lunch",
  //     "Evening Snacks",
  //     "Dinner",
  //     "Others"
  //   ];
  //   for (var mealTime in mealTimes) {
  //     final urls = await _firestore
  //         .collection('user_Images')
  //         .doc(id)
  //         .collection('ImageURls')
  //         .doc(premonthFromToday)
  //         .collection(mealTime)
  //         .get()
  //         .catchError((error) => print("Failed to delete user: $error"));
  //     try {
  //       for (var url in urls.docs) {
  //         await _firestore
  //             .collection('user_Images')
  //             .doc(id)
  //             .collection('ImageURls')
  //             .doc(premonthFromToday)
  //             .collection(mealTime)
  //             .doc(url.reference.id)
  //             .delete()
  //             .catchError((error) => print("Failed to delete user: $error"));
  //         delete(url);
  //       }
  //     } catch (e) {
  //       print(e);
  //     }
  //   }
  // }

  // delete images from url
  Future<void> delete(String url) async {
    FirebaseStorage.instance.refFromURL(url).delete();
  }

  Future<String> uploadData(Uint8List data, String path) async {
    final Reference storageReference = FirebaseStorage.instance.ref(path);
    try {
      await storageReference.putData(data).whenComplete(() async {
        url = await storageReference.getDownloadURL();
      });
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
    return url;
  }

}
