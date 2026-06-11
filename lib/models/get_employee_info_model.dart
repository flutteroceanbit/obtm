class GetEmployeeInfoModel {
  bool status;
  String message;
  List<EmployeeInfoData> data;

  GetEmployeeInfoModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetEmployeeInfoModel.fromJson(Map<String, dynamic> json) =>
      GetEmployeeInfoModel(
        status: json["status"],
        message: json["message"],
        data: List<EmployeeInfoData>.from(
            json["data"].map((x) => EmployeeInfoData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class EmployeeInfoData {
  int id;
  int userId;
  int departmentId;
  int designationId;
  String startDate;
  String? endDate;
  int period;
  int basicSalary;
  int hra;
  int da;
  int ta;
  int securityDeposit;
  int monthlySecurityDeposit;
  int bonusOne;
  int bonusTwo;
  String? minimumFullTime;
  String? minimumHalfTime;
  String? workFullTime;
  String? workHalfTime;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  User user;
  Department? department;
  Department designation;

  EmployeeInfoData({
    required this.id,
    required this.userId,
    required this.departmentId,
    required this.designationId,
    required this.startDate,
    required this.endDate,
    required this.period,
    required this.basicSalary,
    required this.hra,
    required this.da,
    required this.ta,
    required this.securityDeposit,
    required this.monthlySecurityDeposit,
    required this.bonusOne,
    required this.bonusTwo,
    required this.minimumFullTime,
    required this.minimumHalfTime,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.user,
    required this.department,
    required this.designation,
    required this.workFullTime,
    required this.workHalfTime,
  });

  factory EmployeeInfoData.fromJson(Map<String, dynamic> json) =>
      EmployeeInfoData(
        id: json["id"],
        userId: json["user_id"],
        departmentId: json["department_id"],
        designationId: json["designation_id"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        period: json["period"],
        basicSalary: json["basic_salary"],
        hra: json["HRA"],
        da: json["DA"],
        ta: json["TA"],
        securityDeposit: json["security_deposit"],
        monthlySecurityDeposit: json["monthly_security_deposit"],
        bonusOne: json["bonus_one"],
        bonusTwo: json["bonus_two"],
        minimumFullTime: json["minimum_full_time"],
        minimumHalfTime: json["minimum_half_time"],
        workFullTime: json["work_full_time"],
        workHalfTime: json["work_half_time"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        user: User.fromJson(json["user"]),
        department: json["department"] != null
            ? Department.fromJson(json["department"])
            : null,
        designation: Department.fromJson(json["designation"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "department_id": departmentId,
        "designation_id": designationId,
        "start_date": startDate,
        "end_date": endDate!,
        "period": period,
        "basic_salary": basicSalary,
        "HRA": hra,
        "DA": da,
        "TA": ta,
        "security_deposit": securityDeposit,
        "monthly_security_deposit": monthlySecurityDeposit,
        "bonus_one": bonusOne,
        "bonus_two": bonusTwo,
        "minimum_full_time": minimumFullTime,
        "minimum_half_time": minimumHalfTime,
        "work_full_time": workFullTime,
        "work_half_time": workHalfTime,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "user": user.toJson(),
        "department": department?.toJson(),
        "designation": designation.toJson(),
      };
}

class Department {
  int id;
  String name;
  String isActive;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  String? shortName;

  Department({
    required this.id,
    required this.name,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    this.shortName,
  });

  factory Department.fromJson(Map<String, dynamic> json) => Department(
        id: json["id"],
        name: json["name"],
        isActive: json["is_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        shortName: json["short_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "short_name": shortName,
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
