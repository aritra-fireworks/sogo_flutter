
class DashboardModel {
  DashboardModel({
    this.gotProfile,
    this.profile,
    this.status,
    this.custname,
    this.custType,
    this.points,
    this.tenants,
    this.news,
    this.membersNews,
    this.bannerNews,
    this.promotions,
    this.rewards,
    this.hotDeals,
    this.events,
    this.purchaseNoRating,
    this.showDailyCheckIn,
  });

  final String? gotProfile;
  final String? profile;
  final String? status;
  final String? custname;
  final String? custType;
  final String? points;
  final List<MembersNew>? tenants;
  final List<MembersNew>? news;
  final List<MembersNew>? membersNews;
  final List<BannerNew>? bannerNews;
  final List<Promotion>? promotions;
  final List<HotDeal>? rewards;
  final List<HotDeal>? hotDeals;
  final List<EventItem>? events;
  final List<PurchaseNoRatingItem>? purchaseNoRating;
  final bool? showDailyCheckIn;

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
    gotProfile: json["got_profile"],
    profile: json["profile"],
    status: json["status"],
    custname: json["custname"],
    custType: json["cust_type"],
    points: json["points"],
    tenants: json["tenants"] == null ? null : List<MembersNew>.from(json["tenants"].map((x) => MembersNew.fromJson(x))),
    news: json["news"] == null ? null : List<MembersNew>.from(json["news"].map((x) => MembersNew.fromJson(x))),
    membersNews: json["members_news"] == null ? null : List<MembersNew>.from(json["members_news"].map((x) => MembersNew.fromJson(x))),
    bannerNews: json["banner_news"] == null ? null : List<BannerNew>.from(json["banner_news"].map((x) => BannerNew.fromJson(x))),
    promotions: json["promotions"] == null ? null : List<Promotion>.from(json["promotions"].map((x) => Promotion.fromJson(x))),
    rewards: json["rewards"] == null ? null : List<HotDeal>.from(json["rewards"].map((x) => HotDeal.fromJson(x))),
    hotDeals: json["hot_deals"] == null ? null : List<HotDeal>.from(json["hot_deals"].map((x) => HotDeal.fromJson(x))),
    events: json["events"] == null ? null : List<EventItem>.from(json["events"].map((x) => EventItem.fromJson(x))),
    purchaseNoRating: json["purchase_norating"] == null ? null : List<PurchaseNoRatingItem>.from(json["purchase_norating"].map((x) => HotDeal.fromJson(x))),
    showDailyCheckIn: json["showDailyCheckIn"],
  );

  Map<String, dynamic> toJson() => {
    "got_profile": gotProfile,
    "profile": profile,
    "status": status,
    "custname": custname,
    "cust_type": custType,
    "points": points,
    "tenants": tenants == null ? null : List<dynamic>.from(tenants!.map((x) => x.toJson())),
    "news": news == null ? null : List<dynamic>.from(news!.map((x) => x.toJson())),
    "members_news": membersNews == null ? null : List<dynamic>.from(membersNews!.map((x) => x.toJson())),
    "banner_news": bannerNews == null ? null : List<dynamic>.from(bannerNews!.map((x) => x.toJson())),
    "promotions": promotions == null ? null : List<dynamic>.from(promotions!.map((x) => x.toJson())),
    "rewards": rewards == null ? null : List<dynamic>.from(rewards!.map((x) => x.toJson())),
    "hot_deals": hotDeals == null ? null : List<dynamic>.from(hotDeals!.map((x) => x.toJson())),
    "events": events == null ? null : List<dynamic>.from(events!.map((x) => x)),
    "purchase_norating": purchaseNoRating == null ? null : List<dynamic>.from(purchaseNoRating!.map((x) => x)),
    "showDailyCheckIn": showDailyCheckIn,
  };
}

class BannerNew {
  BannerNew({
    this.id,
    this.title,
    this.description,
    this.featuredImg,
    this.createdAt,
    this.clickable,
    this.link,
    this.openLink,
  });

  final String? id;
  final String? title;
  final String? description;
  final String? featuredImg;
  final DateTime? createdAt;
  final bool? clickable;
  final String? link;
  final bool? openLink;

  factory BannerNew.fromJson(Map<String, dynamic> json) => BannerNew(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    featuredImg: json["featured_img"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    clickable: json["clickable"],
    link: json["link"],
    openLink: json["open_link"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "featured_img": featuredImg,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "clickable": clickable,
    "link": link,
    "open_link": openLink,
  };
}

class HotDeal {
  HotDeal({
    this.id,
    this.name,
    this.description,
    this.point,
    this.img,
    this.date,
    this.mall,
    this.mallName,
    this.label,
  });

  final String? id;
  final String? name;
  final String? description;
  final String? point;
  final String? img;
  final String? date;
  final int? mall;
  final String? mallName;
  final String? label;

  factory HotDeal.fromJson(Map<String, dynamic> json) => HotDeal(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    point: json["point"],
    img: json["img"],
    date: json["date"],
    mall: json["mall"],
    mallName: json["mall_name"],
    label: json["label"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "point": point,
    "img": img,
    "date": date,
    "mall": mall,
    "mall_name": mallName,
    "label": label,
  };
}

class MembersNew {
  MembersNew({
    this.id,
    this.title,
    this.description,
    this.featuredImg,
    this.createdAt,
    this.mall,
    this.link,
    this.openLink,
    this.location,
  });

  final String? id;
  final String? title;
  final String? description;
  final String? featuredImg;
  final String? createdAt;
  final int? mall;
  final String? link;
  final bool? openLink;
  final String? location;

  factory MembersNew.fromJson(Map<String, dynamic> json) => MembersNew(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    featuredImg: json["featured_img"],
    createdAt: json["created_at"],
    mall: json["mall"],
    link: json["link"],
    openLink: json["open_link"],
    location: json["location"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "featured_img": featuredImg,
    "created_at": createdAt,
    "mall": mall,
    "link": link,
    "open_link": openLink,
    "location": location,
  };
}

class Promotion {
  Promotion({
    this.id,
    this.title,
    this.description,
    this.featuredImg,
    this.createdAt,
    this.mall,
    this.startDate,
    this.endDate,
    this.endDateText,
  });

  final String? id;
  final String? title;
  final String? description;
  final String? featuredImg;
  final DateTime? createdAt;
  final int? mall;
  final String? startDate;
  final String? endDate;
  final String? endDateText;

  factory Promotion.fromJson(Map<String, dynamic> json) => Promotion(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    featuredImg: json["featured_img"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    mall: json["mall"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    endDateText: json["end_date_text"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "featured_img": featuredImg,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "mall": mall,
    "start_date": startDate,
    "end_date": endDate,
    "end_date_text": endDateText,
  };
}

class EventItem {
  EventItem({
    this.id,
    this.name,
    this.description,
    this.img,
    this.mall,
    this.date,
    this.openLink,
    this.link,
    this.point,
  });

  final String? id;
  final String? name;
  final String? description;
  final String? img;
  final int? mall;
  final String? date;
  final bool? openLink;
  final String? link;
  final String? point;


  factory EventItem.fromJson(Map<String, dynamic> json) => EventItem(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    img: json["img"],
    mall: json["mall"],
    date: json["date"],
    openLink: json["open_link"],
    link: json["link"],
    point: json["point"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "img": img,
    "mall": mall,
    "date": date,
    "open_link": openLink,
    "link": link,
    "point": point,
  };
}

class PurchaseNoRatingItem {
  PurchaseNoRatingItem({
    this.id,
    this.title,
    this.productName,
    this.receiptNo,
    this.certificateNumber,
    this.price,
    this.point,
    this.purchaseDate,
    this.location,
    this.salesPerson,
    this.rating,
  });

  final String? id;
  final String? title;
  final String? productName;
  final String? receiptNo;
  final int? certificateNumber;
  final String? price;
  final String? point;
  final String? purchaseDate;
  final String? location;
  final String? salesPerson;
  final String? rating;


  factory PurchaseNoRatingItem.fromJson(Map<String, dynamic> json) => PurchaseNoRatingItem(
    id: json["id"],
    title: json["title"],
    productName: json["product_name"],
    receiptNo: json["receipt_no"],
    certificateNumber: json["certificate_number"],
    price: json["price"],
    point: json["point"],
    purchaseDate: json["purchase_date"],
    location: json["location"],
    salesPerson: json["sales_person"],
    rating: json["rating"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "product_name": productName,
    "receipt_no": receiptNo,
    "certificate_number": certificateNumber,
    "price": price,
    "point": point,
    "purchase_date": purchaseDate,
    "location": location,
    "sales_person": salesPerson,
    "rating": rating,
  };
}