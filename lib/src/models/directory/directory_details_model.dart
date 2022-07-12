
class DirectoryDetailsModel {
  DirectoryDetailsModel({
    this.status,
    this.custname,
    this.merchantDetails,
    this.branchDetails,
    this.relatedRewards,
    this.tab,
  });

  final String? status;
  final String? custname;
  final MerchantDetails? merchantDetails;
  final List<dynamic>? branchDetails;
  final List<dynamic>? relatedRewards;
  final List<dynamic>? tab;

  factory DirectoryDetailsModel.fromJson(Map<String, dynamic> json) => DirectoryDetailsModel(
    status: json["status"],
    custname: json["custname"],
    merchantDetails: json["merchant_details"] == null ? null : MerchantDetails.fromJson(json["merchant_details"]),
    branchDetails: json["branch_details"] == null ? null : List<dynamic>.from(json["branch_details"].map((x) => x)),
    relatedRewards: json["related_rewards"] == null ? null : List<dynamic>.from(json["related_rewards"].map((x) => x)),
    tab: json["tab"] == null ? null : List<dynamic>.from(json["tab"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "custname": custname,
    "merchant_details": merchantDetails == null ? null : merchantDetails!.toJson(),
    "branch_details": branchDetails == null ? null : List<dynamic>.from(branchDetails!.map((x) => x)),
    "related_rewards": relatedRewards == null ? null : List<dynamic>.from(relatedRewards!.map((x) => x)),
    "tab": tab == null ? null : List<dynamic>.from(tab!.map((x) => x)),
  };
}

class MerchantDetails {
  MerchantDetails({
    this.id,
    this.title,
    this.description,
    this.featuredImage,
    this.address,
    this.contact,
    this.weburl,
    this.favIcon,
    this.faq,
    this.termConditions,
    this.privacyPolicy,
    this.banner,
    this.menu5,
    this.menu5Url,
    this.facebookUrl,
    this.instagramUrl,
    this.youtubeUrl,
    this.googleUrl,
    this.twitterUrl,
    this.tagline,
    this.openTime,
    this.closeTime,
  });

  final String? id;
  final String? title;
  final String? description;
  final String? featuredImage;
  final String? address;
  final String? contact;
  final String? weburl;
  final String? favIcon;
  final String? faq;
  final String? termConditions;
  final String? privacyPolicy;
  final String? banner;
  final String? menu5;
  final String? menu5Url;
  final String? facebookUrl;
  final String? instagramUrl;
  final String? youtubeUrl;
  final String? googleUrl;
  final String? twitterUrl;
  final String? tagline;
  final String? openTime;
  final String? closeTime;

  factory MerchantDetails.fromJson(Map<String, dynamic> json) => MerchantDetails(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    featuredImage: json["featured_image"],
    address: json["address"],
    contact: json["contact"],
    weburl: json["weburl"],
    favIcon: json["fav_icon"],
    faq: json["faq"],
    termConditions: json["term_conditions"],
    privacyPolicy: json["privacy_policy"],
    banner: json["banner"],
    menu5: json["menu5"],
    menu5Url: json["menu5_url"],
    facebookUrl: json["facebook_url"],
    instagramUrl: json["instagram_url"],
    youtubeUrl: json["youtube_url"],
    googleUrl: json["google_url"],
    twitterUrl: json["twitter_url"],
    tagline: json["tagline"],
    openTime: json["open_time"],
    closeTime: json["close_time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "featured_image": featuredImage,
    "address": address,
    "contact": contact,
    "weburl": weburl,
    "fav_icon": favIcon,
    "faq": faq,
    "term_conditions": termConditions,
    "privacy_policy": privacyPolicy,
    "banner": banner,
    "menu5": menu5,
    "menu5_url": menu5Url,
    "facebook_url": facebookUrl,
    "instagram_url": instagramUrl,
    "youtube_url": youtubeUrl,
    "google_url": googleUrl,
    "twitter_url": twitterUrl,
    "tagline": tagline,
    "open_time": openTime,
    "close_time": closeTime,
  };
}
