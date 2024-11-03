import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/UI/auth/login_screen.dart';
import 'package:flutter_auth/utils/utils.dart';

class PostScreen extends StatelessWidget {
  PostScreen({super.key});

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Post Screen'),
        backgroundColor: Colors.deepPurple.shade200,
        centerTitle: true,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            },
            icon: const Icon(Icons.login_outlined),
          ),
        ],
      ),
    );
  }
}
