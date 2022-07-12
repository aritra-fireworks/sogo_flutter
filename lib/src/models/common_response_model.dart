class CommonResponseModel {
  CommonResponseModel({
    this.status,
    this.message,
    this.img,
  });

  final String? status;
  final String? message;
  final String? img;

  factory CommonResponseModel.fromJson(Map<String, dynamic> json) => CommonResponseModel(
    status: json["status"],
    message: json["message"],
    img: json["img"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "img": img,
  };
}