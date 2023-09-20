import 'dart:convert';

import 'package:movie/model/results.dart';

OverallResponse overallResponseFromJson(String str) =>
    OverallResponse.fromJson(json.decode(str));

String overallResponseToJson(OverallResponse data) =>
    json.encode(data.toJson());

class OverallResponse {
  int page;
  List<Result> results;
  int totalPages;
  int totalResults;

  OverallResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory OverallResponse.fromJson(Map<String, dynamic> json) =>
      OverallResponse(
        page: json["page"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
      };
}
