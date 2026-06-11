class AddKnowledgeModel {
  bool status;
  String message;
  Data data;

  AddKnowledgeModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AddKnowledgeModel.fromJson(Map<String, dynamic> json) =>
      AddKnowledgeModel(
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
  String userId;
  String title;
  String link;
  String description;
  String language;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  Data({
    required this.userId,
    required this.title,
    required this.link,
    required this.description,
    required this.language,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        title: json["title"],
        link: json["link"],
        description: json["description"],
        language: json["language"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "title": title,
        "link": link,
        "description": description,
        "language": language,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
