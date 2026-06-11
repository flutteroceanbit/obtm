class AddQuoteModel {
  bool status;
  String message;
  Data data;

  AddQuoteModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AddQuoteModel.fromJson(Map<String, dynamic> json) => AddQuoteModel(
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
  String quotes;
  int userId;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  Data({
    required this.quotes,
    required this.userId,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        quotes: json["quotes"],
        userId: json["user_id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "quotes": quotes,
        "user_id": userId,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
