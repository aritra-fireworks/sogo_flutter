
class MigrationDataModel {
  MigrationDataModel({
    this.status,
    this.message,
    this.migratedData,
  });

  final String? status;
  final String? message;
  final MigratedData? migratedData;

  factory MigrationDataModel.fromJson(Map<String, dynamic> json) => MigrationDataModel(
    status: json["status"],
    message: json["message"],
    migratedData: json["migrated_data"] == null ? null : MigratedData.fromJson(json["migrated_data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "migrated_data": migratedData == null ? null : migratedData!.toJson(),
  };
}

class MigratedData {
  MigratedData({
    this.fname,
    this.lname,
    this.email,
    this.phone,
    this.nric,
    this.dob,
    this.address1,
    this.address2,
    this.points,
    this.city,
    this.postcode,
    this.gender,
  });

  final String? fname;
  final String? lname;
  final String? email;
  final String? phone;
  final String? nric;
  final String? dob;
  final String? address1;
  final String? address2;
  final int? points;
  final String? city;
  final String? postcode;
  final int? gender;

  factory MigratedData.fromJson(Map<String, dynamic> json) => MigratedData(
    fname: json["fname"],
    lname: json["lname"],
    email: json["email"],
    phone: json["phone"],
    nric: json["nric"],
    dob: json["dob"],
    address1: json["address1"],
    address2: json["address2"],
    points: json["points"],
    city: json["city"],
    postcode: json["postcode"],
    gender: json["gender"],
  );

  Map<String, dynamic> toJson() => {
    "fname": fname,
    "lname": lname,
    "email": email,
    "phone": phone,
    "nric": nric,
    "dob": dob,
    "address1": address1,
    "address2": address2,
    "points": points,
    "city": city,
    "postcode": postcode,
    "gender": gender,
  };
}
