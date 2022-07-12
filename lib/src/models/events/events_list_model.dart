
class EventsListModel {
  EventsListModel({
    this.status,
    this.custname,
    this.total,
    this.points,
    this.location,
    this.events,
  });

  final String? status;
  final String? custname;
  final int? total;
  final String? points;
  final List<Location>? location;
  final List<Event>? events;

  factory EventsListModel.fromJson(Map<String, dynamic> json) => EventsListModel(
    status: json["status"],
    custname: json["custname"],
    total: json["total"],
    points: json["points"],
    location: json["location"] == null ? null : List<Location>.from(json["location"].map((x) => Location.fromJson(x))),
    events: json["events"] == null ? null : List<Event>.from(json["events"].map((x) => Event.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "custname": custname,
    "total": total,
    "points": points,
    "location": location == null ? null : List<dynamic>.from(location!.map((x) => x.toJson())),
    "events": events == null ? null : List<dynamic>.from(events!.map((x) => x.toJson())),
  };
}

class Event {
  Event({
    this.id,
    this.name,
    this.description,
    this.quantity,
    this.city,
    this.point,
    this.bookmarkStatus,
    this.img,
    this.createDate,
    this.date,
    this.expiryDate,
    this.label,
    this.mall,
    this.link,
    this.openLink,
  });

  final String? id;
  final String? name;
  final String? description;
  final String? quantity;
  final String? city;
  final String? point;
  final int? bookmarkStatus;
  final String? img;
  final DateTime? createDate;
  final DateTime? date;
  final String? expiryDate;
  final String? label;
  final int? mall;
  final String? link;
  final bool? openLink;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    quantity: json["quantity"],
    city: json["city"],
    point: json["point"],
    bookmarkStatus: json["bookmark_status"],
    img: json["img"],
    createDate: json["create_date"] == null ? null : DateTime.parse(json["create_date"]),
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    expiryDate: json["expiry_date"],
    label: json["label"],
    mall: json["mall"],
    link: json["link"],
    openLink: json["open_link"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "quantity": quantity,
    "city": city,
    "point": point,
    "bookmark_status": bookmarkStatus,
    "img": img,
    "create_date": createDate == null ? null : "${createDate!.year.toString().padLeft(4, '0')}-${createDate!.month.toString().padLeft(2, '0')}-${createDate!.day.toString().padLeft(2, '0')}",
    "date": date == null ? null : "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "expiry_date": expiryDate,
    "label": label,
    "mall": mall,
    "link": link,
    "open_link": openLink,
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
