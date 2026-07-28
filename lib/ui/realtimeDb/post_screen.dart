import 'package:firebase_practice/services/realtime_db.dart';
import 'package:firebase_practice/utils/utils.dart';
import 'package:firebase_practice/widgets/custom_text_field.dart';
import 'package:firebase_practice/widgets/round_button.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final postController = TextEditingController();
  final RealtimeDb _realtimeDb = RealtimeDb();
  bool isLoading = false;

  void postData() async {
    if (postController.text.isEmpty) {
      Utils().toastMessage("Please enter a post.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await _realtimeDb.writePost(postController.text.trim());
      setState(() {
        isLoading = false;
        postController.clear();
      });
      Utils().toastMessage("Post added to Realtime Database!");
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
        title: const Text("Add Realtime Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Icon(
              Icons.cloud_upload_outlined,
              size: 80,
              color: Colors.black87,
            ),
            const SizedBox(height: 30),
            CustomTextField(
              controller: postController,
              hintText: "What's on your mind?",
              prefixIcon: Icons.post_add,
              maxLines: 4,
            ),
            const SizedBox(height: 40),
            RoundButton(
              title: "Publish Post",
              onTap: postData,
              loading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
