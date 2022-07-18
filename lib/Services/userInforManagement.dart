import 'package:cloud_firestore/cloud_firestore.dart';

import '../Pages/welcome_screen.dart';

class userInfor {
  late String name;
  late String id;
  late String email;
  late String gender;
  late String height;
  late String weight;
  late String birthDate;

  final _firestore = FirebaseFirestore.instance;

  userInfor() {
    email = user?.email as String;
    id = user!.uid;
  }

  Future<String> getNameFromFirebase() async {
    List<String> namelist = [];
    final urls = await _firestore
        .collection('user_Images')
        .doc(id)
        .collection('private_infor')
        .get();
    for (var temname in urls.docs) {
      namelist.add(temname.data()['name'].toString());
    }
    name = namelist.last;
    // get last element of the list to get latest version
    return name;
  }

  void setNameToFireBase(String name) async {
    _firestore.collection('user_details').doc(id).collection('private_infor')
        // .doc(date)
        // .collection(mealtime)
        .add({
      'name': name,
    });
    this.name = name;
  }

  Future<String> getIdFromFirebase() async {
    List<String> idlist = [];
    final ids = await _firestore
        .collection('user_Images')
        .doc(id)
        .collection('private_infor')
        .get();
    for (var idname in ids.docs) {
      idlist.add(idname.data()['id'].toString());
    }
    id = idlist.last;
    // get last element of the list to get latest version
    return id;
  }

  void setIdToFireBase(String id) async {
    _firestore
        .collection('user_details')
        .doc(id)
        .collection('private_infor')
        .add({
      'id': id,
    });
    this.id = id;
  }

  Future<String> getEmail() async {
    return email;
  }

  void setGenderToFirebase(String gender) {
    _firestore
        .collection('user_details')
        .doc(id)
        .collection('private infor')
        .add({
      'gender': gender,
    });
  }

  Future<String> getGenderFromFirebase() async {
    List<String> Genderlist = [];
    final genders = await _firestore
        .collection('user_Images')
        .doc(id)
        .collection('private_infor')
        .get();
    for (var temgender in genders.docs) {
      Genderlist.add(temgender.data()['gender'].toString());
    }
    gender = Genderlist.last;
    // get last element of the list to get latest version
    return gender;
  }

  void setHeightToFirebase(String height) {
    _firestore
        .collection('user_details')
        .doc(id)
        .collection('private_infor')
        .add({
      'height': height,
    });
  }

  Future<String> getHeightFromFirebase() async {
    List<String> heightlist = [];
    final heights = await _firestore
        .collection('user_Images')
        .doc(id)
        .collection('private_infor')
        .get();
    for (var temheight in heights.docs) {
      heightlist.add(temheight.data()['height'].toString());
    }
    // get last element of the list to get latest version
    height = heightlist.last;
    return height;
  }

  void setWeightToFirebase(String weight) {
    _firestore
        .collection('user_details')
        .doc(id)
        .collection('private_infor')
        .add({
      'weight': weight,
    });
  }

  Future<String> getWeightFromFirebase() async {
    List<String> weightlist = [];
    final weights = await _firestore
        .collection('user_Images')
        .doc(id)
        .collection('private_infor')
        .get();
    for (var temweight in weights.docs) {
      weightlist.add(temweight.data()['weight'].toString());
    }
    weight = weightlist.last;
    // get last element of the list to get latest version
    return gender;
  }

  void setBirthDateToFirebase(String birthDate) {
    _firestore
        .collection('user_details')
        .doc(id)
        .collection('private_infor')
        .add({
      'birthDate': birthDate,
    });
  }

  Future<String> getBirthDateFromFirebase() async {
    List<String> birthDatelist = [];
    final birthDates = await _firestore
        .collection('user_Images')
        .doc(id)
        .collection('private_infor')
        .get();
    for (var tembirthDate in birthDates.docs) {
      birthDatelist.add(tembirthDate.data()['gender'].toString());
    }
    // get last element of the list to get latest version
    birthDate = birthDatelist.last;
    return birthDate;
  }
}
