class GetDesignationModel {
  bool status;
  String message;
  List<DesignationData> data;

  GetDesignationModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetDesignationModel.fromJson(Map<String, dynamic> json) =>
      GetDesignationModel(
        status: json["status"],
        message: json["message"],
        data: List<DesignationData>.from(
            json["data"].map((x) => DesignationData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DesignationData {
  int id;
  String name;
  String shortName;
  String isActive;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  DesignationData({
    required this.id,
    required this.name,
    required this.shortName,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory DesignationData.fromJson(Map<String, dynamic> json) =>
      DesignationData(
        id: json["id"],
        name: json["name"],
        shortName: json["short_name"],
        isActive: json["is_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "short_name": shortName,
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
