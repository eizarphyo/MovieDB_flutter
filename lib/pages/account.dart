import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:movie/components/account_components/account_compon.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie/providers/loading_provider.dart';
import 'package:movie/providers/user_provider.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _auth = FirebaseAuth.instance;

  bool isEditOn = false;
  XFile? xfileImage;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      UserProvider userProvd = Provider.of(context, listen: false);
      if (_auth.currentUser != null) {
        userProvd.username = _auth.currentUser!.displayName!;
      }
    });
  }

  _pickImage() async {
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? xfileImage =
          await picker.pickImage(source: ImageSource.gallery);
      if (xfileImage != null) {
        imageFile = File(xfileImage.path);
        setState(() {});
        debugPrint("------------------");
        debugPrint(xfileImage.path);
      }
    } catch (e) {
      print(e);
    }
  }

  _saveImage() async {
    if (imageFile != null) {
      // _loading = true;

      final uid = _auth.currentUser!.uid;
      debugPrint("$imageFile");

      // create a reference of the location of firebase,
      // store image path in Firebase storage
      // get download url and full path
      final storageRef =
          FirebaseStorage.instance.ref().child(uid).child('images/profile.png');

      await storageRef.putFile(imageFile!);

      final downloadUrl = await storageRef.getDownloadURL();
      final fullpath = storageRef.fullPath;

      // create a reference to firebase cloud storage,
      // add download url and full path
      final ref = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('images')
          .doc('profile');

      await ref.set({
        "downloadUrl": downloadUrl,
        "fullpath": fullpath,
        "time": Timestamp.now()
      });

      _auth.currentUser!.updatePhotoURL(downloadUrl);
      debugPrint(">>>>>>>> downloadUrl || $downloadUrl");
      debugPrint(
          ">>>>>>>> set profile path. || ${_auth.currentUser!.photoURL}");
    }
  }

  _file() {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoadingProvider loadingProvd = Provider.of<LoadingProvider>(context);

    return Center(
      child: loadingProvd.loading
          ? const CircularProgressIndicator()
          : SingleChildScrollView(
              child: Column(
                children: [
                  // UPPER HALF
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 1,
                        height: MediaQuery.of(context).size.height * 0.22,
                        padding: const EdgeInsets.only(top: 20),
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(30),
                                bottom: Radius.circular(3))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // PROFILE IMAGE
                            GestureDetector(
                              onTap: () {
                                if (isEditOn) {
                                  _pickImage();
                                }
                              },
                              child: Container(
                                padding: _auth.currentUser!.photoURL == null &&
                                        imageFile == null
                                    ? const EdgeInsets.all(8)
                                    : null,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceVariant,
                                  border: _auth.currentUser!.photoURL == null &&
                                          imageFile == null
                                      ? Border.all(
                                          width: 3,
                                          color: Colors.grey.shade500,
                                        )
                                      : null,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: imageFile != null
                                      ? Image.file(
                                          imageFile!,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          fit: BoxFit.cover,
                                        )
                                      : _auth.currentUser!.photoURL == null &&
                                              imageFile == null
                                          ? Image.asset("images/user.png",
                                              color: Colors.grey,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.18,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.18,
                                              fit: BoxFit.cover)
                                          : Image(
                                              image: NetworkToFileImage(
                                                url: _auth
                                                    .currentUser!.photoURL!,
                                                file: File(
                                                    "${Directory.current.path}profile.png"),
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              fit: BoxFit.cover,
                                            ),
                                ),
                              ),
                            ),
                            // USERNAME
                            Text(
                              Provider.of<UserProvider>(context).username,
                              // _auth.currentUser!.displayName!,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      // EDIT ICON
                      Positioned(
                        top: -5,
                        right: 15,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              isEditOn = !isEditOn;
                            });

                            if (isEditOn) {
                              _pickImage();
                            } else {
                              _saveImage();
                            }
                          },
                          icon: Icon(
                            isEditOn ? Icons.check : Icons.edit,
                            size: 25,
                          ),
                        ),
                      )
                    ],
                  ),
                  // BOTTOM HALF
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 0.58,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(3),
                            bottom: Radius.circular(20))),
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.07),
                    child: const AcccountComponent(),
                  ),
                ],
              ),
            ),
    );
  }
}
