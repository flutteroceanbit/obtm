class GetReviewModel {
  bool status;
  String message;
  List<AllReviewData> data;

  GetReviewModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetReviewModel.fromJson(Map<String, dynamic> json) => GetReviewModel(
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
  String message;
  int rating;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  AllReviewData({
    required this.id,
    required this.userId,
    required this.message,
    required this.rating,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory AllReviewData.fromJson(Map<String, dynamic> json) => AllReviewData(
        id: json["id"],
        userId: json["user_id"],
        message: json["message"],
        rating: json["rating"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "message": message,
        "rating": rating,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
