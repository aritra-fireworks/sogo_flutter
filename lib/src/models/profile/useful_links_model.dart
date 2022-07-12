
class UsefulLinksModel {
  UsefulLinksModel({
    this.status,
    this.urls,
  });

  final String? status;
  final List<Url>? urls;

  factory UsefulLinksModel.fromJson(Map<String, dynamic> json) => UsefulLinksModel(
    status: json["status"],
    urls: json["urls"] == null ? null : List<Url>.from(json["urls"].map((x) => Url.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "urls": urls == null ? null : List<dynamic>.from(urls!.map((x) => x.toJson())),
  };
}

class Url {
  Url({
    this.title,
    this.url,
    this.icon,
  });

  final String? title;
  final String? url;
  final String? icon;

  factory Url.fromJson(Map<String, dynamic> json) => Url(
    title: json["title"],
    url: json["url"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "url": url,
    "icon": icon,
  };
}
