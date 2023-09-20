import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavProvider extends ChangeNotifier {
  List<String> _favMovies = [];
  final _firestore = FirebaseFirestore.instance;

  List<String> get favMovies => _favMovies;

  updateFavMovieList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favM = prefs.getStringList('favMovies');
    if (favM == null) {
      getCloudDataAndUpdatePrefs();
    } else {
      _favMovies = favM;
    }
  }

  bool isFav(id) {
    if (_favMovies.contains('$id')) {
      return true;
    } else {
      return false;
    }
  }

  addOrRemoveMovie(id) {
    if (_favMovies.contains('$id')) {
      removeMovieFromPrefs(id);
      removeMovieFromCloud(id);
    } else {
      addMovieToPrefs(id);
      addMovieToCloud(id);
    }
    notifyListeners();
  }

  addMovieToPrefs(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!_favMovies.contains('$id')) {
      _favMovies.add('$id');
      bool isAdded = await prefs.setStringList('favMovies', _favMovies);
      notifyListeners();
      debugPrint("added to shared prefs >> $isAdded");
    }
  }

  removeMovieFromPrefs(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_favMovies.contains('$id')) {
      _favMovies.remove('$id');
      bool isRemoved = await prefs.setStringList('favMovies', _favMovies);
      debugPrint("removed from shared prefs >> $isRemoved");
      notifyListeners();
    }
  }

  addMovieToCloud(int id) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref =
        _firestore.collection('users').doc(uid).collection("fav").doc('$id');

    ref.set({
      'type': 'movie',
      'id': id,
      'time': DateTime.now(),
    });
    debugPrint("Added to cloud");
  }

  removeMovieFromCloud(int id) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref =
        _firestore.collection('users').doc(uid).collection("fav").doc('$id');

    ref.delete();
    debugPrint("Deleted from cloud");
  }

  getCloudDataAndUpdatePrefs() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final collRef = _firestore.collection("users").doc(uid).collection("fav");

    final collection = await collRef.get();
    final docs = collection.docs;
    docs.forEach((doc) {
      final data = doc.data();

      final id = data['id'];
      debugPrint("id from cloud >> " '$id');
      addMovieToPrefs(id);
    });
  }
}
