import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie/controller/firebase_auth_exception_handler.dart';
import 'package:movie/controller/firebaseauth_controller.dart';
import 'package:movie/pages/login.dart';
import 'package:movie/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../providers/theme_mode_provider.dart';
import 'home.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final FirebaseAuthController _authCtrl = FirebaseAuthController();
  bool _obscureText = true;

  final RxBool _emailErr = false.obs;
  String? _emailErrMsg;

  final RxBool _passErr = false.obs;
  String? _passErrMsg;

  final RxBool _loading = false.obs;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  _register() async {
    if (_emailCtrl.text == "") {
      _emailErr.value = true;
      _emailErrMsg = "Email required";
      return;
    } else if (_passwordCtrl.text == "") {
      _passErr.value = true;
      _passErrMsg = "Must provide password";
      return;
    }

    _loading.value = true;

    AuthStatus status =
        await _authCtrl.register(_emailCtrl.text, _passwordCtrl.text);

    if (status == AuthStatus.success) {
      Get.offAll(const HomePage());
    } else if (status == AuthStatus.weakPassword) {
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
                    Text(
                      "Register an account",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.23,
                      margin: const EdgeInsets.fromLTRB(30, 30, 30, 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextField(
                            controller: _emailCtrl,
                            onTap: () {
                              _emailErr.value = false;
                            },
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.email_rounded),
                              label: Text(
                                "Email",
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              errorText: _emailErr.value ? _emailErrMsg : null,
                            ),
                          ),
                          TextField(
                            controller: _passwordCtrl,
                            obscureText: _obscureText,
                            onSubmitted: (value) {
                              _register();
                              Provider.of<UserProvider>(context, listen: false)
                                      .username =
                                  FirebaseAuth
                                      .instance.currentUser!.displayName!;
                            },
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
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: FilledButton(
                        onPressed: () {
                          _register();
                          Provider.of<UserProvider>(context, listen: false)
                                  .username =
                              FirebaseAuth.instance.currentUser!.displayName!;
                        },
                        child: const Text("Register"),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(const LoginPage());
                      },
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(color: Colors.grey[500])),
                        TextSpan(
                            text: "Login",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor)),
                      ])),
                    )
                  ],
                ),
              ),
      )),
    );
  }
}
