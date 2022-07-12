
class ClaimRewardModel {
  ClaimRewardModel({
    this.status,
    this.balance,
    this.code,
    this.pointsSpent,
    this.message,
  });

  final String? status;
  final int? balance;
  final String? code;
  final int? pointsSpent;
  final String? message;

  factory ClaimRewardModel.fromJson(Map<String, dynamic> json) => ClaimRewardModel(
    status: json["status"],
    balance: json["balance"],
    code: json["code"],
    pointsSpent: json["points_spent"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "balance": balance,
    "code": code,
    "points_spent": pointsSpent,
    "message": message,
  };
}
