import 'package:flutter/material.dart';
class oneimageviewfromgrid extends StatelessWidget {
  var imageurl;
  oneimageviewfromgrid(this.imageurl) {
    print(imageurl);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EasyFlutter',
      home: Scaffold(
        appBar:null,
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
