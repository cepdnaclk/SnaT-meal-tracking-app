import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Services/custom_page_route.dart';
import 'package:mobile_app/Pages/dashboard_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app/Theme/theme_info.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, }) : super(key: key);
  
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  
  
  final _nameController = TextEditingController();
  final _birthController = TextEditingController();
  final _genderController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void dispose(){
    _nameController.dispose();
    _birthController.dispose();
    _genderController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();

  }
  
  @override
  void initState(){
    _birthController.text = '';
    super.initState();
   
  }
 
  
  
  
  
  


  Future addUserDetails(String name,String birthDate,String gender,String height,String weight,String userID,String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      'name':name,
      'birthDate':birthDate,
      'gender':gender,
      'height':height,
      'weight':weight,
      'uid': userID,
      'email': email,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: ThemeInfo.primaryColor,
      appBar: AppBar(
          elevation: 8.0,
          backgroundColor: ThemeInfo.primaryColor,
          title: const Text("User Details"),
        ),
      body: SafeArea(
        child:SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              // Text(
              //   'User Details',
              //   style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              Container(
                height:150,
                child: Image(image: AssetImage("assets/images/userDetails.jpg"),
                fit: BoxFit.contain,
                ),
              ),
        
        
              Padding(
                
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Name',
                    fillColor: Colors.teal[100],
                    filled: true,
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
              SizedBox(height: 15),
        
        
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _birthController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Date of birth',
                    fillColor: Colors.teal[100],
                    filled: true,
                    prefixIcon: Icon(Icons.calendar_month)
                    
                  ),
                  
                  onTap: () async {
                    var date =  await showDatePicker(
                      context: context, 
                      initialDate: DateTime.now(), 
                      firstDate: DateTime(1950), 
                      lastDate: DateTime(2101));
                    _birthController.text = date.toString().substring(0,10);

                    
                  },
                ),),
         
                
                SizedBox(height: 15),
        
        
        
        
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _genderController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Gender',
                    fillColor: Colors.teal[100],
                    filled: true,
                    prefixIcon: Icon(Icons.boy),
                    
                  ),
                ),
                
              ),
             
                
                SizedBox(height: 15),
        
        
        
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _heightController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Height(cm)',
                    fillColor: Colors.teal[100],
                    filled: true,
                    prefixIcon: Icon(Icons.height),
                  ),
                ),
                ),
                SizedBox(height: 15),
        
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _weightController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Weight(kg)',
                    fillColor: Colors.teal[100],
                    filled: true,
                    prefixIcon: Icon(Icons.monitor_weight_rounded),
                  ),
                ),
                ),
                SizedBox(height: 25),
        
        
              ElevatedButton(
                onPressed: () {
                  User? user = FirebaseAuth.instance.currentUser;
                  String uid;
                  var email;
                    if(user != null){
                      uid = user.uid;
                      email = user.email;
                    }
                    else{
                      uid = '';
                      email = '';
                    }
                  addUserDetails(
                               _nameController.text.trim(),
                               _birthController.text.trim(),
                               _genderController.text.trim(),
                               _heightController.text.trim(),
                               _weightController.text.trim(),
                               uid,
                               email,
                  );
                  Navigator.of(context).push(CustomPageRoute(
                            child: DashboardLayout(),
                            transition: "slide right"));
                },
                child: Text(
                  "   Let's get started   ",
                    style: TextStyle(fontSize: 20 ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: ThemeInfo.bottomTabButtonColor,
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(vertical: 10),
          )
        )
        
            ],
        
          ),
        ))
      );
    
  }
}