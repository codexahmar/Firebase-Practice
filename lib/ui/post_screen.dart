import 'package:firebase_practice/services/realtime_db.dart';
import 'package:firebase_practice/utils/utils.dart';
import 'package:firebase_practice/widgets/custom_text_field.dart';
import 'package:firebase_practice/widgets/round_button.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final postController = TextEditingController();
  RealtimeDb _realtimeDb = RealtimeDb();
  bool isLoading = false;

  void postData() async {
    try {
      setState(() {
        isLoading = true;
      });

      if (postController.text.isEmpty) {
        Utils().toastMessage("Please enter a post.");
        setState(() {
          isLoading = false;
        });
        return;
      }
      await _realtimeDb.writePost(postController.text.toString());
      setState(() {
        isLoading = false;
      });
      Utils().toastMessage("Post added successfully!");
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
        title: Text("Post Screen", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              controller: postController,
              hintText: "Enter your post here...",
              maxLines: 5,
            ),
            Spacer(),
            RoundButton(title: "Post", onTap: postData, loading: isLoading),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
