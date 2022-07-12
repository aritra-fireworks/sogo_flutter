class SupportResponseModel {
  SupportResponseModel({
    this.isSent,
  });

  final bool? isSent;

  factory SupportResponseModel.fromJson(Map<String, dynamic> json) => SupportResponseModel(
    isSent: json["isSent"],
  );

  Map<String, dynamic> toJson() => {
    "isSent": isSent,
  };
}