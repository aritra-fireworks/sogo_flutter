
class RegisterResponseModel {
  RegisterResponseModel({
    this.status,
    this.message,
    this.custid,
    this.promo,
    this.memberId,
  });

  final String? status;
  final String? message;
  final String? custid;
  final bool? promo;
  final String? memberId;

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) => RegisterResponseModel(
    status: json["status"],
    message: json["message"],
    custid: json["custid"],
    promo: json["promo"],
    memberId: json["member_id"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "custid": custid,
    "promo": promo,
    "member_id": memberId,
  };
}