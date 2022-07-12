
class CheckMigrateUserModel {
  CheckMigrateUserModel({
    this.status,
    this.migratedUser,
    this.message,
  });

  final String? status;
  final bool? migratedUser;
  final String? message;

  factory CheckMigrateUserModel.fromJson(Map<String, dynamic> json) => CheckMigrateUserModel(
    status: json["status"],
    migratedUser: json["migrated_user"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "migrated_user": migratedUser,
    "message": message,
  };
}
