class GetInventoryByIdModel {
  bool status;
  String message;
  Data data;

  GetInventoryByIdModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetInventoryByIdModel.fromJson(Map<String, dynamic> json) =>
      GetInventoryByIdModel(
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
  String inventoryName;
  String amount;
  String serialNo;
  DateTime purchaseDate;
  DateTime endWarrantyDate;
  int isWarranty;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  Data({
    required this.id,
    required this.userId,
    required this.inventoryName,
    required this.amount,
    required this.serialNo,
    required this.purchaseDate,
    required this.endWarrantyDate,
    required this.isWarranty,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["user_id"],
        inventoryName: json["inventory_name"],
        amount: json["amount"],
        serialNo: json["serial_no"],
        purchaseDate: DateTime.parse(json["purchase_date"]),
        endWarrantyDate: DateTime.parse(json["end_warranty_date"]),
        isWarranty: json["is_warranty"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "inventory_name": inventoryName,
        "amount": amount,
        "serial_no": serialNo,
        "purchase_date":
            "${purchaseDate.year.toString().padLeft(4, '0')}-${purchaseDate.month.toString().padLeft(2, '0')}-${purchaseDate.day.toString().padLeft(2, '0')}",
        "end_warranty_date":
            "${endWarrantyDate.year.toString().padLeft(4, '0')}-${endWarrantyDate.month.toString().padLeft(2, '0')}-${endWarrantyDate.day.toString().padLeft(2, '0')}",
        "is_warranty": isWarranty,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
