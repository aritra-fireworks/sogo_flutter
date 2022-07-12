// To parse this JSON data, do
//
//     final transactionHistoryModel = transactionHistoryModelFromJson(jsonString);

import 'dart:convert';

TransactionHistoryModel transactionHistoryModelFromJson(String str) => TransactionHistoryModel.fromJson(json.decode(str));

String transactionHistoryModelToJson(TransactionHistoryModel data) => json.encode(data.toJson());

class TransactionHistoryModel {
  TransactionHistoryModel({
    this.page,
    this.start,
    this.end,
    this.result,
  });

  final int? page;
  final int? start;
  final int? end;
  final List<TransactionResult>? result;

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> json) => TransactionHistoryModel(
    page: json["page"],
    start: json["start"],
    end: json["end"],
    result: json["result"] == null ? null : List<TransactionResult>.from(json["result"].map((x) => TransactionResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "start": start,
    "end": end,
    "result": result == null ? null : List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class TransactionResult {
  TransactionResult({
    this.month,
    this.data,
  });

  final String? month;
  final List<TransactionDatum>? data;

  factory TransactionResult.fromJson(Map<String, dynamic> json) => TransactionResult(
    month: json["month"],
    data: json["data"] == null ? null : List<TransactionDatum>.from(json["data"].map((x) => TransactionDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "month": month,
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class TransactionDatum {
  TransactionDatum({
    this.transactionId,
    this.type,
    this.status,
    this.purchaseValue,
    this.id,
    this.custid,
    this.name,
    this.merchantTitle,
    this.date,
    this.expiredDate,
    this.timestamp,
    this.date2,
    this.month,
    this.year,
    this.points,
    this.cashSpent,
    this.pointSpent,
    this.mY,
  });

  final String? transactionId;
  final String? type;
  final String? status;
  final String? purchaseValue;
  final String? id;
  final String? custid;
  final String? name;
  final String? merchantTitle;
  final DateTime? date;
  final DateTime? expiredDate;
  final int? timestamp;
  final String? date2;
  final String? month;
  final String? year;
  final String? points;
  final String? cashSpent;
  final String? pointSpent;
  final String? mY;

  factory TransactionDatum.fromJson(Map<String, dynamic> json) => TransactionDatum(
    transactionId: json["transaction_id"],
    type: json["type"],
    status: json["status"],
    purchaseValue: json["purchase_value"],
    id: json["id"],
    custid: json["custid"],
    name: json["name"],
    merchantTitle: json["merchant_title"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    expiredDate: json["expired_date"] == null ? null : DateTime.parse(json["expired_date"]),
    timestamp: json["timestamp"],
    date2: json["date2"],
    month: json["month"],
    year: json["year"],
    points: json["points"],
    cashSpent: json["cash_spent"],
    pointSpent: json["point_spent"],
    mY: json["m_y"],
  );

  Map<String, dynamic> toJson() => {
    "transaction_id": transactionId,
    "type": type,
    "status": status,
    "purchase_value": purchaseValue,
    "id": id,
    "custid": custid,
    "name": name,
    "merchant_title": merchantTitle,
    "date": date == null ? null : date!.toIso8601String(),
    "expired_date": expiredDate == null ? null : expiredDate!.toIso8601String(),
    "timestamp": timestamp,
    "date2": date2,
    "month": month,
    "year": year,
    "points": points,
    "cash_spent": cashSpent,
    "point_spent": pointSpent,
    "m_y": mY,
  };
}
