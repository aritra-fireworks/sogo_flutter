
class EventDetailsModel {
  EventDetailsModel({
    this.status,
    this.custname,
    this.details,
  });

  final String? status;
  final String? custname;
  final List<EventDetail>? details;

  factory EventDetailsModel.fromJson(Map<String, dynamic> json) => EventDetailsModel(
    status: json["status"],
    custname: json["custname"],
    details: json["details"] == null ? null : List<EventDetail>.from(json["details"].map((x) => EventDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "custname": custname,
    "details": details == null ? null : List<dynamic>.from(details!.map((x) => x.toJson())),
  };
}

class EventDetail {
  EventDetail({
    this.id,
    this.title,
    this.description,
    this.featuredImage,
    this.validity,
    this.validityMessage,
    this.points,
    this.purchaseLimit,
    this.limitMessage,
    this.stockLeft,
    this.quantityMessage,
    this.purchaseStart,
    this.purchaseEnd,
    this.merchantid,
    this.redeemStart,
    this.redeemEnd,
    this.address,
    this.latitude,
    this.longitude,
    this.stockStatus,
    this.stockMessage,
    this.bookmarkStatus,
    this.moreDetails,
    this.shareLink,
    this.redeemStatus,
    this.label,
    this.mall,
  });

  final String? id;
  final String? title;
  final String? description;
  final String? featuredImage;
  final String? validity;
  final String? validityMessage;
  final String? points;
  final String? purchaseLimit;
  final String? limitMessage;
  final int? stockLeft;
  final String? quantityMessage;
  final String? purchaseStart;
  final String? purchaseEnd;
  final String? merchantid;
  final String? redeemStart;
  final String? redeemEnd;
  final String? address;
  final String? latitude;
  final String? longitude;
  final int? stockStatus;
  final String? stockMessage;
  final int? bookmarkStatus;
  final String? moreDetails;
  final String? shareLink;
  final int? redeemStatus;
  final String? label;
  final int? mall;

  factory EventDetail.fromJson(Map<String, dynamic> json) => EventDetail(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    featuredImage: json["featured_image"],
    validity: json["validity"],
    validityMessage: json["validity_message"],
    points: json["points"],
    purchaseLimit: json["purchase_limit"],
    limitMessage: json["limit_message"],
    stockLeft: json["stock_left"],
    quantityMessage: json["quantity_message"],
    purchaseStart: json["purchase_start"],
    purchaseEnd: json["purchase_end"],
    merchantid: json["merchantid"],
    redeemStart: json["redeem_start"],
    redeemEnd: json["redeem_end"],
    address: json["address"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    stockStatus: json["stock_status"],
    stockMessage: json["stock_message"],
    bookmarkStatus: json["bookmark_status"],
    moreDetails: json["more_details"],
    shareLink: json["share_link"],
    redeemStatus: json["redeem_status"],
    label: json["label"],
    mall: json["mall"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "featured_image": featuredImage,
    "validity": validity,
    "validity_message": validityMessage,
    "points": points,
    "purchase_limit": purchaseLimit,
    "limit_message": limitMessage,
    "stock_left": stockLeft,
    "quantity_message": quantityMessage,
    "purchase_start": purchaseStart,
    "purchase_end": purchaseEnd,
    "merchantid": merchantid,
    "redeem_start": redeemStart,
    "redeem_end": redeemEnd,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "stock_status": stockStatus,
    "stock_message": stockMessage,
    "bookmark_status": bookmarkStatus,
    "more_details": moreDetails,
    "share_link": shareLink,
    "redeem_status": redeemStatus,
    "label": label,
    "mall": mall,
  };
}
