class LoginProfileModel {
  LoginProfileModel({
    this.status,
    this.message,
    this.custid,
    this.name,
    this.fname,
    this.lname,
    this.phone,
    this.email,
    this.group,
    this.sid,
    this.changePassword,
    this.register,
    this.url,
    this.token,
  });

  final String? status;
  final String? message;
  final String? custid;
  final String? name;
  final String? fname;
  final String? lname;
  final String? phone;
  final String? email;
  final String? group;
  final String? sid;
  final String? changePassword;
  final String? register;
  final String? url;
  final String? token;

  factory LoginProfileModel.fromJson(Map<String, dynamic> json) => LoginProfileModel(
    status: json["status"],
    message: json["message"],
    custid: json["custid"],
    name: json["name"],
    fname: json["fname"],
    lname: json["lname"],
    phone: json["phone"],
    email: json["email"],
    group: json["group"],
    sid: json["sid"],
    changePassword: json["change_password"],
    register: json["register"],
    url: json["url"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "custid": custid,
    "name": name,
    "fname": fname,
    "lname": lname,
    "phone": phone,
    "email": email,
    "group": group,
    "sid": sid,
    "change_password": changePassword,
    "register": register,
    "url": url,
    "token": token,
  };
}
