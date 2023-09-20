import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailUnverifiedAlert extends StatefulWidget {
  const EmailUnverifiedAlert({super.key});

  @override
  State<EmailUnverifiedAlert> createState() => _EmailUnverifiedAlertState();
}

class _EmailUnverifiedAlertState extends State<EmailUnverifiedAlert> {
  _sendVerificationMail() async {
    await FirebaseAuth.instance.currentUser!.sendEmailVerification().then((_) {
      showDialog(
          context: context,
          builder: (context) {
            return const VerificationMailSentAlert();
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Email not verified",
      ),
      content: const Text("You need to verify your email first."),
      actions: [
        TextButton(
            onPressed: () async {
              Get.back();
              _sendVerificationMail();
            },
            child: const Text("Verify")),
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("OK")),
      ],
    );
  }
}

//--------------
class VerificationMailSentAlert extends StatelessWidget {
  const VerificationMailSentAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Check your inbox!",
      ),
      content: const Text(
          "We've sent a verification mail to your email address.\n\nPlease check your email."),
      actions: [
        TextButton(
            onPressed: () {
              FirebaseAuth.instance.currentUser!.reload();
              Navigator.pop(context);
            },
            child: const Text("OK")),
      ],
    );
  }
}
