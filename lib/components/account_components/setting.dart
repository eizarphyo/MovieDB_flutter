import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie/components/dialogs/change_password_dialogs.dart';
import 'package:movie/components/dialogs/delete_account_dialog.dart';
import 'package:movie/providers/theme_mode_provider.dart';
import 'package:provider/provider.dart';

import '../dialogs/email_unverified_dialogs.dart';

class SettingComponent extends StatefulWidget {
  const SettingComponent({super.key});

  @override
  State<SettingComponent> createState() => _SettingComponentState();
}

class _SettingComponentState extends State<SettingComponent> {
  // SEGMENTED BUTTON LIST
  final List<ButtonSegment<ThemeMode>> _buttonSegments =
      const <ButtonSegment<ThemeMode>>[
    ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode)),
    ButtonSegment(
        value: ThemeMode.system, icon: Icon(Icons.phone_android_rounded)),
    ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode)),
  ];

  bool _isEmailVerified() {
    return FirebaseAuth.instance.currentUser!.emailVerified;
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    ThemeMode selectedTheme = themeProvider.themeMode;

    return Column(
      children: [
        // BACK BUTTON
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
        Text(
          "Account",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        // VERIFY EMAIL
        _isEmailVerified()
            ? Container()
            : ListTile(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const EmailUnverifiedAlert();
                      });
                },
                title: Text(
                  "Verify Email",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                trailing: const Icon(
                  Icons.mark_email_unread_outlined,
                  size: 20,
                ),
              ),
        // ListTile(
        //   onTap: () {
        //     FirebaseAuth.instance.currentUser!.reload();
        //     if (_isEmailVerified()) {
        //     } else {
        //       _showAlertDialog(context);
        //     }
        //   },
        //   title: Text(
        //     "Change Email",
        //     style: Theme.of(context).textTheme.titleSmall,
        //   ),
        //   trailing: IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.swap_horiz),
        //   ),
        // ),
        ListTile(
          onTap: () {
            FirebaseAuth.instance.currentUser!.reload();
            if (_isEmailVerified()) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const ChangePasswordDialog();
                  });
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const EmailUnverifiedAlert();
                  });
            }
          },
          title: Text(
            "Change password",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          trailing: const Icon(Icons.refresh_rounded),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Text(
            "Theme",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Default theme ",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SegmentedButton(
              showSelectedIcon: false,
              style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity(vertical: -1),
              ),
              segments: _buttonSegments,
              selected: {selectedTheme},
              onSelectionChanged: (newSelecteion) {
                setState(() {
                  selectedTheme = newSelecteion.first;
                });
                themeProvider.setThemeMode(selectedTheme);
              },
            ),
          ],
        ),
        const Divider(),
        ListTile(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return const DeleteAccountAlert();
                });
          },
          title: const Text(
            "Delete Account",
            style: TextStyle(
                color: Colors.red, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          // trailing: Icon(Icons.dele),
        ),
      ],
    );
  }
}
