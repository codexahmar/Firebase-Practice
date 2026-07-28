import 'package:firebase_practice/services/auth_service.dart';
import 'package:firebase_practice/ui/realtimeDb/home_screen.dart';
import 'package:firebase_practice/utils/utils.dart';
import 'package:firebase_practice/widgets/custom_text_field.dart';
import 'package:firebase_practice/widgets/round_button.dart';
import 'package:flutter/material.dart';

class LoginWithNumber extends StatefulWidget {
  const LoginWithNumber({super.key});

  @override
  State<LoginWithNumber> createState() => _LoginWithNumberState();
}

class _LoginWithNumberState extends State<LoginWithNumber> {
  final numberController = TextEditingController();
  bool isLoading = false;
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login with Phone", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              keyboardType: TextInputType.phone,
              controller: numberController,
              hintText: "+1 234 567 890",
              prefixIcon: Icons.phone_android_outlined,
            ),
            const SizedBox(height: 40),
            RoundButton(
              title: "Send Verification Code",
              loading: isLoading,
              onTap: () async {
                if (numberController.text.isEmpty) {
                  Utils().toastMessage("Please enter phone number");
                  return;
                }

                setState(() => isLoading = true);

                try {
                  await _authService.loginWithPhoneNumber(
                    phoneNumber: numberController.text.trim(),
                    onCodeSent: (verificationId, resendToken) {
                      setState(() => isLoading = false);
                      // Navigate to verification screen with the ID
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerifyPhoneNumber(
                            verificationId: verificationId,
                          ),
                        ),
                      );
                    },
                    onVerificationFailed: (e) {
                      setState(() => isLoading = false);
                      Utils().toastMessage(e.message ?? "Verification failed");
                    },
                    onTimeout: (verificationId) {
                      setState(() => isLoading = false);
                    },
                  );
                } catch (e) {
                  setState(() => isLoading = false);
                  Utils().toastMessage(e.toString());
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class VerifyPhoneNumber extends StatefulWidget {
  final String verificationId;
  const VerifyPhoneNumber({super.key, required this.verificationId});

  @override
  State<VerifyPhoneNumber> createState() => _VerifyPhoneNumberState();
}

class _VerifyPhoneNumberState extends State<VerifyPhoneNumber> {
  final verifyController = TextEditingController();
  bool isLoading = false;
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    verifyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify OTP", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              controller: verifyController,
              hintText: "6-digit code",
              prefixIcon: Icons.lock_clock_outlined,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 40),
            RoundButton(
              title: "Verify & Login",
              loading: isLoading,
              onTap: () async {
                if (verifyController.text.isEmpty) {
                  Utils().toastMessage("Please enter the code");
                  return;
                }

                setState(() => isLoading = true);

                try {
                  await _authService.verifyOTP(
                    verificationId: widget.verificationId,
                    smsCode: verifyController.text.trim(),
                  );
                  setState(() => isLoading = false);
                  Utils().toastMessage("Login Successful!");
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                      (route) => false,
                    );
                  }
                } catch (e) {
                  setState(() => isLoading = false);
                  Utils().toastMessage(e.toString());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
