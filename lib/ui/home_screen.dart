import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_practice/services/auth_service.dart';
import 'package:firebase_practice/ui/auth/login_screen.dart';
import 'package:firebase_practice/ui/post_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthService _authService = AuthService();
  final _dbRef = FirebaseDatabase.instance.ref("posts");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // Handle logout logic here
              _authService.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Uncomment the following code to use FirebaseAnimatedList instead of StreamBuilder
          Expanded(
            child: FirebaseAnimatedList(
              defaultChild: Center(child: CircularProgressIndicator()),
              query: _dbRef,
              itemBuilder: (context, snapshot, animation, index) {
                debugPrint(snapshot.value.toString());
                final post = snapshot.value as Map<dynamic, dynamic>;
                return ListTile(title: Text(post['title'] ?? 'N/A'));
              },
            ),
          ),

// Uncomment the following code to use StreamBuilder instead of FirebaseAnimatedList

          // Expanded(
          //   child: StreamBuilder(
          //     stream: _dbRef.onValue,
          //     builder: (context, snapshot) {
          //       if (!snapshot.hasData) {
          //         return Center(child: CircularProgressIndicator());
          //       } else {
          //         final data =
          //             snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          //         final posts = data.values.toList();
          //         return ListView.builder(
          //           itemCount: snapshot.data!.snapshot.children.length,

          //           itemBuilder: (context, index) {
          //             final post = posts[index];
          //             return ListTile(
          //               title: Text(post['title']?.toString() ?? 'N/A'),
          //             );
          //           },
          //         );
          //       }
          //     },
          //   ),
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
