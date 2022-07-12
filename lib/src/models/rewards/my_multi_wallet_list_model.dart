
class MyMultiWalletListModel {
  MyMultiWalletListModel({
    this.status,
    this.custname,
    this.points,
    this.wallet,
  });

  final String? status;
  final String? custname;
  final String? points;
  final List<MultiWallet>? wallet;

  factory MyMultiWalletListModel.fromJson(Map<String, dynamic> json) => MyMultiWalletListModel(
    status: json["status"],
    custname: json["custname"],
    points: json["points"],
    wallet: json["wallet"] == null ? null : List<MultiWallet>.from(json["wallet"].map((x) => MultiWallet.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "custname": custname,
    "points": points,
    "wallet": wallet == null ? null : List<dynamic>.from(wallet!.map((x) => x.toJson())),
  };
}

class MultiWallet {
  MultiWallet({
    this.id,
    this.name,
    this.point,
    this.redeemStatus,
    this.giftStatus,
    this.purchaseEnd,
    this.type,
    this.img,
    this.mall,
  });

  final String? id;
  final String? name;
  final String? point;
  final String? redeemStatus;
  final String? giftStatus;
  final String? purchaseEnd;
  final String? type;
  final String? img;
  final int? mall;

  factory MultiWallet.fromJson(Map<String, dynamic> json) => MultiWallet(
    id: json["id"],
    name: json["name"],
    point: json["point"],
    redeemStatus: json["redeem_status"],
    giftStatus: json["gift_status"],
    purchaseEnd: json["purchase_end"],
    type: json["type"],
    img: json["img"],
    mall: json["mall"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "point": point,
    "redeem_status": redeemStatus,
    "gift_status": giftStatus,
    "purchase_end": purchaseEnd,
    "type": type,
    "img": img,
    "mall": mall,
  };
}
