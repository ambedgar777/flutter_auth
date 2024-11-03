import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/post/post_screen.dart';
import 'package:flutter_auth/utils/utils.dart';
import 'package:flutter_auth/widgets/round_button.dart';

class VerifyCode extends StatefulWidget {
  final String verificationId;

  const VerifyCode({super.key, required this.verificationId});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  final verifyCodeController = TextEditingController();
  bool loading = false;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Verification'),
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
              controller: verifyCodeController,
              decoration: const InputDecoration(
                hintText: 'Enter 6 digit code',
              ),
            ),
            const SizedBox(height: 80),
            RoundButton(
              title: 'Verify',
              loading: loading,
              onTap: () async {
                setState(() {
                  loading = true;
                });
                final credentialsToken = PhoneAuthProvider.credential(
                  verificationId: widget.verificationId,
                  smsCode: verifyCodeController.text.toString(),
                );
                try{
                  await auth.signInWithCredential(credentialsToken);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen(),),);

                }catch(e){
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage(e.toString());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
