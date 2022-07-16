import 'package:get/get.dart';

class LocalString extends Translations{

  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {

    // key and English(US) translation
    'en_US':{
      'age': 'Age',
      'weight': 'Weight(Kg)',
      'settings' : 'Settings',
      'common' : 'Common Settings',
      'language' : 'Language',
      'lang' : 'English',
      'customTheme' : 'Enable custom theme',
    },

    // key and Sinhala translation
    'si_SL':{
      'age': 'වයස',
      'weight': 'බර (Kg)',
      'settings' : 'සැකසුම්',
      'common' : 'පොදු සැකසුම්',
      'language' : 'භාෂාව',
      'lang' : 'සිංහල',
      'customTheme' : 'අභිරුචි තේමාව වෙනස් කරන්න',
    },

    // key and Tamil translation
    'tm_SL_':{
      'age': 'வயது',
      'weight': 'எடை (Kg)',
      'settings' : 'அமைப்புகள்',
      'common' : 'பொதுவான அமைப்புகள்',
      'language' : 'மொழி',
      'lang' : 'தமிழ்',
      'customTheme' : 'தனிப்பயன் தீம் இயக்கவும்',
    }

  };

}