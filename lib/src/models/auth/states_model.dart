
import 'package:equatable/equatable.dart';

class StatesModel {
  StatesModel({
    this.status,
    this.results,
  });

  final String? status;
  final List<StateItem>? results;

  factory StatesModel.fromJson(Map<String, dynamic> json) => StatesModel(
    status: json["status"],
    results: json["results"] == null ? null : List<StateItem>.from(json["results"].map((x) => StateItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "results": results == null ? null : List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}

class StateItem extends Equatable{
  StateItem({
    this.id,
    this.state,
  });

  final String? id;
  final String? state;

  factory StateItem.fromJson(Map<String, dynamic> json) => StateItem(
    id: json["id"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "state": state,
  };

  @override
  List<String?> get props => [id, state];
}
