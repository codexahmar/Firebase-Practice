import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_practice/services/auth_service.dart';
import 'package:firebase_practice/services/firestore_service.dart';
import 'package:firebase_practice/ui/auth/login_screen.dart';
import 'package:firebase_practice/ui/firestore/add_firestore_data_screen.dart';
import 'package:firebase_practice/utils/utils.dart';
import 'package:firebase_practice/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class FirestoreListScreen extends StatefulWidget {
  const FirestoreListScreen({super.key});

  @override
  State<FirestoreListScreen> createState() => _FirestoreListScreenState();
}

class _FirestoreListScreenState extends State<FirestoreListScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final searchController = TextEditingController();
  final editController = TextEditingController();

  Future<void> editDialogBox(String title, String id) {
    editController.text = title;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Firestore Post"),
          content: CustomTextField(
            controller: editController,
            hintText: "Update post",
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
                await _firestoreService.updatePost(id, editController.text.trim());
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
                await _firestoreService.deletePost(id);
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
        title: const Text("Firestore Posts", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
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
              hintText: "Search posts...",
              prefixIcon: Icons.search,
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestoreService.getPosts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No posts found."));
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final post = docs[index].data() as Map<String, dynamic>;
                      final title = post['title'] ?? 'N/A';
                      final id = post['docId'] ?? '';

                      // Search filter
                      if (searchController.text.isNotEmpty &&
                          !title.toLowerCase().contains(searchController.text.toLowerCase())) {
                        return const SizedBox.shrink();
                      }

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                                onTap: () {
                                  // Use Future.delayed to show dialog after popup menu closes
                                  Future.delayed(Duration.zero, () => editDialogBox(title, id));
                                },
                              ),
                              PopupMenuItem(
                                child: const ListTile(
                                  leading: Icon(Icons.delete, color: Colors.red),
                                  title: Text("Delete", style: TextStyle(color: Colors.red)),
                                ),
                                onTap: () {
                                  Future.delayed(Duration.zero, () => deleteDialogBox(id));
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddFirestoreDataScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}


