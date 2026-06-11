class AddHolidayModel {
  bool status;
  String message;
  Holidays data;

  AddHolidayModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AddHolidayModel.fromJson(Map<String, dynamic> json) =>
      AddHolidayModel(
        status: json["status"],
        message: json["message"],
        data: Holidays.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Holidays {
  String holidayTypeId;
  DateTime startDate;
  DateTime endDate;
  String description;
  int isMulti;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  Holidays({
    required this.holidayTypeId,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.isMulti,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Holidays.fromJson(Map<String, dynamic> json) => Holidays(
        holidayTypeId: json["holiday_type_id"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        description: json["description"],
        isMulti: json["is_multi"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "holiday_type_id": holidayTypeId,
        "start_date":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "description": description,
        "is_multi": isMulti,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
