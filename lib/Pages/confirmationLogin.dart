import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/login_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  bool isLoggedIn = false;

  checkAuthentification(){
    _auth.authStateChanges().listen((user){
      if(user == null){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
      }
    });
  }


  getUser() async{
    User? firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;
  

  if(firebaseUser != null){
    setState((){
      this.user = firebaseUser;
      this.isLoggedIn = true;
    });
  }
  }

  signOut() async{
    _auth.signOut();
  }

  @override
  void initState(){
    this.checkAuthentification();
    this.getUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

       body:Container(
        child: !isLoggedIn? CircularProgressIndicator():
        Column(
          children: [
            Container(
              height: 400,
              
            ),

            Container(
              child: Text("Hello ${user!.displayName} you are logged in as ${user!.email}",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold
              )),
            ),

            ElevatedButton(
                        
                        onPressed: signOut,
                        child: Text('Sign In',style: TextStyle(
                          color: Color.fromARGB(255, 117, 107, 107),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold
                        ),)
                      )

          ],
        )
      )
    );
  }
}