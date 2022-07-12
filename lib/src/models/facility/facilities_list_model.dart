
class FacilitiesListModel {
  FacilitiesListModel({
    this.results,
  });

  final List<Result>? results;

  factory FacilitiesListModel.fromJson(Map<String, dynamic> json) => FacilitiesListModel(
    results: json["results"] == null ? null : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "results": results == null ? null : List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}

class Result {
  Result({
    this.id,
    this.title,
    this.description,
    this.direction,
    this.featuredImg,
    this.featuredIcon,
    this.floor,
    this.floorUnit,
    this.floorName,
  });

  final String? id;
  final String? title;
  final String? description;
  final String? direction;
  final String? featuredImg;
  final String? featuredIcon;
  final String? floor;
  final String? floorUnit;
  final String? floorName;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    direction: json["direction"],
    featuredImg: json["featured_img"],
    featuredIcon: json["featured_icon"],
    floor: json["floor"],
    floorUnit: json["floor_unit"],
    floorName: json["floor_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "direction": direction,
    "featured_img": featuredImg,
    "featured_icon": featuredIcon,
    "floor": floor,
    "floor_unit": floorUnit,
    "floor_name": floorName,
  };
}
