import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Services/custom_page_route.dart';
import 'package:mobile_app/Pages/dashboard_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app/Theme/theme_info.dart';


class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key, }) : super(key: key);
  
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  
  
  TextEditingController _emailController = TextEditingController();
  

  @override
  void dispose(){
    _emailController.dispose();
    
    super.dispose();

  }
  
  @override
  void initState(){
    super.initState();
   
  }

  Future verifyEmail() async{
    
    try{
    await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
    showDialog(
      context:context,
      builder: (context){
        return AlertDialog(content: Text('Password reset link sent! Check your email'),);
      }
    );
    }
    on FirebaseAuthException catch (e){
      print(e);
      Navigator.of(context).pop();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: ThemeInfo.primaryColor,
      appBar: AppBar(
          elevation: 8.0,
          backgroundColor: ThemeInfo.primaryColor,
          title: const Text("Reset Password"),
        ),
      body: SafeArea(
        child:SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              
              Container(
                height:150,
                child: Image(image: AssetImage("assets/images/userDetails.jpg"),
                fit: BoxFit.contain,
                ),
              ),
        
        
              Padding(
                
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Email',
                    fillColor: Colors.teal[100],
                    filled: true,
                    prefixIcon: Icon(Icons.mail),
                  ),
                ),
              ),
              SizedBox(height: 15),
        
        
               
        
              ElevatedButton(
                onPressed: verifyEmail,
                child: Text(
                  "  Reset Password  ",
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