import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = FirebaseAuth.instance;
  final _passCtrl = TextEditingController();
  final _bdCtrl = TextEditingController();

  late DateTime _birthday;

  bool _readOnly = true;

  @override
  void initState() {
    super.initState();
  }

  _getDateTime() async {
    setState(() {
      // _bdError = false;
    });
    final now = DateTime.now();
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1990),
      lastDate: now,
    );
    if (selectedDate != null && !selectedDate.isAtSameMomentAs(now)) {
      debugPrint(">>>> ${!selectedDate.isAtSameMomentAs(now)}");

      setState(() {
        _birthday = selectedDate;
        _bdCtrl.text = DateFormat.yMMMMd().format(_birthday);
      });
    } else {
      setState(() {
        _bdCtrl.clear();
        // _bdError = true;
        // _bdErrorMsg = "Please enter your birthday";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.25,
              padding: const EdgeInsets.only(top: 20),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30), bottom: Radius.circular(3))),
              child: Column(
                children: [
                  // PROFILE IMAGE
                  Container(
                    padding: _auth.currentUser!.photoURL == null
                        ? const EdgeInsets.all(8)
                        : null,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      border: _auth.currentUser!.photoURL == null
                          ? Border.all(
                              width: 3,
                              color: Colors.grey.shade500,
                            )
                          : null,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: _auth.currentUser!.photoURL == null
                          ? Image.asset("images/user.png",
                              color: Colors.grey,
                              width: MediaQuery.of(context).size.width * 0.28,
                              height: MediaQuery.of(context).size.width * 0.28,
                              fit: BoxFit.cover)
                          : Image.network("_auth.currentUser!.photoURL"),
                    ),
                  ),
                  // USERNAME
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: Text(
                      _auth.currentUser!.displayName!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  // const Divider(
                  //   color: Colors.grey,
                  // ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.55,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(3), bottom: Radius.circular(30))),
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.07),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: _auth.currentUser!.email,
                      suffixIcon: _auth.currentUser!.emailVerified
                          ? null
                          : const Tooltip(
                              message: "email hasn't verified",
                              child: Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.amber,
                                size: 20,
                              ),
                            ),
                    ),
                  ),
                  _auth.currentUser!.emailVerified
                      ? Container()
                      : Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () async {
                              await _auth.currentUser!.sendEmailVerification();
                            },
                            child: const Text("Send Verificaiton Mail"),
                          ),
                        ),
                  TextField(
                    controller: _passCtrl,
                    readOnly: _readOnly,
                    decoration: InputDecoration(
                        hintText: "Birthday",
                        suffixIcon: IconButton(
                            onPressed: _getDateTime,
                            icon: Icon(Icons.calendar_month_rounded))),
                  ),
                  TextField(
                    controller: _passCtrl,
                    readOnly: _readOnly,
                    decoration: InputDecoration(
                        hintText: _auth.currentUser!.phoneNumber == ""
                            ? "Phone number"
                            : _auth.currentUser!.phoneNumber),
                  ),
                  TextField(
                    controller: _passCtrl,
                    readOnly: _readOnly,
                    decoration: InputDecoration(hintText: "enter password"),
                  ),
                  ElevatedButton(onPressed: () {}, child: const Text("Update")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
