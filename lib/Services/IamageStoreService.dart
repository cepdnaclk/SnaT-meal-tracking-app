
import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';


class imageStorage{
  User? user = FirebaseAuth.instance.currentUser;
  var email = "";
  var id ;

  DatabaseReference userImage = FirebaseDatabase.instance.ref('users_Images');

  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  String url="";
  late UploadTask uploadTask;
  final _firestore = FirebaseFirestore.instance;


  imageStorage(){
    email =  user?.email as String;
    id = user?.uid;

    print("=========++++++++++++++++++================++++++++++++++============--------------");
    print(email);
    print(id);
  }
  // add iamge url to firebase
  Future<void> setImageUrl( String date , String mealtime , String imageurl) async {
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
  Future<List<String>> getUrl(String date , String mealtime)async{
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
        // SearchTerms.add(food.data()['Food']);
        // FoodandUnits.add(
        //     {"Food": food.data()['Food'], "Units": food.data()['Unit']});
        urlList.add(url.data()['url'].toString());
      }
      print(urlList);
      return urlList;
  }

  // for upload a image
  Future<String> uploadFile(String filepath,String filename) async{
    final  Reference storageReference = FirebaseStorage.instance.ref('images/$email/$filename');
    File file = File(filepath);
    try{///images
      url=await(await storage.ref('images/$email/$filename').putFile(file)).ref.getDownloadURL();
      //uploadTask = storageReference.putFile(file);
      //url = await (await uploadTask).ref.getDownloadURL();


    }on firebase_core.FirebaseException catch(e) {
      print(e);
    }
    //print("================================================================");
   // print(url);
    return url;
  }
  Future<firebase_storage.ListResult> listimages() async{
    firebase_storage.ListResult result=await storage.ref('images/$email').listAll();
    result.items.forEach((firebase_storage.Reference ref){
      print("image : $ref");
    });
    return result;
  }
  Future<String> dowmloadURL(String imageName)async{
    String downloadURL = await storage.ref('images/$email/$imageName').getDownloadURL();
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
  Future<void> delete(String ref) async {
    await storage.ref(ref).delete();
  }

}


