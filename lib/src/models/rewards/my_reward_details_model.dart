
class MyRewardDetailsModel {
  MyRewardDetailsModel({
    this.status,
    this.custname,
    this.details,
    this.sharedMessage,
  });

  final String? status;
  final String? custname;
  final List<MyRewardDetail>? details;
  final dynamic sharedMessage;

  factory MyRewardDetailsModel.fromJson(Map<String, dynamic> json) => MyRewardDetailsModel(
    status: json["status"],
    custname: json["custname"],
    details: json["details"] == null ? null : List<MyRewardDetail>.from(json["details"].map((x) => MyRewardDetail.fromJson(x))),
    sharedMessage: json["shared_message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "custname": custname,
    "details": details == null ? null : List<dynamic>.from(details!.map((x) => x.toJson())),
    "shared_message": sharedMessage,
  };
}

class MyRewardDetail {
  MyRewardDetail({
    this.merchantInfo,
    this.shipping,
    this.redeemLocation,
    this.type,
    this.id,
    this.walletId,
    this.title,
    this.description,
    this.featuredImage,
    this.validity,
    this.validityMessage,
    this.points,
    this.purchaseStart,
    this.purchaseEnd,
    this.redeemStart,
    this.redeemEnd,
    this.qrcode,
    this.qrCode,
    this.barCode,
    this.textCode,
    this.bookmarkStatus,
    this.buttonStatus,
    this.branchesAvailable,
    this.merchantid,
    this.merchantName,
    this.giftStatus,
    this.redeemStatus,
    this.shareLink,
    this.moreDetails,
    this.mall,
  });

  final List<MerchantInfo>? merchantInfo;
  final bool? shipping;
  final String? redeemLocation;
  final String? type;
  final String? id;
  final String? walletId;
  final String? title;
  final String? description;
  final String? featuredImage;
  final String? validity;
  final String? validityMessage;
  final String? points;
  final String? purchaseStart;
  final String? purchaseEnd;
  final String? redeemStart;
  final String? redeemEnd;
  final String? qrcode;
  final bool? qrCode;
  final bool? barCode;
  final bool? textCode;
  final int? bookmarkStatus;
  final int? buttonStatus;
  final int? branchesAvailable;
  final String? merchantid;
  final dynamic merchantName;
  final String? giftStatus;
  final String? redeemStatus;
  final String? shareLink;
  final String? moreDetails;
  final int? mall;

  factory MyRewardDetail.fromJson(Map<String, dynamic> json) => MyRewardDetail(
    merchantInfo: json["merchant_info"] == null ? null : List<MerchantInfo>.from(json["merchant_info"].map((x) => MerchantInfo.fromJson(x))),
    shipping: json["shipping"],
    redeemLocation: json["redeem_location"],
    type: json["type"],
    id: json["id"],
    walletId: json["wallet_id"],
    title: json["title"],
    description: json["description"],
    featuredImage: json["featured_image"],
    validity: json["validity"],
    validityMessage: json["validity_message"],
    points: json["points"],
    purchaseStart: json["purchase_start"],
    purchaseEnd: json["purchase_end"],
    redeemStart: json["redeem_start"],
    redeemEnd: json["redeem_end"],
    qrcode: json["qrcode"],
    qrCode: json["qr_code"],
    barCode: json["bar_code"],
    textCode: json["text_code"],
    bookmarkStatus: json["bookmark_status"],
    buttonStatus: json["button_status"],
    branchesAvailable: json["branches_available"],
    merchantid: json["merchantid"],
    merchantName: json["merchant_name"],
    giftStatus: json["gift_status"],
    redeemStatus: json["redeem_status"],
    shareLink: json["share_link"],
    moreDetails: json["more_details"],
    mall: json["mall"],
  );

  Map<String, dynamic> toJson() => {
    "merchant_info": merchantInfo == null ? null : List<dynamic>.from(merchantInfo!.map((x) => x.toJson())),
    "shipping": shipping,
    "redeem_location": redeemLocation,
    "type": type,
    "id": id,
    "wallet_id": walletId,
    "title": title,
    "description": description,
    "featured_image": featuredImage,
    "validity": validity,
    "validity_message": validityMessage,
    "points": points,
    "purchase_start": purchaseStart,
    "purchase_end": purchaseEnd,
    "redeem_start": redeemStart,
    "redeem_end": redeemEnd,
    "qrcode": qrcode,
    "qr_code": qrCode,
    "bar_code": barCode,
    "text_code": textCode,
    "bookmark_status": bookmarkStatus,
    "button_status": buttonStatus,
    "branches_available": branchesAvailable,
    "merchantid": merchantid,
    "merchant_name": merchantName,
    "gift_status": giftStatus,
    "redeem_status": redeemStatus,
    "share_link": shareLink,
    "more_details": moreDetails,
    "mall": mall,
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
