class PointsDetailsModel {
  PointsDetailsModel({
    this.status,
    this.register,
    this.completeprofile,
  });

  final String? status;
  final String? register;
  final String? completeprofile;

  factory PointsDetailsModel.fromJson(Map<String, dynamic> json) => PointsDetailsModel(
    status: json["status"],
    register: json["register"],
    completeprofile: json["completeprofile"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "register": register,
    "completeprofile": completeprofile,
  };
}
