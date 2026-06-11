class AddReviewModel {
  bool status;
  String message;
  List<Datum> data;

  AddReviewModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AddReviewModel.fromJson(Map<String, dynamic> json) => AddReviewModel(
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
  int dailyReportsId;
  String remarks;
  int officeArrival;
  int socialMedia;
  int workHours;
  int taskCompletion;
  int behavior;
  int starRating;
  int reviewedBy;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  Datum({
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
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
      };
}
