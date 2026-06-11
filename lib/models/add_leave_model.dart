class AddLeaveModel {
  bool status;
  String message;
  Data data;

  AddLeaveModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AddLeaveModel.fromJson(Map<String, dynamic> json) => AddLeaveModel(
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
  LeaveRequest leaveRequest;
  List<dynamic> leaveBalance;

  Data({
    required this.leaveRequest,
    required this.leaveBalance,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        leaveRequest: LeaveRequest.fromJson(json["leave_request"]),
        leaveBalance: List<dynamic>.from(json["leave_balance"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "leave_request": leaveRequest.toJson(),
        "leave_balance": List<dynamic>.from(leaveBalance.map((x) => x)),
      };
}

class LeaveRequest {
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
  List<LeaveDay> leaveDays;

  LeaveRequest({
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
    required this.leaveDays,
  });

  factory LeaveRequest.fromJson(Map<String, dynamic> json) => LeaveRequest(
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
        leaveDays: List<LeaveDay>.from(
            json["leave_days"].map((x) => LeaveDay.fromJson(x))),
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
        "leave_days": List<dynamic>.from(leaveDays.map((x) => x.toJson())),
      };
}

class LeaveDay {
  int id;
  int userId;
  int leaveRequestId;
  String date;
  int leaveStatusValue;
  double count;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  LeaveDay({
    required this.id,
    required this.userId,
    required this.leaveRequestId,
    required this.date,
    required this.leaveStatusValue,
    required this.count,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory LeaveDay.fromJson(Map<String, dynamic> json) => LeaveDay(
        id: json["id"],
        userId: json["user_id"],
        leaveRequestId: json["leave_request_id"],
        date: json["date"],
        leaveStatusValue: json["leave_status_value"],
        count: json["count"]?.toDouble(),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "leave_request_id": leaveRequestId,
        "date": date,
        "leave_status_value": leaveStatusValue,
        "count": count,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
