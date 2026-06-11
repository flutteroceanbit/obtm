class GetQuoteModel {
  bool status;
  String message;
  List<QuoteData> data;

  GetQuoteModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetQuoteModel.fromJson(Map<String, dynamic> json) => GetQuoteModel(
        status: json["status"],
        message: json["message"],
        data: List<QuoteData>.from(
            json["data"].map((x) => QuoteData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class QuoteData {
  int id;
  int userId;
  String quotes;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  QuoteData({
    required this.id,
    required this.userId,
    required this.quotes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory QuoteData.fromJson(Map<String, dynamic> json) => QuoteData(
        id: json["id"],
        userId: json["user_id"],
        quotes: json["quotes"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "quotes": quotes,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
