class AddHolidayTypeModel {
  bool status;
  String message;
  HolidayType data;

  AddHolidayTypeModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AddHolidayTypeModel.fromJson(Map<String, dynamic> json) =>
      AddHolidayTypeModel(
        status: json["status"],
        message: json["message"],
        data: HolidayType.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class HolidayType {
  String name;
  String isMulti;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  HolidayType({
    required this.name,
    required this.isMulti,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory HolidayType.fromJson(Map<String, dynamic> json) => HolidayType(
        name: json["name"],
        isMulti: json["is_multi"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "is_multi": isMulti,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
