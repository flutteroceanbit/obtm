class GetTransportModel {
  bool status;
  String message;
  TransportData data;

  GetTransportModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetTransportModel.fromJson(Map<String, dynamic> json) =>
      GetTransportModel(
        status: json["status"],
        message: json["message"],
        data: TransportData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class TransportData {
  int id;
  int userId;
  String transportName;
  String transportNumber;
  String rcBook;
  DateTime createdAt;
  DateTime updatedAt;

  TransportData({
    required this.id,
    required this.userId,
    required this.transportName,
    required this.transportNumber,
    required this.rcBook,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransportData.fromJson(Map<String, dynamic> json) => TransportData(
        id: json["id"],
        userId: json["user_id"],
        transportName: json["transport_name"],
        transportNumber: json["transport_number"],
        rcBook: json["rc_book"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "transport_name": transportName,
        "transport_number": transportNumber,
        "rc_book": rcBook,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
