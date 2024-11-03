import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/UI/auth/verify_code.dart';
import 'package:flutter_auth/utils/utils.dart';
import 'package:flutter_auth/widgets/round_button.dart';

class LoginWithPhoneNo extends StatefulWidget {
  const LoginWithPhoneNo({super.key});

  @override
  State<LoginWithPhoneNo> createState() => _LoginWithPhoneNoState();
}

class _LoginWithPhoneNoState extends State<LoginWithPhoneNo> {

  final phoneNumberController = TextEditingController();
  bool loading = false;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Login With Phone no'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade200,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 80),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: phoneNumberController,
              decoration: const InputDecoration(
                hintText: '+1 234 567890',
              ),
            ),
            const SizedBox(height: 80),
            RoundButton(
              title: 'Login',
              loading: loading,
              onTap: () {
                setState(() {
                  loading = true;
                });
                auth.verifyPhoneNumber(
                  phoneNumber: phoneNumberController.text.toString(),
                  verificationCompleted: (_) {
                    setState(() {
                      loading = false;
                    });
                  },
                  verificationFailed: (e) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(e.toString());
                  },
                  codeSent: (String verificationId, int? token) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerifyCode(
                          verificationId: verificationId,
                        ),
                      ),
                    );
                    setState(() {
                      loading = false;
                    });
                  },
                  codeAutoRetrievalTimeout: (e) {
                    Utils().toastMessage(e.toString());
                    setState(
                      () {
                        loading = false;
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
