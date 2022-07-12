
class DirectoryListModel {
  DirectoryListModel({
    this.results,
  });

  final List<DirectoryResult>? results;

  factory DirectoryListModel.fromJson(Map<String, dynamic> json) => DirectoryListModel(
    results: json["results"] == null ? null : List<DirectoryResult>.from(json["results"].map((x) => DirectoryResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "results": results == null ? null : List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}

class DirectoryResult {
  DirectoryResult({
    this.id,
    this.label,
    this.siteUrl,
    this.featuredImg,
    this.categories,
    this.floor,
    this.floorTitle,
    this.unitNo,
    this.keyword,
    this.floorUnit,
  });

  final String? id;
  final String? label;
  final String? siteUrl;
  final String? featuredImg;
  final String? categories;
  final String? floor;
  final String? floorTitle;
  final String? unitNo;
  final String? keyword;
  final String? floorUnit;

  factory DirectoryResult.fromJson(Map<String, dynamic> json) => DirectoryResult(
    id: json["id"],
    label: json["title"],
    siteUrl: json["siteurl"],
    featuredImg: json["featured_img"],
    categories: json["categories"],
    floor: json["floor"],
    floorTitle: json["floor_title"],
    unitNo: json["unit_no"],
    keyword: json["keyword"],
    floorUnit: json["floor_unit"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": label,
    "siteurl": siteUrl,
    "featured_img": featuredImg,
    "categories": categories,
    "floor": floor,
    "floor_title": floorTitle,
    "unit_no": unitNo,
    "keyword": keyword,
    "floor_unit": floorUnit,
  };
}
