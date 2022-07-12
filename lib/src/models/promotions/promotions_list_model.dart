
class PromotionsListModel {
  PromotionsListModel({
    this.status,
    this.total,
    this.news,
  });

  final String? status;
  final int? total;
  final List<News>? news;

  factory PromotionsListModel.fromJson(Map<String, dynamic> json) => PromotionsListModel(
    status: json["status"],
    total: json["total"],
    news: json["news"] == null ? null : List<News>.from(json["news"].map((x) => News.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "total": total,
    "news": news == null ? null : List<dynamic>.from(news!.map((x) => x.toJson())),
  };
}

class News {
  News({
    this.id,
    this.title,
    this.description,
    this.featuredImg,
    this.category,
    this.link,
    this.openLink,
    this.startDate,
    this.endDate,
    this.endDateText,
    this.location,
    this.createdAt,
    this.mall,
  });

  final String? id;
  final String? title;
  final String? description;
  final String? featuredImg;
  final String? category;
  final String? link;
  final bool? openLink;
  final String? startDate;
  final String? endDate;
  final String? endDateText;
  final String? location;
  final DateTime? createdAt;
  final int? mall;

  factory News.fromJson(Map<String, dynamic> json) => News(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    featuredImg: json["featured_img"],
    category: json["category"],
    link: json["link"],
    openLink: json["open_link"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    endDateText: json["end_date_text"],
    location: json["location"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    mall: json["mall"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "featured_img": featuredImg,
    "category": category,
    "link": link,
    "open_link": openLink,
    "start_date": startDate,
    "end_date": endDate,
    "end_date_text": endDateText,
    "location": location,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "mall": mall,
  };
}
