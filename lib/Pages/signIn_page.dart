import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/dashboard_layout.dart';
import 'package:mobile_app/Pages/signUp_page.dart';
import 'package:mobile_app/Services/custom_page_route.dart';
import 'package:mobile_app/Theme/theme_info.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _email, _password;

  checkAuthentification() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.of(context).push(CustomPageRoute(child: DashboardLayout()));
    }

    @override
    void initState() {
      super.initState();
      this.checkAuthentification();
    }
  }

  login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        UserCredential result = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
        //User user = await _auth.signInWithEmailAndPassword(email: _email, password: _password);
        User? user = result.user;
        Navigator.of(context).push(CustomPageRoute(child: DashboardLayout()));
      } catch (e) {
        showError();
      }
    }
  }

  showError() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text("The password is invalid or user haven't password"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok'))
            ],
          );
        });
  }

  navigateToSignUp() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8.0,
        backgroundColor: ThemeInfo.primaryColor,
        title: const Text("Sign In"),
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          children: [
            Container(
              //height:400,
              child: Image(
                image: AssetImage("assets/images/signIn.jpg"),
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20),
            Container(
                child: Form(
              key: _formKey,
              child: Column(children: [
                Container(
                    child: TextFormField(
                        validator: (String? input) {
                          if (input!.isEmpty) return 'Enter Email';
                        },
                        decoration: InputDecoration(
                            labelText: 'Email', prefixIcon: Icon(Icons.email)),
                        onSaved: (input) => _email = input)),
                Container(
                    child: TextFormField(
                        validator: (String? input) {
                          if (input!.length < 6)
                            return 'Provide Minimum 6 Characters';
                        },
                        decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock)),
                        obscureText: true,
                        onSaved: (input) => _password = input)),
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: login,
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ))
              ]),
            )),
            SizedBox(height: 20),
            GestureDetector(
              child: Text(
                'Create an Account?',
                style: TextStyle(color: Colors.blueAccent),
              ),
              onTap: navigateToSignUp,
            )
          ],
        )),
      ),
    );
  }
}
