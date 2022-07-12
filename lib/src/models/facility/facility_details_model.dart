
class FacilityDetailsModel {
  FacilityDetailsModel({
    this.status,
    this.custname,
    this.facilityDetails,
  });

  final String? status;
  final String? custname;
  final TheFacilityDetails? facilityDetails;

  factory FacilityDetailsModel.fromJson(Map<String, dynamic> json) => FacilityDetailsModel(
    status: json["status"],
    custname: json["custname"],
    facilityDetails: (json["facility_details"] == null || json["facility_details"] is! Map<String, dynamic>) ? null : TheFacilityDetails.fromJson(json["facility_details"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "custname": custname,
    "facility_details": facilityDetails == null ? null : facilityDetails!.toJson(),
  };
}

class TheFacilityDetails {
  TheFacilityDetails({
    this.id,
    this.title,
    this.description,
    this.direction,
    this.featuredImage,
    this.featuredIcon,
    this.floor,
    this.floorUnit,
    this.floorName,
  });

  final String? id;
  final String? title;
  final String? description;
  final String? direction;
  final String? featuredImage;
  final String? featuredIcon;
  final String? floor;
  final String? floorUnit;
  final String? floorName;

  factory TheFacilityDetails.fromJson(Map<String, dynamic> json) => TheFacilityDetails(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    direction: json["direction"],
    featuredImage: json["featured_image"],
    featuredIcon: json["featured_icon"],
    floor: json["floor"],
    floorUnit: json["floor_unit"],
    floorName: json["floor_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "direction": direction,
    "featured_image": featuredImage,
    "featured_icon": featuredIcon,
    "floor": floor,
    "floor_unit": floorUnit,
    "floor_name": floorName,
  };
}
