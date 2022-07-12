class UserProfileModel {
  UserProfileModel({
    this.status,
    this.voucher,
    this.profile,
  });

  final String? status;
  final String? voucher;
  final Profile? profile;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
    status: json["status"],
    voucher: json["voucher"],
    profile: json["profile"] == null ? null : Profile.fromJson(json["profile"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "voucher": voucher,
    "profile": profile == null ? null : profile!.toJson(),
  };
}

class Profile {
  Profile({
    this.customerStatus,
    this.custid,
    this.title,
    this.name,
    this.fname,
    this.lname,
    this.email,
    this.nric,
    this.phoneCountry,
    this.displayName,
    this.phone,
    this.postcode,
    this.cardno,
    this.hobby,
    this.interest,
    this.dob,
    this.race,
    this.gender,
    this.qrcode,
    this.qrimage,
    this.totalReward,
    this.totalRewardPurchased,
    this.totalEventPurchased,
    this.redeemablePoints,
    this.floatingPoints,
    this.points,
    this.expired,
    this.voucher,
    this.rank,
    this.custType,
    this.nextRank,
    this.rankImg,
    this.memberCard,
    this.nextLevel,
    this.nextLevelPercentage,
    this.pc,
    this.purchaseValue,
    this.pValue,
    this.formattedPValue,
    this.userType,
    this.preferredMall,
    this.gotProfile,
    this.profile,
    this.loveAnniversary,
    this.nationality,
    this.countryOfResidence,
    this.address1,
    this.address2,
    this.city,
    this.region,
    this.householdIncome,
    this.selectedInterests,
    this.cardExpiry,
    this.isTester,
    this.idType,
    this.referralCode,
    this.referralWebUrl,
    this.expiryPoints,
    this.pointExpiryDate,
    this.pointExpiryValue,
    this.pointsExpiry,
    this.passwordSaved,
  });

  final String? customerStatus;
  final String? custid;
  final String? title;
  final String? name;
  final String? fname;
  final String? lname;
  final String? email;
  final String? nric;
  final String? phoneCountry;
  final String? displayName;
  final String? phone;
  final String? postcode;
  final String? cardno;
  final String? hobby;
  final String? interest;
  final String? dob;
  final String? race;
  final String? gender;
  final String? qrcode;
  final String? qrimage;
  final String? totalReward;
  final String? totalRewardPurchased;
  final String? totalEventPurchased;
  final String? redeemablePoints;
  final String? floatingPoints;
  final String? points;
  final String? expired;
  final String? voucher;
  final String? rank;
  final String? custType;
  final String? nextRank;
  final String? rankImg;
  final String? memberCard;
  final String? nextLevel;
  final int? nextLevelPercentage;
  final int? pc;
  final String? purchaseValue;
  final int? pValue;
  final String? formattedPValue;
  final String? userType;
  final String? preferredMall;
  final String? gotProfile;
  final String? profile;
  final String? loveAnniversary;
  final String? nationality;
  final String? countryOfResidence;
  final String? address1;
  final String? address2;
  final String? city;
  final String? region;
  final int? householdIncome;
  final String? selectedInterests;
  final String? cardExpiry;
  final String? isTester;
  final int? idType;
  final String? referralCode;
  final String? referralWebUrl;
  final String? expiryPoints;
  final String? pointExpiryDate;
  final String? pointExpiryValue;
  final List<PointsExpiry>? pointsExpiry;
  final bool? passwordSaved;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    customerStatus: json["customer_status"],
    custid: json["custid"],
    title: json["title"],
    name: json["name"],
    fname: json["fname"],
    lname: json["lname"],
    email: json["email"],
    nric: json["nric"],
    phoneCountry: json["phone_country"],
    displayName: json["display_name"],
    phone: json["phone"],
    postcode: json["postcode"],
    cardno: json["cardno"],
    hobby: json["hobby"],
    interest: json["interest"],
    dob: json["dob"],
    race: json["race"],
    gender: json["gender"],
    qrcode: json["qrcode"],
    qrimage: json["qrimage"],
    totalReward: json["total_reward"],
    totalRewardPurchased: json["total_reward_purchased"],
    totalEventPurchased: json["total_event_purchased"],
    redeemablePoints: json["redeemable_points"],
    floatingPoints: json["floating_points"],
    points: json["points"],
    expired: json["expired"],
    voucher: json["voucher"],
    rank: json["rank"],
    custType: json["cust_type"],
    nextRank: json["next_rank"],
    rankImg: json["rank_img"],
    memberCard: json["member_card"],
    nextLevel: json["next_level"],
    nextLevelPercentage: json["next_level_percentage"],
    pc: json["pc"],
    purchaseValue: json["purchase_value"],
    pValue: json["p_value"],
    formattedPValue: json["formatted_p_value"],
    userType: json["user_type"],
    preferredMall: json["preferred_mall"],
    gotProfile: json["got_profile"],
    profile: json["profile"],
    loveAnniversary: json["love_anniversary"],
    nationality: json["nationality"],
    countryOfResidence: json["country_of_residence"],
    address1: json["address1"],
    address2: json["address2"],
    city: json["city"],
    region: json["region"],
    householdIncome: json["household_income"],
    selectedInterests: json["selected_interests"],
    cardExpiry: json["card_expiry"],
    isTester: json["is_tester"],
    idType: json["id_type"],
    referralCode: json["referral_code"],
    referralWebUrl: json["referral_web_url"],
    expiryPoints: json["expiry_points"],
    pointExpiryDate: json["point_expiry_date"],
    pointExpiryValue: json["point_expiry_value"],
    pointsExpiry: json["points_expiry"] == null ? null : List<PointsExpiry>.from(json["points_expiry"].map((x) => PointsExpiry.fromJson(x))),
    passwordSaved: json["password_saved"],
  );

  Map<String, dynamic> toJson() => {
    "customer_status": customerStatus,
    "custid": custid,
    "title": title,
    "name": name,
    "fname": fname,
    "lname": lname,
    "email": email,
    "nric": nric,
    "phone_country": phoneCountry,
    "display_name": displayName,
    "phone": phone,
    "postcode": postcode,
    "cardno": cardno,
    "hobby": hobby,
    "interest": interest,
    "dob": dob,
    "race": race,
    "gender": gender,
    "qrcode": qrcode,
    "qrimage": qrimage,
    "total_reward": totalReward,
    "total_reward_purchased": totalRewardPurchased,
    "total_event_purchased": totalEventPurchased,
    "redeemable_points": redeemablePoints,
    "floating_points": floatingPoints,
    "points": points,
    "expired": expired,
    "voucher": voucher,
    "rank": rank,
    "cust_type": custType,
    "next_rank": nextRank,
    "rank_img": rankImg,
    "member_card": memberCard,
    "next_level": nextLevel,
    "next_level_percentage": nextLevelPercentage,
    "pc": pc,
    "purchase_value": purchaseValue,
    "p_value": pValue,
    "formatted_p_value": formattedPValue,
    "user_type": userType,
    "preferred_mall": preferredMall,
    "got_profile": gotProfile,
    "profile": profile,
    "love_anniversary": loveAnniversary,
    "nationality": nationality,
    "country_of_residence": countryOfResidence,
    "address1": address1,
    "address2": address2,
    "city": city,
    "region": region,
    "household_income": householdIncome,
    "selected_interests": selectedInterests,
    "card_expiry": cardExpiry,
    "is_tester": isTester,
    "id_type": idType,
    "referral_code": referralCode,
    "referral_web_url": referralWebUrl,
    "expiry_points": expiryPoints,
    "point_expiry_date": pointExpiryDate,
    "point_expiry_value": pointExpiryValue,
    "points_expiry": pointsExpiry == null ? null : List<dynamic>.from(pointsExpiry!.map((x) => x.toJson())),
    "password_saved": passwordSaved,
  };
}

class PointsExpiry {
  PointsExpiry({
    this.expiryPoints,
    this.expiryText,
    this.expiryDate,
    this.expiryContent,
  });

  final int? expiryPoints;
  final String? expiryText;
  final String? expiryDate;
  final String? expiryContent;

  factory PointsExpiry.fromJson(Map<String, dynamic> json) => PointsExpiry(
    expiryPoints: json["expiry_points"],
    expiryText: json["expiry_text"],
    expiryDate: json["expiry_date"],
    expiryContent: json["expiry_content"],
  );

  Map<String, dynamic> toJson() => {
    "expiry_points": expiryPoints,
    "expiry_text": expiryText,
    "expiry_date": expiryDate,
    "expiry_content": expiryContent,
  };
}
