
class FacilityFloorModel {
  FacilityFloorModel({
    this.results,
  });

  final List<Result>? results;

  factory FacilityFloorModel.fromJson(Map<String, dynamic> json) => FacilityFloorModel(
    results: json["results"] == null ? null : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "results": results == null ? null : List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}

class Result {
  Result({
    this.floorId,
    this.floorName,
  });

  final String? floorId;
  final String? floorName;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    floorId: json["floor_id"],
    floorName: json["floor_name"],
  );

  Map<String, dynamic> toJson() => {
    "floor_id": floorId,
    "floor_name": floorName,
  };
}
