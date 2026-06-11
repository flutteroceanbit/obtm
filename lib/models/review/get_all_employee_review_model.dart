class GetAllEmployeeReviewModel {
  bool status;
  String message;
  List<AllReviewData> data;

  GetAllEmployeeReviewModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetAllEmployeeReviewModel.fromJson(Map<String, dynamic> json) =>
      GetAllEmployeeReviewModel(
        status: json["status"],
        message: json["message"],
        data: List<AllReviewData>.from(
            json["data"].map((x) => AllReviewData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class AllReviewData {
  int id;
  int userId;
  int dailyReportsId;
  String? remarks;
  int officeArrival;
  int socialMedia;
  int workHours;
  int taskCompletion;
  int behavior;
  int starRating;
  int? reviewedBy;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  User user;
  DailyReports dailyReports;

  AllReviewData({
    required this.id,
    required this.userId,
    required this.dailyReportsId,
    required this.remarks,
    required this.officeArrival,
    required this.socialMedia,
    required this.workHours,
    required this.taskCompletion,
    required this.behavior,
    required this.starRating,
    required this.reviewedBy,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.user,
    required this.dailyReports,
  });

  factory AllReviewData.fromJson(Map<String, dynamic> json) => AllReviewData(
        id: json["id"],
        userId: json["user_id"],
        dailyReportsId: json["daily_reports_id"],
        remarks: json["remarks"],
        officeArrival: json["office_arrival"],
        socialMedia: json["social_media"],
        workHours: json["work_hours"],
        taskCompletion: json["task_completion"],
        behavior: json["behavior"],
        starRating: json["star_rating"],
        reviewedBy: json["reviewed_by"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        user: User.fromJson(json["user"]),
        dailyReports: DailyReports.fromJson(json["daily_reports"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "daily_reports_id": dailyReportsId,
        "remarks": remarks,
        "office_arrival": officeArrival,
        "social_media": socialMedia,
        "work_hours": workHours,
        "task_completion": taskCompletion,
        "behavior": behavior,
        "star_rating": starRating,
        "reviewed_by": reviewedBy,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "user": user.toJson(),
        "daily_reports": dailyReports.toJson(),
      };
}

class DailyReports {
  int id;
  DateTime date;
  String totalTime;
  String intermediateTime;
  String reportText;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;

  DailyReports({
    required this.id,
    required this.date,
    required this.totalTime,
    required this.intermediateTime,
    required this.reportText,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DailyReports.fromJson(Map<String, dynamic> json) => DailyReports(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        totalTime: json["total_time"],
        intermediateTime: json["intermediate_time"],
        reportText: json["report_text"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "total_time": totalTime,
        "intermediate_time": intermediateTime,
        "report_text": reportText,
        "user_id": userId,
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
  String? alterPhone;
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
