class DirectoryFloorModel {
  DirectoryFloorModel({
    this.results,
  });

  final List<FloorResult>? results;

  factory DirectoryFloorModel.fromJson(Map<String, dynamic> json) => DirectoryFloorModel(
    results: json["results"] == null ? null : List<FloorResult>.from(json["results"].map((x) => FloorResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "results": results == null ? null : List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}

class FloorResult {
  FloorResult({
    this.floorId,
    this.floorName,
    this.floorUnit,
  });

  final String? floorId;
  final String? floorName;
  final String? floorUnit;

  factory FloorResult.fromJson(Map<String, dynamic> json) => FloorResult(
    floorId: json["floor_id"],
    floorName: json["floor_name"],
    floorUnit: json["floor_unit"],
  );

  Map<String, dynamic> toJson() => {
    "floor_id": floorId,
    "floor_name": floorName,
    "floor_unit": floorUnit,
  };
}
