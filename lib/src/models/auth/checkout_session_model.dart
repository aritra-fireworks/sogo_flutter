class CheckSessionResponse {
  CheckSessionResponse({
    this.logout,
    this.message,
  });

  final String? logout;
  final String? message;

  factory CheckSessionResponse.fromJson(Map<String, dynamic> json) => CheckSessionResponse(
    logout: json["logout"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "logout": logout,
    "message": message,
  };
}