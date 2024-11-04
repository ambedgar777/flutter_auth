import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/UI/auth/login_screen.dart';
import 'package:flutter_auth/post/add_post.dart';
import 'package:flutter_auth/utils/utils.dart';

class PostScreen extends StatelessWidget {
  PostScreen({super.key});

  final auth = FirebaseAuth.instance;
  final firebaseRef = FirebaseDatabase.instance.ref('Post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('POST SCREEN'),
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
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: firebaseRef.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                } else {
                  Map<dynamic, dynamic> map =
                      snapshot.data!.snapshot.value as dynamic;
                  List<dynamic> list = [];
                  list.clear();
                  list = map.values.toList();

                  return ListView.builder(
                    itemCount: snapshot.data!.snapshot.children.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(list[index]['title']),
                        subtitle: Text(list[index]['desc']),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Expanded(
            //FirebaseAnimatedList is used inside body
            //and it requires widget as a child
            child: FirebaseAnimatedList(
              query: firebaseRef,
              defaultChild: const Text('Loading'),
              itemBuilder: (context, snapShot, animation, index) {
                return ListTile(
                  title: Text(snapShot.child('title').value.toString()),
                  subtitle: Text(snapShot.child('desc').value.toString()),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.purple),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPost(),
            ),
          );
        },
      ),
    );
  }
}
