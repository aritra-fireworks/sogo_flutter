
class NotificationSettingsModel {
  NotificationSettingsModel({
    this.status,
    this.setting,
    this.general,
    this.news,
    this.rightHere,
  });

  final String? status;
  final String? setting;
  final String? general;
  final String? news;
  final String? rightHere;

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) => NotificationSettingsModel(
    status: json["status"],
    setting: json["setting"],
    general: json["general"],
    news: json["news"],
    rightHere: json["righthere"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "setting": setting,
    "general": general,
    "news": news,
    "righthere": rightHere,
  };
}
