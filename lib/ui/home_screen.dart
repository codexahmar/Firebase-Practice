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
  final searchController = TextEditingController();
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search posts...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  // Trigger a rebuild to update the list based on the search query
                });
              },
            ),

            // Uncomment the following code to use FirebaseAnimatedList instead of StreamBuilder
            Expanded(
              child: FirebaseAnimatedList(
                defaultChild: Center(child: CircularProgressIndicator()),
                query: _dbRef,
                itemBuilder: (context, snapshot, animation, index) {
                  debugPrint(snapshot.value.toString());
                  final post = snapshot.value as Map<dynamic, dynamic>;

                  if (searchController.text.isEmpty) {
                    return ListTile(title: Text(post['title'] ?? 'N/A'));
                  } else if (post['title'].toString().toLowerCase().contains(
                    searchController.text.toLowerCase(),
                  )) {
                    return ListTile(title: Text(post['title'] ?? 'N/A'));
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ),

            // Uncomment the following code to use StreamBuilder instead of FirebaseAnimatedList
            // Expanded(
            //   child: StreamBuilder(
            //     stream: _dbRef.onValue,
            //     builder: (context, snapshot) {
            //       if (!snapshot.hasData) {
            //         return const Center(child: CircularProgressIndicator());
            //       }

            //       if (snapshot.data!.snapshot.value == null) {
            //         return const Center(child: Text("No posts found."));
            //       }

            //       final data =
            //           snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            //       final posts = data.values.toList();

            //       final filteredPosts = searchController.text.isEmpty
            //           ? posts
            //           : posts.where((post) {
            //               return post['title']
            //                   .toString()
            //                   .toLowerCase()
            //                   .contains(searchController.text.toLowerCase());
            //             }).toList();

            //       if (filteredPosts.isEmpty) {
            //         return const Center(child: Text("No posts found."));
            //       }

            //       return ListView.builder(
            //         itemCount: filteredPosts.length,
            //         itemBuilder: (context, index) {
            //           final post = filteredPosts[index];

            //           return ListTile(
            //             title: Text(post['title']?.toString() ?? 'N/A'),
            //           );
            //         },
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
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
