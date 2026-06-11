class LeaveModel {
  bool status;
  String message;
  int currentPage;
  List<LeaveData> data;
  String firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link> links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int total;

  LeaveModel({
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
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) => LeaveModel(
        status: json["status"],
        message: json["message"],
        currentPage: json["current_page"],
        data: List<LeaveData>.from(
            json["data"].map((x) => LeaveData.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
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
      };
}

class LeaveData {
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
  double leaveDaysCount;
  int updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  Leave leave;
  Leave leaveStatus;
  Leave leaveType;
  User user;

  LeaveData({
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
    required this.leaveDaysCount,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.leave,
    required this.leaveStatus,
    required this.leaveType,
    required this.user,
  });

  factory LeaveData.fromJson(Map<String, dynamic> json) => LeaveData(
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
        leaveDaysCount: json["leave_days_count"]?.toDouble(),
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        leave: Leave.fromJson(json["leave"]),
        leaveStatus: Leave.fromJson(json["leave_status"]),
        leaveType: Leave.fromJson(json["leave_type"]),
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
        "leave_days_count": leaveDaysCount,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "leave": leave.toJson(),
        "leave_status": leaveStatus.toJson(),
        "leave_type": leaveType.toJson(),
        "user": user.toJson(),
      };
}

class Leave {
  int id;
  String name;
  String? shortName;
  int value;
  DateTime createdAt;
  DateTime updatedAt;
  double? count;

  Leave({
    required this.id,
    required this.name,
    this.shortName,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
    this.count,
  });

  factory Leave.fromJson(Map<String, dynamic> json) => Leave(
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
