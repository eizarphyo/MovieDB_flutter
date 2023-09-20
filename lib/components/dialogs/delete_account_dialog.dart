import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie/providers/loading_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../pages/register.dart';

class DeleteAccountAlert extends StatefulWidget {
  const DeleteAccountAlert({super.key});

  @override
  State<DeleteAccountAlert> createState() => _DeleteAccountAlertState();
}

class _DeleteAccountAlertState extends State<DeleteAccountAlert> {
  final _firestore = FirebaseFirestore.instance;

  _deleteAccount(LoadingProvider provider) async {
    provider.loading = true;

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // delete user from firebase auth
      await FirebaseAuth.instance.currentUser!.delete().then((_) {
        _deleteUserDataFromCloudAndStorage(uid);
        Get.offAll(const RegisterPage());
      });
    } catch (e) {
      print("ERROR DELETING FIREBASE USER $e");
    } finally {
      provider.loading = false;
    }
  }

  _deleteUserDataFromCloudAndStorage(String uid) async {
    try {
      await deleteCollection(uid, 'fav');
      await deleteCollection(uid, 'images');
      debugPrint("Cloud collection deleted");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      debugPrint("Deleted From shared prefs");

      await FirebaseStorage.instance
          .ref()
          .child(uid)
          .child('images/profile.png')
          .delete()
          .then((value) => debugPrint("storage data deleted ✅"));
    } catch (err) {
      print("ERROR >>>>>>>> $err");
    }
  }

  Future<void> deleteCollection(String uid, String collName) async {
    _firestore.collection('users').doc(uid).collection(collName).get().then(
        (snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
        debugPrint("collection deleted 🔥");
      }
    }, onError: (err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    LoadingProvider loadingProvd = Provider.of<LoadingProvider>(context);

    return AlertDialog(
      title: const Text("Are you sure :("),
      content: const Text(
          "Are you sure you want to delete your account? Once you've deleted it, you cannot retrive your data."),
      actions: [
        TextButton(
            onPressed: () async {
              _deleteAccount(loadingProvd);
            },
            child: const Text("Delete")),
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("Cancle"))
      ],
    );
  }
}
