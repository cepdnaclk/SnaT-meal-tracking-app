
import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';



class imageStorage{
  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  String email='SnaT@gmail.com';
  // for upload a image
  Future<void> uploadFile(String filepath,String filename) async{
    File file = File(filepath);
    try{///images
      await storage.ref('images/$email/$filename').putFile(file);
    }on firebase_core.FirebaseException catch(e) {
      print(e);
    }
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


