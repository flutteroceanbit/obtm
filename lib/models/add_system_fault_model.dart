class AddSystemFaultModel {
  bool status;
  String message;
  Data data;

  AddSystemFaultModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AddSystemFaultModel.fromJson(Map<String, dynamic> json) =>
      AddSystemFaultModel(
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
  int userId;
  String systemType;
  String description;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  Data({
    required this.userId,
    required this.systemType,
    required this.description,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        systemType: json["system_type"],
        description: json["description"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "system_type": systemType,
        "description": description,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
