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
    setState(() {
      isLoading = true;
    });
    try {
      await _authService.resetPassword(emailController.text.trim());
      setState(() {
        isLoading = false;
      });
      Utils().toastMessage("Password reset email sent!");
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
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomTextField(
                controller: emailController,
                hintText: 'Enter your email',
                obscureText: false,
              ),
            ),
            RoundButton(
              title: "Reset Password",
              onTap: resetPassword,
              loading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
