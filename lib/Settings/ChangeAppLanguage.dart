import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeLanguage {

  final List locale = [
    {'name': 'English(US)', 'locale': const Locale('en', 'US')},
    {'name': 'සිංහල', 'locale': const Locale('si', 'SL')},
    {'name': 'தமிழ்', 'locale': const Locale('tm', 'SL')}
  ];

  updateLanguage(Locale locale){
    Get.back();
    Get.updateLocale(locale);
  }

  buildLanguageDialog(BuildContext context){
    showDialog(context: context,
        builder: (builder){
          return AlertDialog(
            title: const Text('Choose Your Language'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(child: Text(locale[index]['name']),onTap: (){
                        print(locale[index]['name']);
                        updateLanguage(locale[index]['locale']);
                      },),
                    );
                  }, separatorBuilder: (context,index){
                return const Divider(
                  color: Colors.blue,
                );
              }, itemCount: locale.length
              ),
            ),
          );
        }
    );
  }


}
