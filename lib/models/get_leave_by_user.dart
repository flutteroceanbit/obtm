import 'package:oceanbit_timeclock/models/user_leave_model.dart';

class LeaveByUserModel {
  bool status;
  String message;
  int currentPage;
  List<LeaveDataByUser> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;
  List<LeaveBalance?> leaveBalances;

  LeaveByUserModel({
    required this.status,
    required this.message,
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
    required this.leaveBalances,
  });

  factory LeaveByUserModel.fromJson(Map<String, dynamic> json) =>
      LeaveByUserModel(
        status: json["status"],
        message: json["message"],
        currentPage: json["current_page"],
        data: List<LeaveDataByUser>.from(
            json["data"].map((x) => LeaveDataByUser.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"] ?? 0,
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"] ?? 0,
        total: json["total"],
        leaveBalances: List<LeaveBalance>.from(
            json["leave_balances"].map((x) => LeaveBalance.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
        "leave_balances": LeaveBalance,
      };
}

class LeaveDataByUser {
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
  LeaveJson leave;
  LeaveJson leaveStatus;
  LeaveJson leaveType;
  User user;

  LeaveDataByUser({
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
    required this.leave,
    required this.leaveStatus,
    required this.leaveType,
    required this.user,
  });

  factory LeaveDataByUser.fromJson(Map<String, dynamic> json) =>
      LeaveDataByUser(
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
        leave: LeaveJson.fromJson(json["leave"]),
        leaveStatus: LeaveJson.fromJson(json["leave_status"]),
        leaveType: LeaveJson.fromJson(json["leave_type"]),
        user: User.fromJson(json["user"]),
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
        "leave": leave.toJson(),
        "leave_status": leaveStatus.toJson(),
        "leave_type": leaveType.toJson(),
        "user": user.toJson(),
      };
}

class LeaveJson {
  int id;
  String name;
  String? shortName;
  int value;
  DateTime createdAt;
  DateTime updatedAt;
  double? count;

  LeaveJson({
    required this.id,
    required this.name,
    this.shortName,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
    this.count,
  });

  factory LeaveJson.fromJson(Map<String, dynamic> json) => LeaveJson(
        id: json["id"],
        name: json["name"],
        shortName: json["short_name"],
        value: json["value"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        count: json["count"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "short_name": shortName,
        "value": value,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "count": count,
      };
}

class User {
  int id;
  String firstName;
  String lastName;
  String employeeId;
  String imageUrl;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.employeeId,
    required this.imageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        employeeId: json["employee_id"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "employee_id": employeeId,
        "image_url": imageUrl,
      };
}

class Link {
  String? url;
  String label;
  bool active;

  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
