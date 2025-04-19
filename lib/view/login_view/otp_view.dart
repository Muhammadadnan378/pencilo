import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../controller/login_controller.dart';

class OTPView extends StatelessWidget {
  final String verificationId;
  const OTPView({super.key, required this.verificationId});

  @override
  Widget build(BuildContext context) {
    final _otpController = TextEditingController();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Enter OTP"),
            SizedBox(height: 20),
            TextField(
              controller: _otpController,
              decoration: InputDecoration(hintText: "Enter OTP"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String otp = _otpController.text.trim();
                if (otp.isNotEmpty) {
                  // Create a PhoneAuthCredential using the verificationId and OTP
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: verificationId,
                    smsCode: otp,
                  );

                  // Call the signInWithCredential method
                  // await Get.find<LoginController>().signInWithCredential(credential);
                } else {
                  Get.snackbar('Error', 'Please enter the OTP');
                }
              },
              child: Text("Verify OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
