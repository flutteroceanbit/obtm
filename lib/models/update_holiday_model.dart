class UpdateHolidayModel {
  bool status;
  String message;
  Data data;

  UpdateHolidayModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UpdateHolidayModel.fromJson(Map<String, dynamic> json) =>
      UpdateHolidayModel(
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
  int id;
  String holidayTypeId;
  String startDate;
  String endDate;
  int? days;
  String description;
  int isMulti;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  Data({
    required this.id,
    required this.holidayTypeId,
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.description,
    required this.isMulti,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        holidayTypeId: json["holiday_type_id"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        days: json["days"],
        description: json["description"],
        isMulti: json["is_multi"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "holiday_type_id": holidayTypeId,
        "start_date": startDate,
        "end_date": endDate,
        "days": days,
        "description": description,
        "is_multi": isMulti,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
