


//--------------------------------------------------------------------------------------------------------------------------
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:file_manager/file_manager.dart';
// import 'package:path_provider/path_provider.dart';
//
// // class list_images extends StatelessWidget {
// //   const list_images({Key? key}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return const Text("Gallery View");
// //   }
// // }
//
//
// class list_images extends StatelessWidget {
//   final FileManagerController controller = FileManagerController();
//
//   @override
//   Widget build(BuildContext context) {
//     // Creates a widget that registers a callback to veto attempts by the user to dismiss the enclosing
//     // or controllers the system's back button
//     return WillPopScope(
//       onWillPop: () async {
//         if (await controller.isRootDirectory()) {
//           return true;
//         } else {
//           controller.goToParentDirectory();
//           return false;
//         }
//       },
//       child: Scaffold(
//           appBar: AppBar(
//             actions: [
//               IconButton(
//                 onPressed: () => createFolder(context),
//                 icon: Icon(Icons.create_new_folder_outlined),
//               ),
//               IconButton(
//                 onPressed: () => sort(context),
//                 icon: Icon(Icons.sort_rounded),
//               ),
//               IconButton(
//                 onPressed: () => selectStorage(context),
//                 icon: Icon(Icons.sd_storage_rounded),
//               )
//             ],
//             title: ValueListenableBuilder<String>(
//               valueListenable: controller.titleNotifier,
//               builder: (context, title, _) => Text(title),
//             ),
//             leading: IconButton(
//               icon: Icon(Icons.arrow_back),
//               onPressed: () async {
//                 await controller.goToParentDirectory();
//               },
//             ),
//           ),
//           body: Container(
//             margin: EdgeInsets.all(10),
//             child: FileManager(
//               controller: controller,
//               builder: (context, snapshot) {
//                 final List<FileSystemEntity> entities = snapshot;
//                 print(entities);
//                 return ListView.builder(
//                   itemCount: entities.length,
//                   itemBuilder: (context, index) {
//                     FileSystemEntity entity = entities[index];
//                     return Card(
//                       child: ListTile(
//                         leading: FileManager.isFile(entity)
//                             ? Icon(Icons.feed_outlined)
//                             : Icon(Icons.folder),
//                         title: Text(FileManager.basename(entity)),
//                         subtitle: subtitle(entity),
//                         onTap: () async {
//                           if (FileManager.isDirectory(entity)) {
//                             // open the folder
//                             controller.openDirectory(entity);
//
//                             // delete a folder
//                             // await entity.delete(recursive: true);
//
//                             // rename a folder
//                             // await entity.rename("newPath");
//
//                             // Check weather folder exists
//                             // entity.exists();
//
//                             // get date of file
//                             // DateTime date = (await entity.stat()).modified;
//                           } else {
//                             // delete a file
//                             // await entity.delete();
//
//                             // rename a file
//                             // await entity.rename("newPath");
//
//                             // Check weather file exists
//                             // entity.exists();
//
//                             // get date of file
//                             // DateTime date = (await entity.stat()).modified;
//
//                             // get the size of the file
//                             // int size = (await entity.stat()).size;
//                           }
//                         },
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           )),
//     );
//   }
//
//   Widget subtitle(FileSystemEntity entity) {
//     return FutureBuilder<FileStat>(
//       future: entity.stat(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           if (entity is File) {
//             int size = snapshot.data!.size;
//
//             return Text(
//               "${FileManager.formatBytes(size)}",
//             );
//           }
//           return Text(
//             "${snapshot.data!.modified}",
//           );
//         } else {
//           return Text("");
//         }
//       },
//     );
//   }
//
//   selectStorage(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         child: FutureBuilder<List<Directory>>(
//           future: FileManager.getStorageList(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               final List<FileSystemEntity> storageList = snapshot.data!;
//               return Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: storageList
//                         .map((e) => ListTile(
//                       title: Text(
//                         "${FileManager.basename(e)}",
//                       ),
//                       onTap: () {
//                         controller.openDirectory(e);
//                         Navigator.pop(context);
//                       },
//                     ))
//                         .toList()),
//               );
//             }
//             return Dialog(
//               child: CircularProgressIndicator(),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   sort(BuildContext context) async {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         child: Container(
//           padding: EdgeInsets.all(10),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                   title: Text("Name"),
//                   onTap: () {
//                     controller.sortedBy = SortBy.name;
//                     Navigator.pop(context);
//                   }),
//               ListTile(
//                   title: Text("Size"),
//                   onTap: () {
//                     controller.sortedBy = SortBy.size;
//                     Navigator.pop(context);
//                   }),
//               ListTile(
//                   title: Text("Date"),
//                   onTap: () {
//                     controller.sortedBy = SortBy.date;
//                     Navigator.pop(context);
//                   }),
//               ListTile(
//                   title: Text("type"),
//                   onTap: () {
//                     controller.sortedBy = SortBy.type;
//                     Navigator.pop(context);
//                   }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   createFolder(BuildContext context) async {
//     showDialog(
//       context: context,
//       builder: (context) {
//         TextEditingController folderName = TextEditingController();
//         return Dialog(
//           child: Container(
//             padding: EdgeInsets.all(10),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ListTile(
//                   title: TextField(
//                     controller: folderName,
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     try {
//                       // Create Folder
//                       await FileManager.createFolder(
//                           controller.getCurrentPath, folderName.text);
//                       // Open Created Folder
//                       controller.setCurrentPath =
//                           controller.getCurrentPath + "/" + folderName.text;
//                     } catch (e) {}
//
//                     Navigator.pop(context);
//                   },
//                   child: Text('Create Folder'),
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//--------------------------------------------------------------------------------------------------------------------------














import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
//import 'package:file_manager/file_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
//import 'package:flutter_file_manager/flutter_file_manager.dart';
//import 'package:path_provider_extention/path_provider_extention.dart';
//import 'package:path_provider_ex/path_provider_ex.dart';



//apply this class on home: attribute at MaterialApp()
class MyFileList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MyFileList();
  }
}






class _MyFileList extends State<MyFileList>{
  //var files;
  var image_path = <String>[]; // Creates growable list.
  var g_image_path = <String>[]; // Creates growable list.


  //List<String> _images = [];
   //var list_of_images;

   //List<String> image_path = [];
  //var image_path = new List<String>.empty();
  int index=0;


  void getFiles() async { //asyn function to get list of files
    print(" ---\n");
    print(image_path);
    //List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    //var root = storageInfo[0].rootDir; //storageInfo[1] for SD card, geting the root directory
    // var fm ;//= FileManager(root: Directory(root)); //
    // files = await fm.filesTree(
    //   //set fm.dirsTree() for directory/folder tree list
    //     excludedPaths: ["/storage/emulated/0/Android"],
    //     extensions: ["png", "pdf"] //optional, to filter files, remove to list all,
    //   //remove this if your are grabbing folder list
    //);
    setState(() {}); //update the UI
  }

  void check() async {

    final myDir = Directory('storage/emulated/0/Android/data/com.example.mobile_app/files/');// change this to one from CameraPage
    var isThere = await myDir.exists();
    // print(isThere ? 'exists' : 'non-existent');
    //dirContents(myDir);

    String directory = 'storage/emulated/0/Android/data/com.example.mobile_app/files/';
    List<FileSystemEntity> files = Directory(directory).listSync(recursive: false);
    // List<String> filePaths = [];
    // for (var fileSystemEntity in files) {
    //   if (basename(fileSystemEntity.path).contains('mystring')) {
    //     filePaths.add(fileSystemEntity.path);
    //   }
    // }

   // print(filePaths);
    // Get the system temp directory.
    var systemTempDir = myDir;
    image_path.clear();

    // List directory contents, recursing into sub-directories,
    // but not following symbolic links.
    await for (var entity in
    systemTempDir.list(recursive: false, followLinks: false)) {
     // print(entity.path);
      //image_path[index]=entity.path.toString();
      //index++;
      // files=entity.path;

      String fileName = entity.path;
      //print(fileName);
      image_path.add(fileName);
      //await image_path[index]=fileName;
      //index++;
      //_images.add(fileName);
      //ilist.insertAll( 0,fileName);
      //list_of_images=_images;
      //print(image_path);

    }
    //return _images;

  }
  // Future<List<FileSystemEntity>> dirContents(Directory dir) {
  //   var files = <FileSystemEntity>[];
  //   var completer = Completer<List<FileSystemEntity>>();
  //   var lister = dir.list(recursive: false);
  //   lister.listen (
  //           (file) => files.add(file),
  //       // should also register onError
  //       onDone:   () => completer.complete(files)
  //   );
  //   print(files);
  //   return completer.future;
  // }
  Future<List<String>> getpaths() async{
    final myDir = Directory('storage/emulated/0/Android/data/com.example.mobile_app/files/');// change this to one from CameraPage
    image_path.clear();
    await for (var entity in
    myDir.list(recursive: false, followLinks: false)) {
      String fileName = entity.path;
      image_path.add(fileName);
    }
    //print(image_path);
    return image_path;
  }
  Future<void> printdata()async {
    // ignore: avoid_print
    g_image_path.clear();
     g_image_path=await getpaths() as List<String>;
    print(g_image_path);
  }
  @override
   void initState()  {
    //_images=check() as List<String>;
    //print(list_of_images);
    //check();
    super.initState();
    //printdata();
    //print(image_path);

    //getFiles(); //call getFiles() function on initial state.
    //final myDir = Directory('storage/emulated/0/Android/data/com.example.mobile_app/files/');// change this to one from CameraPage
    //files=dirContents(myDir);
    // print("    \n");
    // print(_images);
    // print(list_of_images);

  }

  //@override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       appBar: AppBar(
  //           title:Text("File/Folder list from SD Card"),
  //           backgroundColor: Colors.redAccent
  //       ),
  //       body:files == null? Text("Searching Files"):
  //       ListView.builder(  //if file/folder list is grabbed, then show here
  //         //itemCount: images.length ?? 0,
  //         itemBuilder: (context, index) {
  //           return Card(
  //               child:ListTile(
  //                 //title: Text(files[index].path.split('/').last),
  //                 title: Text(_images[index]),
  //                 leading: Icon(Icons.image),
  //                 trailing: Icon(Icons.delete, color: Colors.redAccent,),
  //               )
  //           );
  //         },
  //       )
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    //check();
    //print(image_path);

    const title = 'Meal Gallery';
    late String singlepath;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body:FutureBuilder(
          future: getpaths(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(

                child: Text('Waiting'),
              );
            }
            else{
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              else{
                return GridView.builder(gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    ),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                      return  Card(
                      child:  GridTile(
                     // footer:  Text(snapshot.data[index]['name']),
                      child: Image.file(File(snapshot.data[index]),), //Text(snapshot.data[index]['image']), //just for testing, will fill with image later
                      ),
                      );
                      },



    );
              }
            }
          },
        )
        // body: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: GridView.builder(
        //       gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        //           maxCrossAxisExtent: 200,
        //           childAspectRatio: 3 / 2,
        //           crossAxisSpacing: 20,
        //           mainAxisSpacing: 20),
        //       itemCount: g_image_path.length,
        //       itemBuilder: (BuildContext ctx, index) {
        //         return Container(
        //           alignment: Alignment.center,
        //           child:Image.file(File(g_image_path[index]),), //Text(g_image_path[index]),
        //           decoration: BoxDecoration(
        //               color: Colors.amber,
        //               borderRadius: BorderRadius.circular(15)),
        //         );
        //       }),
        // ),
    ),
      );
  }
}
    //       future: getpaths(),
    //   builder: (BuildContext context, AsyncSnapshot snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const Center(
    //         child: Text('Waiting'),
    //       );
    //     } else {
    //       if (snapshot.hasError) {
    //         return Text(snapshot.error.toString());
    //       } else {
    //         // return ListView.builder(
    //         //     itemCount: snapshot.data.length,
    //         //     itemBuilder: (BuildContext context, int index) {
    //                   return GridView.builder(
    //                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //                                  crossAxisCount: 3,
    //                                  mainAxisSpacing: 3),
    //               itemBuilder: (BuildContext context, int index) {
    //                         children: [
    //               Image.file(File(snapshot.data[index]),),
    //               ];
    //               };
    //
    //               // return ListTile(
    //               //   leading: CircleAvatar(
    //               //     backgroundImage:
    //               //     Image.file(File(snapshot.data[index]),),
    //               //     //NetworkImage(snapshot.data[index].avatar),
    //               //   ),
    //               //   title: Text(snapshot.data[index].name),
    //               //   subtitle: Text(snapshot.data[index].email),
    //               //   onTap: () {
    //               //     // Navigator.push(
    //               //     //   context,
    //               //     //   MaterialPageRoute(
    //               //     //     builder: (context) =>
    //               //     //         UserDetail(snapshot.data[index]),
    //               //     //   ),
    //               //     // );
    //               //   },
    //               // );
    //             });
    //       }
    //     }
    //   },
    // ),
    //   //   GridView(
    //   //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //   //           crossAxisCount: 3,
    //   //           mainAxisSpacing: 3),
    //   //       children:[
    //   //         for (singlepath in image_path){
    //   //           Image.file(File(g_image_path[1]),),
    //   //         }
    //   //       ]
    //   //      //   for (singlepath in image_path)
    //   //     //{
    //   //     //    Image.file(File(g_image_path[1]),), Image.file(File(g_image_path[2]),),Image.file(File(g_image_path[0]),),
    //   //
    //   //     //}
    //   //
    //   //
    //   //         //Image.file(File('storage/emulated/0/Android/data/com.example.mobile_app/files/gallery2.png'),),
    //   //         //Image.file(File('storage/emulated/0/Android/data/com.example.mobile_app/files/camera3.png'),),
    //   //         //Image.network('https://picsum.photos/250?image=2'),
    //   //         //Image.network('https://picsum.photos/250?image=3'),
    //   //
    //   // )
    //   ),
//     );
//   }
// }





//-------------------------------------------------------------------------------------------------------------------

// //apply this class on home: attribute at MaterialApp()
// class MyFileList extends StatefulWidget{
//   @override
//   State<StatefulWidget> createState() {
//     return _MyFileList();
//   }
// }
//
// class _MyFileList extends State<MyFileList>{
//   var files;
//
//   void getFiles() async { //asyn function to get list of files
//     List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
//     var root = storageInfo[0].rootDir; //storageInfo[1] for SD card, geting the root directory
//     var fm = FileManager(root: Directory(root)); //
//     files = await fm.filesTree(
//       //set fm.dirsTree() for directory/folder tree list
//         excludedPaths: ["/storage/emulated/0/Android/data/com.example.mobile_app/files/"],
//         extensions: ["png", "pdf"] //optional, to filter files, remove to list all,
//       //remove this if your are grabbing folder list
//     );
//     setState(() {}); //update the UI
//   }
//
//   @override
//   void initState() {
//     getFiles(); //call getFiles() function on initial state.
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//             title:Text("File/Folder list from SD Card"),
//             backgroundColor: Colors.redAccent
//         ),
//         body:files == null? Text("Searching Files"):
//         ListView.builder(  //if file/folder list is grabbed, then show here
//           itemCount: files?.length ?? 0,
//           itemBuilder: (context, index) {
//             return Card(
//                 child:ListTile(
//                   title: Text(files[index].path.split('/').last),
//                   leading: Icon(Icons.image),
//                   trailing: Icon(Icons.delete, color: Colors.redAccent,),
//                 )
//             );
//           },
//         )
//     );
//   }
// }