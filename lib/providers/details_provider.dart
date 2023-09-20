import 'package:flutter/material.dart';
import 'package:movie/network/api.dart';

import '../model/credits.dart';
import '../model/details.dart';
import '../model/results.dart';

class DetailsProvider extends ChangeNotifier {
  late Details _details;
  late List<Genre> _genres;
  bool _loading = true;

  List<Cast> _casts = [];
  List<Result> _recomList = [];

  bool get loading => _loading;
  List<Genre> get genres => _genres;
  Details get details => _details;

  List<Cast> get casts => _casts;
  List<Result> get recomList => _recomList;

  callDetailApi(int id) async {
    _loading = true;
    notifyListeners();
    _details = await getMovieDetailsWithId(id);
    _genres = _details.genres;
    _loading = false;
    notifyListeners();

    _loadAdditionalDetails();
  }

  _loadAdditionalDetails() {
    updateCasts(_details.id);
    updateRecomList(_details.id);
    notifyListeners();
  }

  String getDuration() {
    double totalMins = _details.runtime * 1.0;

    double totalHrs = totalMins / 60;
    List list = totalHrs.toStringAsFixed(2).split('.');
    double mins = (double.parse("0.${list[1]}")) * 60;
    return "${list[0]} hr ${mins.toStringAsFixed(0)} mins";
  }

  updateCasts(int id) async {
    List<Cast> allCasts = await getCasts(id);
    if (allCasts.length > 20) {
      for (int i = 0; i < 20; i++) {
        _casts.add(allCasts[i]);
        notifyListeners();
      }
    } else {
      _casts = allCasts;
      notifyListeners();
    }
  }

  updateRecomList(int id) async {
    _recomList = await getMovieRecommendations(id);
    debugPrint("Recommend list >>>> ${_recomList.toString()}");
    notifyListeners();
  }

  disposeDetails() {
    _genres.clear();
    _casts.clear();
    _recomList.clear();
  }
}
