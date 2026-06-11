class UpdateKnowledgeModel {
  bool status;
  String message;
  Data data;

  UpdateKnowledgeModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UpdateKnowledgeModel.fromJson(Map<String, dynamic> json) =>
      UpdateKnowledgeModel(
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
  String title;
  String link;
  String description;
  String language;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  Data({
    required this.id,
    required this.userId,
    required this.title,
    required this.link,
    required this.description,
    required this.language,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["user_id"],
        title: json["title"],
        link: json["link"],
        description: json["description"],
        language: json["language"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "title": title,
        "link": link,
        "description": description,
        "language": language,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
