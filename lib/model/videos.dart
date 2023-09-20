// To parse this JSON data, do
//
//     final videoResponse = videoResponseFromJson(jsonString);

import 'dart:convert';

VideoResponse videoResponseFromJson(String str) =>
    VideoResponse.fromJson(json.decode(str));

String videoResponseToJson(VideoResponse data) => json.encode(data.toJson());

class VideoResponse {
  int? id;
  List<Videos>? results;

  VideoResponse({
    this.id,
    this.results,
  });

  factory VideoResponse.fromJson(Map<String, dynamic> json) => VideoResponse(
        id: json["id"],
        results: json["results"] == null
            ? []
            : List<Videos>.from(
                json["results"]!.map((x) => Videos.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}

class Videos {
  String? iso6391;
  String? iso31661;
  String? name;
  String? key;
  String? site;
  int? size;
  String? type;
  bool official;
  DateTime? publishedAt;
  String id;

  Videos({
    this.iso6391,
    this.iso31661,
    this.name,
    this.key,
    this.site,
    this.size,
    this.type,
    required this.official,
    this.publishedAt,
    required this.id,
  });

  factory Videos.fromJson(Map<String, dynamic> json) => Videos(
        iso6391: json["iso_639_1"],
        iso31661: json["iso_3166_1"],
        name: json["name"],
        key: json["key"],
        site: json["site"],
        size: json["size"],
        type: json["type"],
        official: json["official"],
        publishedAt: json["published_at"] == null
            ? null
            : DateTime.parse(json["published_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "iso_639_1": iso6391,
        "iso_3166_1": iso31661,
        "name": name,
        "key": key,
        "site": site,
        "size": size,
        "type": type,
        "official": official,
        "published_at": publishedAt?.toIso8601String(),
        "id": id,
      };
}
