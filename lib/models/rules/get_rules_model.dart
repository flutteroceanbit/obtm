class GetRulesModel {
  bool status;
  String message;
  List<RulesData> data;

  GetRulesModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetRulesModel.fromJson(Map<String, dynamic> json) => GetRulesModel(
        status: json["status"],
        message: json["message"],
        data: List<RulesData>.from(
            json["data"].map((x) => RulesData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class RulesData {
  int id;
  int userId;
  String rule;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  RulesData({
    required this.id,
    required this.userId,
    required this.rule,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory RulesData.fromJson(Map<String, dynamic> json) => RulesData(
        id: json["id"],
        userId: json["user_id"],
        rule: json["rule"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "rule": rule,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
