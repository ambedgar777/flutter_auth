import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth/UI/auth/login_with_phone_no.dart';
import 'package:flutter_auth/UI/auth/signup_screen.dart';
import 'package:flutter_auth/post/post_screen.dart';
import 'package:flutter_auth/utils/utils.dart';
import 'package:flutter_auth/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //loading variable
  bool loading = false;

  //email and password controllers
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  //global form key
  final formKey = GlobalKey<FormState>();

  //firebase auth instance
  FirebaseAuth _auth = FirebaseAuth.instance;

  //login method
  void login(BuildContext context) {
    setState(() {
      loading = true;
    });

    _auth
        .signInWithEmailAndPassword(
            email: _emailController.text.toString(),
            password: _passwordController.text.toString())
        .then((value) {
      Utils().toastMessage(
        value.user!.email.toString(),
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PostScreen()));
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      Utils().toastMessage(error.toString());
      setState(() {
        loading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Login'),
          centerTitle: true,
          backgroundColor: Colors.deepPurple.shade200,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        //keyboard type
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          suffixIcon: Icon(Icons.email),
                        ),

                        //validator to check if user has put in email
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter your email';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        //keyboard type
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          hintText: 'Password',
                          suffixIcon: Icon(Icons.password),
                        ),
                        //to check if user has put password
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter your password';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  )),
              const SizedBox(height: 20),
              RoundButton(
                loading: loading,
                title: 'Login',
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    login(context);
                  }
                },
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a user already?',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  TextButton(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupScreen()));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginWithPhoneNo()));
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.black),
                  ),
                  child: const Center(
                    child: Text(
                      'Login with phone number',
                      style: TextStyle(),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
