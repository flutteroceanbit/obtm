class HolidayModel {
  bool status;
  String message;
  List<HolidayData> data;

  HolidayModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory HolidayModel.fromJson(Map<String, dynamic> json) => HolidayModel(
        status: json["status"],
        message: json["message"],
        data: List<HolidayData>.from(
            json["data"].map((x) => HolidayData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class HolidayData {
  int id;
  int holidayTypeId;
  DateTime startDate;
  DateTime endDate;
  int? days;
  String description;
  int isMulti;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  HolidayType holidayType;
  List<HolidayDate> holidayDates;

  HolidayData({
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
    required this.holidayType,
    required this.holidayDates,
  });

  factory HolidayData.fromJson(Map<String, dynamic> json) => HolidayData(
        id: json["id"],
        holidayTypeId: json["holiday_type_id"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        days: json["days"],
        description: json["description"],
        isMulti: json["is_multi"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        holidayType: HolidayType.fromJson(json["holiday_type"]),
        holidayDates: List<HolidayDate>.from(
            json["holiday_dates"].map((x) => HolidayDate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "holiday_type_id": holidayTypeId,
        "start_date":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "days": days,
        "description": description,
        "is_multi": isMulti,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "holiday_type": holidayType.toJson(),
        "holiday_dates":
            List<dynamic>.from(holidayDates.map((x) => x.toJson())),
      };
}

class HolidayDate {
  int id;
  int holidayId;
  DateTime date;
  int isSunday;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  HolidayDate({
    required this.id,
    required this.holidayId,
    required this.date,
    required this.isSunday,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HolidayDate.fromJson(Map<String, dynamic> json) => HolidayDate(
        id: json["id"],
        holidayId: json["holiday_id"],
        date: DateTime.parse(json["date"]),
        isSunday: json["is_sunday"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "holiday_id": holidayId,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "is_sunday": isSunday,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class HolidayType {
  int id;
  String name;
  int isMulti;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  HolidayType({
    required this.id,
    required this.name,
    required this.isMulti,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HolidayType.fromJson(Map<String, dynamic> json) => HolidayType(
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
