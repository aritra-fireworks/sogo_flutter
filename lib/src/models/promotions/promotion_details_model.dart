
class PromotionDetailsModel {
  PromotionDetailsModel({
    this.status,
    this.news,
  });

  final String? status;
  final List<News>? news;

  factory PromotionDetailsModel.fromJson(Map<String, dynamic> json) => PromotionDetailsModel(
    status: json["status"],
    news: json["news"] == null ? null : List<News>.from(json["news"].map((x) => News.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "news": news == null ? null : List<dynamic>.from(news!.map((x) => x.toJson())),
  };
}

class News {
  News({
    this.id,
    this.title,
    this.description,
    this.featuredImg,
    this.link,
    this.shareLink,
    this.startDate,
    this.endDate,
    this.location,
    this.createdAt,
    this.mall,
  });

  final String? id;
  final String? title;
  final String? description;
  final String? featuredImg;
  final String? link;
  final String? shareLink;
  final String? startDate;
  final String? endDate;
  final String? location;
  final DateTime? createdAt;
  final int? mall;

  factory News.fromJson(Map<String, dynamic> json) => News(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    featuredImg: json["featured_img"],
    link: json["link"],
    shareLink: json["share_link"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    location: json["location"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    mall: json["mall"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "featured_img": featuredImg,
    "link": link,
    "share_link": shareLink,
    "start_date": startDate,
    "end_date": endDate,
    "location": location,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "mall": mall,
  };
}
