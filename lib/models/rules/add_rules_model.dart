class AddRulesModel {
  bool status;
  String message;
  Data data;

  AddRulesModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AddRulesModel.fromJson(Map<String, dynamic> json) => AddRulesModel(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  String rule;
  int userId;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  Data({
    required this.rule,
    required this.userId,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        rule: json["rule"],
        userId: json["user_id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "rule": rule,
        "user_id": userId,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
