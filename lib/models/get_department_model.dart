class GetDepartmentModel {
  bool status;
  String message;
  List<DepartmentData> data;

  GetDepartmentModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetDepartmentModel.fromJson(Map<String, dynamic> json) =>
      GetDepartmentModel(
        status: json["status"],
        message: json["message"],
        data: List<DepartmentData>.from(
            json["data"].map((x) => DepartmentData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DepartmentData {
  int id;
  String name;
  String isActive;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  DepartmentData({
    required this.id,
    required this.name,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory DepartmentData.fromJson(Map<String, dynamic> json) => DepartmentData(
        id: json["id"],
        name: json["name"],
        isActive: json["is_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
