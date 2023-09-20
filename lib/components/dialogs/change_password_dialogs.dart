import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie/components/loader.dart';
import 'package:movie/controller/firebase_auth_exception_handler.dart';
import 'package:movie/controller/firebaseauth_controller.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final FirebaseAuthController _authCtl = FirebaseAuthController();

  final TextEditingController _currentPass = TextEditingController();
  final TextEditingController _newPass = TextEditingController();
  final TextEditingController _confirmNewPass = TextEditingController();

  final RxBool _currentPassErr = false.obs;

  String _currentPassErrMsg = '';

  final RxBool _newPassErr = false.obs;
  String _newPassErrMsg = '';

  RxBool loading = false.obs;

  updatePassword() async {
    if (_currentPass.text == "") {
      _currentPassErr.value = true;
      _currentPassErrMsg = "Must provide current password";
      return;
    } else if (_newPass.text == "" || _confirmNewPass.text == "") {
      _newPassErr.value = true;
      _newPassErrMsg = "Required new password";
      return;
    }

    if (_newPass.text != _confirmNewPass.text) {
      _newPassErr.value = true;
      _newPassErrMsg = "Passwords don't match";
      loading.value = false;
      return;
    }

    loading.value = true;
    AuthStatus status =
        await _authCtl.changePassword(_currentPass.text, _newPass.text);
    loading.value = false;

    if (status == AuthStatus.success) {
      _showDialog(const PasswordUpdateSuccessfulAlert());
    } else if (status == AuthStatus.wrongPassword) {
      _currentPassErr.value = true;
      _currentPassErrMsg = AuthExceptiongHandler.sendErrorMsg(status);
    } else {
      _newPassErr.value = true;
      _newPassErrMsg = AuthExceptiongHandler.sendErrorMsg(status);
    }
  }

  @override
  void dispose() {
    _currentPass.dispose();
    _newPass.dispose();
    _confirmNewPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Change Password"),
      content: Container(
        constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width * 0.75,
            maxHeight: MediaQuery.of(context).size.height * 0.33),
        child: Obx(
          () => loading.value
              ? const Loader()
              : Wrap(
                  children: [
                    Obx(
                      () => TextField(
                        obscureText: true,
                        controller: _currentPass,
                        onTap: () {
                          _currentPassErr.value = false;
                        },
                        decoration: InputDecoration(
                            label: Text(
                              "Current password",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            errorText: _currentPassErr.value
                                ? _currentPassErrMsg
                                : null),
                      ),
                    ),
                    Obx(
                      () => TextField(
                        obscureText: true,
                        controller: _newPass,
                        onTap: () {
                          _newPassErr.value = false;
                        },
                        decoration: InputDecoration(
                            label: Text(
                              "New password",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            errorText:
                                _newPassErr.value ? _newPassErrMsg : null),
                      ),
                    ),
                    Obx(
                      () => TextField(
                        obscureText: true,
                        controller: _confirmNewPass,
                        onTap: () {
                          _newPassErr.value = false;
                        },
                        decoration: InputDecoration(
                            label: Text(
                              "Confirm password",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            errorText:
                                _newPassErr.value ? _newPassErrMsg : null),
                      ),
                    ),
                  ],
                ),
        ),
      ),
      actions: [
        Obx(
          () => TextButton(
              onPressed: loading.value ? null : updatePassword,
              child: const Text("Update")),
        ),
      ],
    );
  }

  _showDialog(Widget myDialog) {
    showDialog(
        context: context,
        builder: (context) {
          return myDialog;
        });
  }
}

// ------------------
class PasswordUpdateSuccessfulAlert extends StatelessWidget {
  const PasswordUpdateSuccessfulAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Success!"),
      content: const Text("Successfully updated password."),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
              Get.back();
              // Navigator.pop(context);
              // Navigator.pop(context);
            },
            child: const Text("OK"))
      ],
    );
  }
}
