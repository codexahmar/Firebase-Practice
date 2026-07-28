import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_practice/services/auth_service.dart';
import 'package:firebase_practice/services/realtime_db.dart';
import 'package:firebase_practice/ui/auth/login_screen.dart';
import 'package:firebase_practice/ui/realtimeDb/post_screen.dart';
import 'package:firebase_practice/utils/utils.dart';
import 'package:firebase_practice/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final RealtimeDb _realtimeDb = RealtimeDb();
  final _dbRef = FirebaseDatabase.instance.ref("posts");
  final searchController = TextEditingController();
  final editController = TextEditingController();

  Future<void> editDialogBox(String title, String id) {
    editController.text = title;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Post"),
          content: CustomTextField(
            controller: editController,
            hintText: "Update your post",
            prefixIcon: Icons.edit,
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Update"),
              onPressed: () async {
                Navigator.pop(context);
                await _realtimeDb.updatePost(id, editController.text.trim());
                Utils().toastMessage("Post updated successfully");
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteDialogBox(String id) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete"),
          content: const Text("Are you sure you want to delete this post?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () async {
                Navigator.pop(context);
                await _realtimeDb.deletePost(id);
                Utils().toastMessage("Post deleted successfully");
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Realtime Posts"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _authService.signOut();
              Navigator.pushReplacement(
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
          children: [
            CustomTextField(
              controller: searchController,
              hintText: "Search realtime database...",
              prefixIcon: Icons.search,
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FirebaseAnimatedList(
                defaultChild: const Center(child: CircularProgressIndicator()),
                query: _dbRef,
                itemBuilder: (context, snapshot, animation, index) {
                  final post = snapshot.value as Map<dynamic, dynamic>;
                  final title = post['title'] ?? 'N/A';
                  final id = post['id']?.toString() ?? '';

                  if (searchController.text.isNotEmpty &&
                      !title.toString().toLowerCase().contains(searchController.text.toLowerCase())) {
                    return const SizedBox.shrink();
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: Text("ID: $id", style: const TextStyle(fontSize: 10)),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: const ListTile(
                              leading: Icon(Icons.edit),
                              title: Text("Edit"),
                            ),
                            onTap: () => Future.delayed(Duration.zero, () => editDialogBox(title, id)),
                          ),
                          PopupMenuItem(
                            child: const ListTile(
                              leading: Icon(Icons.delete, color: Colors.red),
                              title: Text("Delete", style: TextStyle(color: Colors.red)),
                            ),
                            onTap: () => Future.delayed(Duration.zero, () => deleteDialogBox(id)),
                          ),
                        ],
                      ),
                    ),
                  );
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
