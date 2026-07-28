import 'package:firebase_practice/widgets/custom_text_field.dart';
import 'package:firebase_practice/widgets/round_button.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatelessWidget {
  PostScreen({super.key});
  final postController = TextEditingController();

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
            RoundButton(title: "Post", onTap: () {}),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
