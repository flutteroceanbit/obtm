class UpdateHolidayTypeModel {
  bool status;
  String message;
  UpdateHolidayType data;

  UpdateHolidayTypeModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UpdateHolidayTypeModel.fromJson(Map<String, dynamic> json) =>
      UpdateHolidayTypeModel(
        status: json["status"],
        message: json["message"],
        data: UpdateHolidayType.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class UpdateHolidayType {
  int id;
  String name;
  String isMulti;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  UpdateHolidayType({
    required this.id,
    required this.name,
    required this.isMulti,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UpdateHolidayType.fromJson(Map<String, dynamic> json) =>
      UpdateHolidayType(
        id: json["id"],
        name: json["name"],
        isMulti: json["is_multi"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "is_multi": isMulti,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
