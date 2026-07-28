import 'package:firebase_practice/services/auth_service.dart';
import 'package:firebase_practice/utils/utils.dart';
import 'package:firebase_practice/widgets/custom_text_field.dart';
import 'package:firebase_practice/widgets/round_button.dart';
import 'package:flutter/material.dart';

class ForgotpassScreen extends StatefulWidget {
  const ForgotpassScreen({super.key});

  @override
  State<ForgotpassScreen> createState() => _ForgotpassScreenState();
}

class _ForgotpassScreenState extends State<ForgotpassScreen> {
  final emailController = TextEditingController();
  final AuthService _authService = AuthService();
  bool isLoading = false;

  void resetPassword() async {
    if (emailController.text.isEmpty) {
      Utils().toastMessage("Please enter your email");
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      await _authService.resetPassword(emailController.text.trim());
      setState(() {
        isLoading = false;
      });
      Utils().toastMessage("Password reset email sent! Check your inbox.");
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
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_reset,
              size: 80,
              color: Colors.black87,
            ),
            const SizedBox(height: 20),
            const Text(
              "Reset your password",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Enter your email and we'll send you a link to reset your password.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            CustomTextField(
              controller: emailController,
              hintText: 'Email Address',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 30),
            RoundButton(
              title: "Send Link",
              onTap: resetPassword,
              loading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
