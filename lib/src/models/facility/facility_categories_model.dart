
class FacilityCategoriesModel {
  FacilityCategoriesModel({
    this.result,
    this.status,
  });

  final List<Result>? result;
  final String? status;

  factory FacilityCategoriesModel.fromJson(Map<String, dynamic> json) => FacilityCategoriesModel(
    result: json["result"] == null ? null : List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "result": result == null ? null : List<dynamic>.from(result!.map((x) => x.toJson())),
    "status": status,
  };
}

class Result {
  Result({
    this.id,
    this.title,
    this.featuredImg,
  });

  final String? id;
  final String? title;
  final String? featuredImg;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    title: json["title"],
    featuredImg: json["featured_img"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "featured_img": featuredImg,
  };
}
