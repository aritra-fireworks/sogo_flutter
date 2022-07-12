
class RewardsListModel {
  RewardsListModel({
    this.status,
    this.custname,
    this.total,
    this.starts,
    this.end,
    this.points,
    this.location,
    this.rewards,
  });

  final String? status;
  final String? custname;
  final int? total;
  final int? starts;
  final int? end;
  final String? points;
  final List<Location>? location;
  final List<Reward>? rewards;

  factory RewardsListModel.fromJson(Map<String, dynamic> json) => RewardsListModel(
    status: json["status"],
    custname: json["custname"],
    total: json["total"],
    starts: json["starts"],
    end: json["end"],
    points: json["points"],
    location: json["location"] == null ? null : List<Location>.from(json["location"].map((x) => Location.fromJson(x))),
    rewards: json["rewards"] == null ? null : List<Reward>.from(json["rewards"].map((x) => Reward.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "custname": custname,
    "total": total,
    "starts": starts,
    "end": end,
    "points": points,
    "location": location == null ? null : List<dynamic>.from(location!.map((x) => x.toJson())),
    "rewards": rewards == null ? null : List<dynamic>.from(rewards!.map((x) => x.toJson())),
  };
}

class Location {
  Location({
    this.locationId,
    this.locationName,
  });

  final String? locationId;
  final String? locationName;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    locationId: json["location_id"],
    locationName: json["location_name"],
  );

  Map<String, dynamic> toJson() => {
    "location_id": locationId,
    "location_name": locationName,
  };
}

class Reward {
  Reward({
    this.id,
    this.name,
    this.redeemLoc,
    this.description,
    this.category,
    this.quantity,
    this.buyTo,
    this.endDateText,
    this.bookmarkStatus,
    this.point,
    this.pointsRaw,
    this.img,
    this.label,
    this.mall,
    this.mallName,
  });

  final String? id;
  final String? name;
  final String? redeemLoc;
  final String? description;
  final String? category;
  final String? quantity;
  final String? buyTo;
  final String? endDateText;
  final int? bookmarkStatus;
  final String? point;
  final int? pointsRaw;
  final String? img;
  final String? label;
  final int? mall;
  final String? mallName;

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
    id: json["id"],
    name: json["name"],
    redeemLoc: json["redeem_loc"],
    description: json["description"],
    category: json["category"],
    quantity: json["quantity"],
    buyTo: json["buy_to"],
    endDateText: json["end_date_text"],
    bookmarkStatus: json["bookmark_status"],
    point: json["point"],
    pointsRaw: json["points_raw"],
    img: json["img"],
    label: json["label"],
    mall: json["mall"],
    mallName: json["mall_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "redeem_loc": redeemLoc,
    "description": description,
    "category": category,
    "quantity": quantity,
    "buy_to": buyTo,
    "end_date_text": endDateText,
    "bookmark_status": bookmarkStatus,
    "point": point,
    "points_raw": pointsRaw,
    "img": img,
    "label": label,
    "mall": mall,
    "mall_name": mallName,
  };
}
