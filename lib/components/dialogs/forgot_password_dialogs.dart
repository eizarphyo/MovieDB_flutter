import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/firebase_auth_exception_handler.dart';
import '../../controller/firebaseauth_controller.dart';

class ResetPasswordDialog extends StatefulWidget {
  const ResetPasswordDialog({super.key});

  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  final TextEditingController _emailCtl = TextEditingController();
  final FirebaseAuthController _authCtrl = FirebaseAuthController();

  _sendPasswordResetMail() async {
    AuthStatus status = await _authCtrl.resetPassword(_emailCtl.text);
    debugPrint("------------------");
    if (status == AuthStatus.success) {
      debugPrint("PASSWORD RESET MAIL SENT -----");
      _showDialog(const PasswordResetEmailSentAlert());
    } else {
      String errMsg = AuthExceptiongHandler.sendErrorMsg(status);
      debugPrint("ERROR $errMsg");
      _showDialog(PasswordResetEmailErrorAlert(errMsg: errMsg));
    }
    _emailCtl.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Reset Password"),
      content: Wrap(
        children: [
          const Text(
              "Please enter your email. We will sent a link to reset your password."),
          TextField(
            controller: _emailCtl,
            autofocus: true,
            onChanged: (val) {
              setState(() {});
            },
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: _sendPasswordResetMail, child: const Text("Send")),
      ],
    );
  }

  @override
  void dispose() {
    _emailCtl.dispose();
    super.dispose();
  }

  _showDialog(Widget myDialog) {
    showDialog(
        context: context,
        builder: (context) {
          return myDialog;
        });
  }
}

// -------------------------------
class PasswordResetEmailSentAlert extends StatelessWidget {
  const PasswordResetEmailSentAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Check your inbox!"),
      content: const Text(
          "We've sent a password reset mail. Please check your inbox"),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: const Text("OK"))
      ],
    );
  }
}

// -------------------------------
class PasswordResetEmailErrorAlert extends StatelessWidget {
  const PasswordResetEmailErrorAlert({super.key, required this.errMsg});
  final String errMsg;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Can't send password reset email"),
      content: Text(errMsg),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("OK")),
      ],
    );
  }
}
