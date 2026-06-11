class UpdateLeaveModel {
  bool status;
  String message;
  Data data;

  UpdateLeaveModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UpdateLeaveModel.fromJson(Map<String, dynamic> json) =>
      UpdateLeaveModel(
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
  int userId;
  String startDate;
  String endDate;
  String reason;
  int leaveValue;
  int leaveId;
  int leaveStatusValue;
  int leaveStatusId;
  int leaveTypeValue;
  int leaveTypeId;
  double count;
  int updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  Data({
    required this.id,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.leaveValue,
    required this.leaveId,
    required this.leaveStatusValue,
    required this.leaveStatusId,
    required this.leaveTypeValue,
    required this.leaveTypeId,
    required this.count,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["user_id"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        reason: json["reason"],
        leaveValue: json["leave_value"],
        leaveId: json["leave_id"],
        leaveStatusValue: json["leave_status_value"],
        leaveStatusId: json["leave_status_id"],
        leaveTypeValue: json["leave_type_value"],
        leaveTypeId: json["leave_type_id"],
        count: json["count"]?.toDouble(),
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "start_date": startDate,
        "end_date": endDate,
        "reason": reason,
        "leave_value": leaveValue,
        "leave_id": leaveId,
        "leave_status_value": leaveStatusValue,
        "leave_status_id": leaveStatusId,
        "leave_type_value": leaveTypeValue,
        "leave_type_id": leaveTypeId,
        "count": count,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
