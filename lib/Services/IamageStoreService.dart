
import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';



class imageStorage{
  User? user = FirebaseAuth.instance.currentUser;
  var email = "";

  //email= user.email;

  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  String url="";
  late UploadTask uploadTask;

  imageStorage(){
    email =  user?.email as String;
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


