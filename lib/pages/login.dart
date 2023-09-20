import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie/components/dialogs/forgot_password_dialogs.dart';
import 'package:movie/controller/firebase_auth_exception_handler.dart';
import 'package:movie/controller/firebaseauth_controller.dart';
import 'package:movie/pages/register.dart';
import 'package:movie/providers/theme_mode_provider.dart';
import 'package:movie/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();

  final FirebaseAuthController _authCtrl = FirebaseAuthController();

  final RxBool _loading = false.obs;

  final RxBool _emailErr = false.obs;
  String? _emailErrMsg;

  final RxBool _passErr = false.obs;
  String? _passErrMsg;

  bool _obscureText = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  _login() async {
    if (_emailCtrl.text == "") {
      _emailErr.value = true;
      _emailErrMsg = "Email required";
      return;
    } else if (_passCtrl.text == "") {
      _passErr.value = true;
      _passErrMsg = "Must provide password";
      return;
    }
    _loading.value = true;

    AuthStatus status = await _authCtrl.login(_emailCtrl.text, _passCtrl.text);
    if (status == AuthStatus.success) {
      Get.offAll(const HomePage());
    } else if (status == AuthStatus.wrongPassword) {
      _passErr.value = true;
      _passErrMsg = AuthExceptiongHandler.sendErrorMsg(status);
    } else {
      _emailErr.value = true;
      _emailErrMsg = AuthExceptiongHandler.sendErrorMsg(status);
    }
    _loading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => _loading.value
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Image.asset(
                          "images/eating.png",
                          width: MediaQuery.of(context).size.width * 0.3,
                          color: Provider.of<ThemeProvider>(context).isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                        child: Text(
                          "Login to your account",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.23,
                        margin: const EdgeInsets.fromLTRB(30, 30, 30, 50),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // EMAIL FIELD
                            TextField(
                              controller: _emailCtrl,
                              onTap: () {
                                _emailErr.value = false;
                              },
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                label: Text(
                                  "Email",
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                suffixIcon: const Icon(Icons.email_rounded),
                                errorText:
                                    _emailErr.value ? _emailErrMsg : null,
                              ),
                            ),
                            // PASSWORD FIELD
                            TextField(
                              controller: _passCtrl,
                              obscureText: _obscureText,
                              onSubmitted: (value) {},
                              onTap: () {
                                _passErr.value = false;
                              },
                              decoration: InputDecoration(
                                label: Text(
                                  "Password",
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                errorText: _passErr.value ? _passErrMsg : null,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  icon: Icon(_obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                              ),
                            ),
                            // FORGOT PASSWORD
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const ResetPasswordDialog();
                                    });
                              },
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: RichText(
                                  text: TextSpan(
                                    text: "forgot password?",
                                    style: TextStyle(
                                        color: Colors.grey.shade500,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      // LOGIN BUTTON
                      FilledButton(
                        onPressed: () {
                          _login();
                          Provider.of<UserProvider>(context).username =
                              FirebaseAuth.instance.currentUser!.displayName!;
                        },
                        child: const Text(
                          "Login",
                          // style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      // REGISTER TEXTSPAN
                      GestureDetector(
                        onTap: () {
                          Get.to(const RegisterPage());
                        },
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(color: Colors.grey[500])),
                          TextSpan(
                              text: "Register",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor)),
                        ])),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
