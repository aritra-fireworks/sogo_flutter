
class DailyRewardsModel {
  DailyRewardsModel({
    this.status,
    this.message,
    this.claimedToday,
    this.weeks,
    this.checkInHistory,
  });

  final String? status;
  final String? message;
  final bool? claimedToday;
  final List<Week>? weeks;
  final List<CheckInHistory>? checkInHistory;

  factory DailyRewardsModel.fromJson(Map<String, dynamic> json) => DailyRewardsModel(
    status: json["status"],
    message: json["message"],
    claimedToday: json["claimed_today"],
    weeks: json["weeks"] == null ? null : List<Week>.from(json["weeks"].map((x) => Week.fromJson(x))),
    checkInHistory: json["check_in_history"] == null ? null : List<CheckInHistory>.from(json["check_in_history"].map((x) => CheckInHistory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "claimed_today": claimedToday,
    "weeks": weeks == null ? null : List<dynamic>.from(weeks!.map((x) => x.toJson())),
    "check_in_history": checkInHistory == null ? null : List<dynamic>.from(checkInHistory!.map((x) => x.toJson())),
  };
}

class CheckInHistory {
  CheckInHistory({
    this.id,
    this.checkInAt,
    this.date,
    this.reward,
  });

  final String? id;
  final String? checkInAt;
  final String? date;
  final String? reward;

  factory CheckInHistory.fromJson(Map<String, dynamic> json) => CheckInHistory(
    id: json["id"],
    checkInAt: json["check_in_at"],
    date: json["date"],
    reward: json["reward"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "check_in_at": checkInAt,
    "date": date,
    "reward": reward,
  };
}

class Week {
  Week({
    this.days,
  });

  final List<Day>? days;

  factory Week.fromJson(Map<String, dynamic> json) => Week(
    days: json["days"] == null ? null : List<Day>.from(json["days"].map((x) => Day.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "days": days == null ? null : List<dynamic>.from(days!.map((x) => x.toJson())),
  };
}

class Day {
  Day({
    this.day,
    this.dayTitle,
    this.dayCheckedIn,
    this.dayReward,
  });

  final int? day;
  final String? dayTitle;
  final bool? dayCheckedIn;
  final String? dayReward;

  factory Day.fromJson(Map<String, dynamic> json) => Day(
    day: json["day"],
    dayTitle: json["day_title"],
    dayCheckedIn: json["day_checked_in"],
    dayReward: json["day_reward"],
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "day_title": dayTitle,
    "day_checked_in": dayCheckedIn,
    "day_reward": dayReward,
  };
}
