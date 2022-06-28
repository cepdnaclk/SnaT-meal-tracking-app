import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../Services/IamageStoreService.dart';
import 'one_image_view_page.dart';

class ScrollViewlist extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScrollViewlist();
  }
}

class _ScrollViewlist extends State<ScrollViewlist> {
  //var files;
  final imageStorage staorage = imageStorage();
  var image_path = <String>[]; // Creates growable list.

  @override
  void initState() {
    print("====================================================================\n");
    print("dsds\n");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Meal Gallery'; // main Title
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: Scaffold(
          appBar: null,
          body: FutureBuilder(
            future: staorage.loadImages(),
            //getpaths(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // untill the data is load
                return const Center(
                  //child: Text('Waiting'),
                  child:
                  CircularProgressIndicator(backgroundColor: Colors.red,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),),
                );
              } else {
                if (snapshot.hasError) {
                  // for errors
                  return Text(snapshot.error.toString());
                } else {
                  return GridView.builder(
                    gridDelegate: // grid view
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return
                        Card(
                            child: InkWell(
                              onTap: () {// view individual image
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (contex)
                                    {
                                      return showimage(snapshot.data[index]);
                                    })
                                );
                              },
                              onLongPress: () {},
                              child: Image.network(
                                snapshot.data[index],
                              ),
                            )
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
