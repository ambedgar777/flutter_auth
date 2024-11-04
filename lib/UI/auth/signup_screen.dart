import 'package:flutter/material.dart';
import 'package:flutter_auth/UI/auth/login_screen.dart';
import 'package:flutter_auth/post/post_screen.dart';
import 'package:flutter_auth/utils/utils.dart';
import 'package:flutter_auth/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  //loading variable
  bool loading = false;

  //email and password controller
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  //form key
  final formKey = GlobalKey<FormState>();

  //firebase auth instance / initialization
  FirebaseAuth _auth = FirebaseAuth.instance;

  //login function
  void signUp(){
    setState(() {
      loading = true;
    });

    _auth
        .createUserWithEmailAndPassword(
        email: _emailController.text.toString(),
        password: _passwordController.text.toString())
        .then((value) {
      setState(() {
        loading = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen()));
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
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
              title: 'Sign Up',
              loading: loading,
              onTap: () {
                if (formKey.currentState!.validate()) {
                  signUp();
                }
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?',
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
