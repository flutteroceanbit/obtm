class GetSystemFaultModel {
  bool status;
  String message;
  List<Datum> data;

  GetSystemFaultModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetSystemFaultModel.fromJson(Map<String, dynamic> json) =>
      GetSystemFaultModel(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  int userId;
  String systemType;
  String description;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  User user;

  Datum({
    required this.id,
    required this.userId,
    required this.systemType,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.user,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        systemType: json["system_type"],
        description: json["description"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "system_type": systemType,
        "description": description,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "user": user.toJson(),
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
  String startTime;
  int isActive;
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
