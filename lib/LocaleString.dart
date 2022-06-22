import 'package:get/get.dart';

class LocalString extends Translations{

  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {

    // key and English(US) translation
    'en_US':{
      'age': 'Age',
      'weight': 'Weight(Kg)'
    },

    // key and Sinhala translation
    'si_SL':{
      'age': 'වයස',
      'weight': 'බර (Kg)'
    },

    // key and Tamil translation
    'tm_SL_':{
      'age': 'வயது',
      'weight': 'எடை (Kg)'
    }

  };

}