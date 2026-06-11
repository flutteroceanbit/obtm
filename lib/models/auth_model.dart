class AuthModel {
  bool status;
  String message;
  List<AuthData> data;
  String token;

  AuthModel({
    required this.status,
    required this.message,
    required this.data,
    required this.token,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        status: json["status"],
        message: json["message"],
        data:
            List<AuthData>.from(json["data"].map((x) => AuthData.fromJson(x))),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "token": token,
      };
}

class AuthData {
  User user;
  List<LeaveBalance> leaveBalances;

  AuthData({
    required this.user,
    required this.leaveBalances,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) => AuthData(
        user: User.fromJson(json["user"]),
        leaveBalances: List<LeaveBalance>.from(
            json["leave_balances"].map((x) => LeaveBalance.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "leave_balances":
            List<dynamic>.from(leaveBalances.map((x) => x.toJson())),
      };
}

class LeaveBalance {
  int id;
  int userId;
  double masterLeavesId;
  int totalLeaves;
  double usedLeaves;
  double remainingLeaves;
  String year;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  MasterLeave masterLeave;

  LeaveBalance({
    required this.id,
    required this.userId,
    required this.masterLeavesId,
    required this.totalLeaves,
    required this.usedLeaves,
    required this.remainingLeaves,
    required this.year,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.masterLeave,
  });

  factory LeaveBalance.fromJson(Map<String, dynamic> json) => LeaveBalance(
        id: json["id"],
        userId: json["user_id"],
        masterLeavesId: double.parse(json["master_leaves_id"].toString()),
        totalLeaves: json["total_leaves"],
        usedLeaves: double.parse(json["used_leaves"].toString()),
        remainingLeaves: double.parse(json["remaining_leaves"].toString()),
        year: json["year"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        masterLeave: MasterLeave.fromJson(json["master_leave"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "master_leaves_id": masterLeavesId,
        "total_leaves": totalLeaves,
        "used_leaves": usedLeaves,
        "remaining_leaves": remainingLeaves,
        "year": year,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "master_leave": masterLeave.toJson(),
      };
}

class MasterLeave {
  int id;
  String name;
  String shortName;
  int value;
  DateTime createdAt;
  DateTime updatedAt;

  MasterLeave({
    required this.id,
    required this.name,
    required this.shortName,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MasterLeave.fromJson(Map<String, dynamic> json) => MasterLeave(
        id: json["id"],
        name: json["name"],
        shortName: json["short_name"],
        value: json["value"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "short_name": shortName,
        "value": value,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class User {
  int id;
  String firstName;
  String lastName;
  String employeeId;
  String email;
  String phone;
  dynamic alterPhone;
  String imageUrl;
  dynamic docUrl;
  bool isAdmin;
  bool isPhoneVerified;
  bool isEmailVerified;
  String? startTime;
  int? isActive;
  dynamic emailVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;
  int recordDeleted;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.employeeId,
    required this.email,
    required this.phone,
    required this.alterPhone,
    required this.imageUrl,
    required this.docUrl,
    required this.isAdmin,
    required this.isPhoneVerified,
    required this.isEmailVerified,
    required this.startTime,
    required this.isActive,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.recordDeleted,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        employeeId: json["employee_id"],
        email: json["email"],
        phone: json["phone"],
        alterPhone: json["alter_phone"],
        imageUrl: json["image_url"],
        docUrl: json["doc_url"],
        isAdmin: json["is_admin"],
        isPhoneVerified: json["is_phone_verified"],
        isEmailVerified: json["is_email_verified"],
        startTime: json["start_time"],
        isActive: json["is_active"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        recordDeleted: json["record_deleted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "employee_id": employeeId,
        "email": email,
        "phone": phone,
        "alter_phone": alterPhone,
        "image_url": imageUrl,
        "doc_url": docUrl,
        "is_admin": isAdmin,
        "is_phone_verified": isPhoneVerified,
        "is_email_verified": isEmailVerified,
        "start_time": startTime,
        "is_active": isActive,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "record_deleted": recordDeleted,
      };
}
