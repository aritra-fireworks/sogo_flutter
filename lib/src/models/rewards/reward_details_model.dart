
class RewardDetailsModel {
  RewardDetailsModel({
    this.status,
    this.custname,
    this.details,
  });

  final String? status;
  final String? custname;
  final List<Detail>? details;

  factory RewardDetailsModel.fromJson(Map<String, dynamic> json) => RewardDetailsModel(
    status: json["status"],
    custname: json["custname"],
    details: json["details"] == null ? null : List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "custname": custname,
    "details": details == null ? null : List<dynamic>.from(details!.map((x) => x.toJson())),
  };
}

class Detail {
  Detail({
    this.merchantInfo,
    this.id,
    this.title,
    this.description,
    this.featuredImage,
    this.validity,
    this.validityMessage,
    this.points,
    this.pointsRaw,
    this.purchaseLimit,
    this.limitMessage,
    this.purchaseQuantity,
    this.quantityMessage,
    this.purchaseStart,
    this.purchaseEnd,
    this.redeemStart,
    this.redeemEnd,
    this.merchantid,
    this.merchantName,
    this.stockStatus,
    this.stockMessage,
    this.bookmarkStatus,
    this.branchesAvailable,
    this.redeemLocation,
    this.moreDetails,
    this.address,
    this.label,
    this.mall,
    this.collectionMethod,
    this.gift,
    this.pickup,
    this.delivery,
  });

  final List<MerchantInfo>? merchantInfo;
  final String? id;
  final String? title;
  final String? description;
  final String? featuredImage;
  final String? validity;
  final String? validityMessage;
  final String? points;
  final int? pointsRaw;
  final String? purchaseLimit;
  final String? limitMessage;
  final String? purchaseQuantity;
  final String? quantityMessage;
  final String? purchaseStart;
  final String? purchaseEnd;
  final String? redeemStart;
  final String? redeemEnd;
  final String? merchantid;
  final String? merchantName;
  final int? stockStatus;
  final String? stockMessage;
  final int? bookmarkStatus;
  final int? branchesAvailable;
  final String? redeemLocation;
  final String? moreDetails;
  final String? address;
  final String? label;
  final int? mall;
  final List<CollectionMethod>? collectionMethod;
  final bool? gift;
  final bool? pickup;
  final bool? delivery;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    merchantInfo: json["merchant_info"] == null ? null : List<MerchantInfo>.from(json["merchant_info"].map((x) => MerchantInfo.fromJson(x))),
    id: json["id"],
    title: json["title"],
    description: json["description"],
    featuredImage: json["featured_image"],
    validity: json["validity"],
    validityMessage: json["validity_message"],
    points: json["points"],
    pointsRaw: json["points_raw"],
    purchaseLimit: json["purchase_limit"],
    limitMessage: json["limit_message"],
    purchaseQuantity: json["purchase_quantity"],
    quantityMessage: json["quantity_message"],
    purchaseStart: json["purchase_start"],
    purchaseEnd: json["purchase_end"],
    redeemStart: json["redeem_start"],
    redeemEnd: json["redeem_end"],
    merchantid: json["merchantid"],
    merchantName: json["merchant_name"],
    stockStatus: json["stock_status"],
    stockMessage: json["stock_message"],
    bookmarkStatus: json["bookmark_status"],
    branchesAvailable: json["branches_available"],
    redeemLocation: json["redeem_location"],
    moreDetails: json["more_details"],
    address: json["address"],
    label: json["label"],
    mall: json["mall"],
    collectionMethod: json["collection_method"] == null ? null : List<CollectionMethod>.from(json["collection_method"].map((x) => CollectionMethod.fromJson(x))),
    gift: json["gift"],
    pickup: json["pickup"],
    delivery: json["delivery"],
  );

  Map<String, dynamic> toJson() => {
    "merchant_info": merchantInfo == null ? null : List<dynamic>.from(merchantInfo!.map((x) => x.toJson())),
    "id": id,
    "title": title,
    "description": description,
    "featured_image": featuredImage,
    "validity": validity,
    "validity_message": validityMessage,
    "points": points,
    "points_raw": pointsRaw,
    "purchase_limit": purchaseLimit,
    "limit_message": limitMessage,
    "purchase_quantity": purchaseQuantity,
    "quantity_message": quantityMessage,
    "purchase_start": purchaseStart,
    "purchase_end": purchaseEnd,
    "redeem_start": redeemStart,
    "redeem_end": redeemEnd,
    "merchantid": merchantid,
    "merchant_name": merchantName,
    "stock_status": stockStatus,
    "stock_message": stockMessage,
    "bookmark_status": bookmarkStatus,
    "branches_available": branchesAvailable,
    "redeem_location": redeemLocation,
    "more_details": moreDetails,
    "address": address,
    "label": label,
    "mall": mall,
    "collection_method": collectionMethod == null ? null : List<dynamic>.from(collectionMethod!.map((x) => x.toJson())),
    "gift": gift,
    "pickup": pickup,
    "delivery": delivery,
  };
}

class CollectionMethod {
  CollectionMethod({
    this.id,
    this.title,
    this.shipping,
  });

  final String? id;
  final String? title;
  final bool? shipping;

  factory CollectionMethod.fromJson(Map<String, dynamic> json) => CollectionMethod(
    id: json["id"],
    title: json["title"],
    shipping: json["shipping"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "shipping": shipping,
  };
}

class MerchantInfo {
  MerchantInfo({
    this.title,
    this.id,
    this.mall,
  });

  final String? title;
  final String? id;
  final String? mall;

  factory MerchantInfo.fromJson(Map<String, dynamic> json) => MerchantInfo(
    title: json["title"],
    id: json["id"],
    mall: json["mall"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "id": id,
    "mall": mall,
  };
}
