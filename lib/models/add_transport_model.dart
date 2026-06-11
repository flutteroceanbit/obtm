class AddTransportModel {
  bool status;
  String message;
  Data data;
  String url;

  AddTransportModel({
    required this.status,
    required this.message,
    required this.data,
    required this.url,
  });

  factory AddTransportModel.fromJson(Map<String, dynamic> json) =>
      AddTransportModel(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
        "url": url,
      };
}

class Data {
  String userId;
  String transportName;
  String transportNumber;
  String rcBook;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  Data({
    required this.userId,
    required this.transportName,
    required this.transportNumber,
    required this.rcBook,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        transportName: json["transport_name"],
        transportNumber: json["transport_number"],
        rcBook: json["rc_book"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "transport_name": transportName,
        "transport_number": transportNumber,
        "rc_book": rcBook,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
