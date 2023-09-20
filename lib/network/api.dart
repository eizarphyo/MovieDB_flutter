import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:movie/model/images.dart';
import 'package:movie/model/results.dart';
import 'dart:convert' as convert;

import '../model/credits.dart';
import '../model/details.dart';
import '../model/overall_response.dart';
import '../model/videos.dart';

// MOVIE DETAILS
Future<Details> getMovieDetailsWithId(int id) async {
  String idUrl =
      "https://api.themoviedb.org/3/movie/$id?api_key=6264e733519659a371b01afc8d0a1c9d";

  try {
    Response response = await apiCall(idUrl);
    var details = detailsFromJson(response.body);
    return details;
  } catch (e) {
    debugPrint("---------> Rethrowed error");
    rethrow;
  }
  // Response response = await apiCall(idUrl);
}

// MOVIE LISTS
Future<List<Result>> getMovieList(String movieType) async {
  String typeUrl =
      "https://api.themoviedb.org/3/movie/$movieType?api_key=6264e733519659a371b01afc8d0a1c9d&language=en-US&page=1";

  Response response = await apiCall(typeUrl);
  var jsonResponse = overallResponseFromJson(response.body);
  // debugPrint(jsonResponse.results[0].originalTitle);
  return jsonResponse.results;
}

// SEARCH
Future<OverallResponse> searchMovie(String name, int page) async {
  String searchUrl =
      "https://api.themoviedb.org/3/search/movie?query=$name&api_key=6264e733519659a371b01afc8d0a1c9d&page=$page";

  Response response = await apiCall(searchUrl);
  OverallResponse jsonResponse = overallResponseFromJson(response.body);
  debugPrint("---------------------");
  debugPrint(jsonResponse.results[0].originalTitle);
  return jsonResponse;
  // return jsonResponse.results;
}

// RECOMMENDATION
Future<List<Result>> getMovieRecommendations(int movieId) async {
  String recomUrl =
      "https://api.themoviedb.org/3/movie/$movieId/recommendations?&api_key=6264e733519659a371b01afc8d0a1c9d";

  Response response = await apiCall(recomUrl);
  var jsonResponse = overallResponseFromJson(response.body);
  debugPrint(jsonResponse.results.toString());
  return jsonResponse.results;
}

// CASTS
Future<List<Cast>> getCasts(int moiveId) async {
  String creditsUrl =
      "https://api.themoviedb.org/3/movie/$moiveId/credits?language=en-US&api_key=6264e733519659a371b01afc8d0a1c9d";

  Response response = await apiCall(creditsUrl);
  var jsonResponse = creditsFromJson(response.body);
  return jsonResponse.cast;
}

// IMAGES
Future<MovieImages> getImages(int id) async {
  final imagesUrl =
      "https://api.themoviedb.org/3/movie/${id}/images?api_key=6264e733519659a371b01afc8d0a1c9d";

  Response response = await apiCall(imagesUrl);
  MovieImages imgs = movieImagesFromJson(response.body);
  return imgs;
}

Future<List<Videos>> getVideos(int id) async {
  final videoUrl =
      "https://api.themoviedb.org/3/movie/$id/videos?&api_key=6264e733519659a371b01afc8d0a1c9d";

  Response response = await apiCall(videoUrl);
  VideoResponse videos = videoResponseFromJson(response.body);
  if (videos.results == null) {
    return [];
  } else {
    return videos.results!;
  }
}

// API CALL
Future<Response> apiCall(String apiUrl) async {
  final url = Uri.parse(apiUrl);
  var response = await http.get(url);
  if (response.statusCode == 200) {
    return response;
  } else {
    throw (">>>>>>> An error occurred : ${response.statusCode}");
  }
}

// TASTYSOFT LOGIN
Future<String> loginApi(String userid, String password) async {
  String loginUrl = "https://angular.tastysoftcloud.com/api/auth/signin";

  final url = Uri.parse(loginUrl);
  var headers = {"Content-Type": "application/json"};

  var body = {"userid": userid, "password": password};

  var bodyDecoded = convert.jsonEncode(body);

  var response = await http.post(
    url,
    headers: headers,
    body: bodyDecoded,
  );

  debugPrint("----------------");
  debugPrint("${response.statusCode}");
  debugPrint(response.body);

  if (response.statusCode == 200) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;

    return jsonResponse['token'];
  } else {
    throw (">>>>>>> An error occurred : ${response.statusCode}");
  }
}
