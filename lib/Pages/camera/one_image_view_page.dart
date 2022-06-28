import 'package:flutter/material.dart';

import 'list_of_images.dart';

class showimage extends StatelessWidget {
  var imageurl;
  showimage(this.imageurl) {
    print("======");
    print(imageurl);

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EasyFlutter',
      home: Scaffold(
        appBar: null,
        body: Center(
          child: Image.network(
            imageurl,
            height: 400,
            width: 400,
          ),
        ),
      ),
    );
  }
}



