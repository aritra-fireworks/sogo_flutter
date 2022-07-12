
class MallListModel {
  MallListModel({
    this.status,
    this.malls,
  });

  final String? status;
  final List<Mall>? malls;

  factory MallListModel.fromJson(Map<String, dynamic> json) => MallListModel(
    status: json["status"],
    malls: json["malls"] == null ? null : List<Mall>.from(json["malls"].map((x) => Mall.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "malls": malls == null ? null : List<dynamic>.from(malls!.map((x) => x.toJson())),
  };
}

class Mall {
  Mall({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.shortDesc,
    this.logo,
    this.textLogo,
    this.mallLogoInverse,
    this.icon,
    this.mallIconWhite,
    this.about,
    this.contactUs,
    this.waze,
    this.whatsapp,
    this.googleMaps,
    this.showDirectory,
    this.showReceipt,
    this.defaultMall,
  });

  final String? id;
  final String? name;
  final String? phone;
  final String? email;
  final String? shortDesc;
  final String? logo;
  final String? textLogo;
  final String? mallLogoInverse;
  final String? icon;
  final String? mallIconWhite;
  final String? about;
  final String? contactUs;
  final String? waze;
  final String? whatsapp;
  final String? googleMaps;
  final bool? showDirectory;
  final bool? showReceipt;
  final bool? defaultMall;

  factory Mall.fromJson(Map<String, dynamic> json) => Mall(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    email: json["email"],
    shortDesc: json["short_desc"],
    logo: json["logo"],
    textLogo: json["text_logo"],
    mallLogoInverse: json["mall_logo_inverse"],
    icon: json["icon"],
    mallIconWhite: json["mall_icon_white"],
    about: json["about"],
    contactUs: json["contact_us"],
    waze: json["waze"],
    whatsapp: json["whatsapp"],
    googleMaps: json["google_maps"],
    showDirectory: json["showDirectory"],
    showReceipt: json["showReceipt"],
    defaultMall: json["defaultMall"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "email": email,
    "short_desc": shortDesc,
    "logo": logo,
    "text_logo": textLogo,
    "mall_logo_inverse": mallLogoInverse,
    "icon": icon,
    "mall_icon_white": mallIconWhite,
    "about": about,
    "contact_us": contactUs,
    "waze": waze,
    "whatsapp": whatsapp,
    "google_maps": googleMaps,
    "showDirectory": showDirectory,
    "showReceipt": showReceipt,
    "defaultMall": defaultMall,
  };

  @override
  bool operator == (dynamic other) {
    return other != null && other is Mall && mallLogoInverse == other.mallLogoInverse;
  }

  @override
  int get hashCode => super.hashCode;
}
