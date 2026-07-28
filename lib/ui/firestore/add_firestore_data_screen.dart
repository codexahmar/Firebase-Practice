import 'package:firebase_practice/services/firestore_service.dart';
import 'package:firebase_practice/utils/utils.dart';
import 'package:firebase_practice/widgets/custom_text_field.dart';
import 'package:firebase_practice/widgets/round_button.dart';
import 'package:flutter/material.dart';

class AddFirestoreDataScreen extends StatefulWidget {
  const AddFirestoreDataScreen({super.key});

  @override
  State<AddFirestoreDataScreen> createState() => _AddFirestoreDataScreenState();
}

class _AddFirestoreDataScreenState extends State<AddFirestoreDataScreen> {
  final postController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  bool isLoading = false;

  void postData() async {
    try {
      if (postController.text.isEmpty) {
        Utils().toastMessage("Please enter a post.");
        return;
      }

      setState(() {
        isLoading = true;
      });

      await _firestoreService.writePost(postController.text.trim());
      setState(() {
        isLoading = false;
        postController.clear();
      });
      Utils().toastMessage("Post added to Firestore!");
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Utils().toastMessage(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Firestore Post", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            CustomTextField(
              controller: postController,
              hintText: "What's on your mind?",
              prefixIcon: Icons.edit_note,
            ),
            const SizedBox(height: 30),
            RoundButton(
              title: "Add Post",
              onTap: postData,
              loading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
