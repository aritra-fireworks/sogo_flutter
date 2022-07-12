
class TransactionDetailsModel {
  TransactionDetailsModel({
    this.name,
    this.date,
    this.code,
    this.custid,
    this.custname,
    this.points,
    this.type,
    this.status,
    this.cashSpent,
    this.pointSpent,
    this.img,
    this.mall,
    this.remarks,
    this.receiptNo,
  });

  final String? name;
  final String? date;
  final String? code;
  final String? custid;
  final String? custname;
  final String? points;
  final String? type;
  final String? status;
  final String? cashSpent;
  final String? pointSpent;
  final String? img;
  final dynamic mall;
  final String? remarks;
  final String? receiptNo;

  factory TransactionDetailsModel.fromJson(Map<String, dynamic> json) => TransactionDetailsModel(
    name: json["name"],
    date: json["date"],
    code: json["code"],
    custid: json["custid"],
    custname: json["custname"],
    points: json["points"],
    type: json["type"],
    status: json["status"],
    cashSpent: json["cash_spent"],
    pointSpent: json["point_spent"],
    img: json["img"],
    mall: json["mall"],
    remarks: json["remarks"],
    receiptNo: json["receipt_no"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "date": date,
    "code": code,
    "custid": custid,
    "custname": custname,
    "points": points,
    "type": type,
    "status": status,
    "cash_spent": cashSpent,
    "point_spent": pointSpent,
    "img": img,
    "mall": mall,
    "remarks": remarks,
    "receipt_no": receiptNo,
  };
}
