import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _auth = FirebaseAuth.instance;

  final _usernameCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameCtrl.text = _auth.currentUser!.displayName!;
  }

  _updateUsername(UserProvider provider) async {
    await _auth.currentUser!.updateDisplayName(_usernameCtrl.text);

    _auth.currentUser!.reload();
    provider.username = _auth.currentUser!.displayName!;
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProv = Provider.of<UserProvider>(context);
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // BACK BUTTON
        SizedBox(
          width: MediaQuery.of(context).size.width * 1,
          child: IconButton(
              alignment: Alignment.topLeft,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 17,
              )),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            TextField(
              readOnly: true,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  hintText: _auth.currentUser!.email,
                  suffixIcon: _auth.currentUser!.emailVerified
                      ? null
                      : Tooltip(
                          message: "email hasn't verified",
                          child: Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.amber.shade700,
                            size: 20,
                          ),
                        ),
                  border: InputBorder.none),
            ),
            // USERNAME
            Container(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 30),
              child: TextField(
                controller: _usernameCtrl,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  label: Text("Username"),
                ),
              ),
            ),
            // SAVE BUTTON
            ElevatedButton(
                onPressed: () {
                  _updateUsername(userProv);
                },
                child: const Text("Save")),
          ],
        ),
      ],
    );
  }
}
