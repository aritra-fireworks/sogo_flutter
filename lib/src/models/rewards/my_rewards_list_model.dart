
class MyRewardsListModel {
  MyRewardsListModel({
    this.status,
    this.custname,
    this.total,
    this.starts,
    this.end,
    this.points,
    this.wallet,
  });

  final String? status;
  final String? custname;
  final int? total;
  final int? starts;
  final int? end;
  final String? points;
  final List<Wallet>? wallet;

  factory MyRewardsListModel.fromJson(Map<String, dynamic> json) => MyRewardsListModel(
    status: json["status"],
    custname: json["custname"],
    total: json["total"],
    starts: json["starts"],
    end: json["end"],
    points: json["points"],
    wallet: json["wallet"] == null ? null : List<Wallet>.from(json["wallet"].map((x) => Wallet.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "custname": custname,
    "total": total,
    "starts": starts,
    "end": end,
    "points": points,
    "wallet": wallet == null ? null : List<dynamic>.from(wallet!.map((x) => x.toJson())),
  };
}

class Wallet {
  Wallet({
    this.id,
    this.cid,
    this.name,
    this.point,
    this.type,
    this.units,
    this.img,
    this.expiredDate,
    this.merchantName,
    this.mall,
  });

  final String? id;
  final String? cid;
  final String? name;
  final String? point;
  final String? type;
  final String? units;
  final String? img;
  final String? expiredDate;
  final String? merchantName;
  final int? mall;

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
    id: json["id"],
    cid: json["cid"],
    name: json["name"],
    point: json["point"],
    type: json["type"],
    units: json["units"],
    img: json["img"],
    expiredDate: json["expired_date"],
    merchantName: json["merchant_name"],
    mall: json["mall"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cid": cid,
    "name": name,
    "point": point,
    "type": type,
    "units": units,
    "img": img,
    "expired_date": expiredDate,
    "merchant_name": merchantName,
    "mall": mall,
  };
}
