
class RewardCategoryListModel {
  RewardCategoryListModel({
    this.status,
    this.category,
  });

  final String? status;
  final List<Category>? category;

  factory RewardCategoryListModel.fromJson(Map<String, dynamic> json) => RewardCategoryListModel(
    status: json["status"],
    category: json["category"] == null ? null : List<Category>.from(json["category"].map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "category": category == null ? null : List<dynamic>.from(category!.map((x) => x.toJson())),
  };
}

class Category {
  Category({
    this.categoryId,
    this.category,
    this.categoryImg,
  });

  final String? categoryId;
  final String? category;
  final String? categoryImg;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    categoryId: json["category_id"],
    category: json["category"],
    categoryImg: json["category_img"],
  );

  Map<String, dynamic> toJson() => {
    "category_id": categoryId,
    "category": category,
    "category_img": categoryImg,
  };
}
