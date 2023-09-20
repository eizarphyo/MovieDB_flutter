import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie/pages/login.dart';
import 'package:movie/pages/register.dart';
import 'package:movie/providers/theme_mode_provider.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Welcome to MovieDB!",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Image.asset(
              "images/lazy.png",
              width: MediaQuery.of(context).size.width * 0.48,
              color: Provider.of<ThemeProvider>(context).isDarkMode
                  ? Colors.white
                  : Colors.black,
            ),
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        "New here?",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      FilledButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const RegisterPage();
                            }));
                          },
                          child: const Text("Register")),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(""),
                      Text(
                        "Or",
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Old user?",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.to(const LoginPage());
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) {
                          //   return const LoginPage();
                          // }));
                        },
                        child: const Text(
                          "Log-in",
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
