import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie/components/account_components/edit_profile.dart';
import 'package:movie/components/account_components/setting.dart';
import 'package:movie/components/account_components/sliders.dart';
import 'package:movie/pages/login.dart';

class AcccountComponent extends StatelessWidget {
  const AcccountComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final navigatorKey = GlobalKey<NavigatorState>();

    return Column(
      children: [
        Expanded(
            child: Navigator(
          key: navigatorKey,
          onGenerateRoute: (route) => MaterialPageRoute(
              settings: route,
              builder: (context) {
                return Column(
                  children: [
                    // EDIT PROFILE
                    ListTile(
                      title: const Text(
                        "Profile",
                      ),
                      onTap: () {
                        Navigator.push(context,
                            SlideRightRoute(widget: const EditProfile()));
                      },
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 15,
                      ),
                    ),
                    // SETTING
                    ListTile(
                      title: const Text("Settings"),
                      onTap: () {
                        Navigator.push(context,
                            SlideRightRoute(widget: const SettingComponent()));
                      },
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 15,
                      ),
                    ),
                    // LOGOUT
                    ListTile(
                      title: const Text("Logout"),
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        Get.offAll(const LoginPage());
                      },
                      trailing: const Icon(
                        Icons.logout_rounded,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ],
                );
              }),
        )),
      ],
    );
  }
}
