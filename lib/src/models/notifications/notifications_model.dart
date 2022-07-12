
class NotificationsModel {
  NotificationsModel({
    this.status,
    this.privateInboxUnread,
    this.globalInboxUnread,
    this.privateInbox,
    this.globalInbox,
  });

  final String? status;
  final int? privateInboxUnread;
  final int? globalInboxUnread;
  final List<Inbox>? privateInbox;
  final List<Inbox>? globalInbox;

  factory NotificationsModel.fromJson(Map<String, dynamic> json) => NotificationsModel(
    status: json["status"],
    privateInboxUnread: json["private_inbox_unread"],
    globalInboxUnread: json["global_inbox_unread"],
    privateInbox: json["private_inbox"] == null ? null : List<Inbox>.from(json["private_inbox"].map((x) => Inbox.fromJson(x))),
    globalInbox: json["global_inbox"] == null ? null : List<Inbox>.from(json["global_inbox"].map((x) => Inbox.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "private_inbox_unread": privateInboxUnread,
    "global_inbox_unread": globalInboxUnread,
    "private_inbox": privateInbox == null ? null : List<dynamic>.from(privateInbox!.map((x) => x.toJson())),
    "global_inbox": globalInbox == null ? null : List<dynamic>.from(globalInbox!.map((x) => x.toJson())),
  };
}

class Inbox {
  Inbox({
    this.id,
    this.title,
    this.message,
    this.image,
    this.unread,
    this.createdAt,
    this.date,
  });

  final int? id;
  final String? title;
  final String? message;
  final String? image;
  final int? unread;
  final DateTime? createdAt;
  final String? date;

  factory Inbox.fromJson(Map<String, dynamic> json) => Inbox(
    id: json["id"],
    title: json["title"],
    message: json["message"],
    image: json["image"],
    unread: json["unread"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "message": message,
    "image": image,
    "unread": unread,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "date": date,
  };
}
