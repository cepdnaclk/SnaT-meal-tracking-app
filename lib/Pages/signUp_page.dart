import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app/Pages/confirmationLogin.dart';
import 'package:mobile_app/Theme/theme_info.dart';
import 'package:mobile_app/Pages/signIn_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _email, _password, _name;

  checkAuthentification() async{
    _auth.authStateChanges().listen((user){
     if(user != null) {
      Navigator.push(context, MaterialPageRoute(builder: ((context) => HomePage())));
     }
    });
  }
  @override
  void initState(){
    super.initState();
    this.checkAuthentification();
  }


  signUp()async {
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      
      try{
        UserCredential result = await _auth.createUserWithEmailAndPassword(email: _email, password: _password);
        //User user = await _auth.signInWithEmailAndPassword(email: _email, password: _password);
        User? user = result.user;
        if(user!= null){
          //UserUpdateInfo updateuser = UserUpdateInfo();
          //updateuser.displayName = _name;
          //user.updateProfile(updateuser);

          await _auth.currentUser!.updateDisplayName(_name);
        }

      }
      
      catch(e){
        
        
        var message;
        showError();
      }
    }
  }


  showError(){

    showDialog(context: context,
     builder: (BuildContext context){
      return AlertDialog(
        title: Text('Error'),
        content: Text('You have already signed up'),

        actions:[
          TextButton(
            onPressed: (){
              Navigator.of(context).pop();
            }, 
            child: Text('Ok') )
        ],
      );
     });

  }

  navigateToSignIn() async{
    Navigator.push(context, MaterialPageRoute(builder : (context) => SignIn()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 8.0,
          backgroundColor: ThemeInfo.primaryColor,
          title: const Text("Sign Up"),
        ),
      body: SingleChildScrollView(
        child: Container(
      
          child: Column(
      
            children: [
              Container(
                //height:400,
                child: Image(image: AssetImage("assets/images/images.jpg"),
                fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children:[

                      Container(
      
                        child: TextFormField(
                          validator: (String? input){
                            if(input!.isEmpty) return 'Enter name';
                          },
                            decoration: InputDecoration(
                              labelText: 'Username',
                              prefixIcon:Icon(Icons.person)
                            ),
                            onSaved: (input) => _name = input
                          
                        )
                      ),
      

                      Container(
      
                        child: TextFormField(
                          validator: (String? input){
                            if(input!.isEmpty) return 'Enter Email';
                          },
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon:Icon(Icons.email)
                            ),
                            onSaved: (input) => _email = input
                          
                        )
                      ),
      
      
                      Container(
      
                        child: TextFormField(
                          validator: (String? input){
                            if(input!.length < 6) return 'Provide Minimum 6 Characters';
                            
                          },
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon:Icon(Icons.lock)
                            ),
      
                            obscureText: true,
                            onSaved: (input) => _password = input
                          
                        )
                      ),
      
                      SizedBox(height: 20),                    
                      ElevatedButton(
                        
                        onPressed: signUp,
                        child: Text('Sign Up',style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold
                        ),)
                      )
                    ]
                  ),
                )
              ),

              SizedBox(height:20),
              GestureDetector(
                child: Text('Already have an account?',style: TextStyle(
                  color: Colors.blueAccent
                ),),
                onTap: navigateToSignIn,
              )
            ],
          )
        ),
      ),
    );
  }
}