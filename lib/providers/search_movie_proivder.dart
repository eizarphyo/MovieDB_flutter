import 'package:flutter/material.dart';
import 'package:movie/model/overall_response.dart';

import '../model/results.dart';
import '../network/api.dart';

class SearchProvider extends ChangeNotifier {
  OverallResponse? _response;
  List<Result> _results = [];
  String _name = '';
  bool _isLoading = false;
  bool _showSearch = false;

  bool get isLoading => _isLoading;

  // GETTERS
  OverallResponse? get response => _response;
  List<Result> get results => _results;
  String get name => _name;
  bool get showSearch => _showSearch;

  callApi(String name, int page) async {
    _name = name;
    _isLoading = true;
    notifyListeners();
    _response = await searchMovie(name, page);
    if (response != null) {
      _results = _response!.results;
    }
    _isLoading = false;
    notifyListeners();
  }

  showSearchBar() {
    _showSearch = true;
    notifyListeners();
  }

  closeSearchBar() {
    _showSearch = false;
    notifyListeners();
  }

  disposeResponse() {
    _response = null;
    _name = '';
    notifyListeners();
  }
}
