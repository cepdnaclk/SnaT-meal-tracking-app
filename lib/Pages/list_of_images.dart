/*
 ALL ABOUT THE MEAL GALLERY
 */
// importing pacckeges
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

class MyFileList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyFileList();
  }
}

class _MyFileList extends State<MyFileList> {
  //var files;
  var image_path = <String>[]; // Creates growable list.
  // var g_image_path = <String>[]; // Creates growable list.

  // method for taking each image path to image_path list
  Future<List<String>> getpaths() async {
    // taking directory which saved the images
    final Directory? extDir = await getExternalStorageDirectory();
    final String dirPath = extDir!.path.toString();
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/';

    final myDir = Directory(filePath);
    image_path.clear();
    await for (var entity in myDir.list(recursive: false, followLinks: false)) {
      String fileName = entity.path;
      image_path.add(fileName);
    }
    return image_path;
  }

  @override
  void initState() {
    print("dsds");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Meal Gallery'; // main Title

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: Scaffold(
          appBar: AppBar(
            title: const Text(title),
          ),
          body: FutureBuilder(
            future: getpaths(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // untill the data is load
                return const Center(
                  child: Text('Waiting'),
                );
              } else {
                if (snapshot.hasError) {
                  // for errors
                  return Text(snapshot.error.toString());
                } else {
                  return GridView.builder(
                    gridDelegate: // grid view
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: GridTile(
                          // footer:  Text(snapshot.data[index]['name']),
                          child: Image.file(
                            File(snapshot.data[index]),
                          ), //Text(snapshot.data[index]['image']), //just for testing, will fill with image later
                        ),
                      );
                    },
                  );
                }
              }
            },
          )),
    );
  }
}
