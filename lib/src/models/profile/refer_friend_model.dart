
class ReferralInfoModel {
  ReferralInfoModel({
    this.status,
    this.message,
    this.referer,
    this.referee,
  });

  final String? status;
  final String? message;
  final String? referer;
  final String? referee;

  factory ReferralInfoModel.fromJson(Map<String, dynamic> json) => ReferralInfoModel(
    status: json["status"],
    message: json["message"],
    referer: json["referer"],
    referee: json["referee"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "referer": referer,
    "referee": referee,
  };
}
