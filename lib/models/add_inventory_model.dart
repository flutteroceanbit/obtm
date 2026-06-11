class AddInventoryModel {
  bool status;
  String message;
  Data data;

  AddInventoryModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AddInventoryModel.fromJson(Map<String, dynamic> json) =>
      AddInventoryModel(
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
  String inventoryName;
  String amount;
  String serialNo;
  DateTime purchaseDate;
  DateTime? endWarrantyDate;
  int userId;
  int isWarranty;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  Data({
    required this.inventoryName,
    required this.amount,
    required this.serialNo,
    required this.purchaseDate,
    required this.endWarrantyDate,
    required this.userId,
    required this.isWarranty,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        inventoryName: json["inventory_name"],
        amount: json["amount"],
        serialNo: json["serial_no"],
        purchaseDate: DateTime.parse(json["purchase_date"]),
        endWarrantyDate: json["isWarranty"] == 1
            ? DateTime.parse(json["end_warranty_date"])
            : null,
        userId: json["user_id"],
        isWarranty: json["is_warranty"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "inventory_name": inventoryName,
        "amount": amount,
        "serial_no": serialNo,
        "purchase_date":
            "${purchaseDate.year.toString().padLeft(4, '0')}-${purchaseDate.month.toString().padLeft(2, '0')}-${purchaseDate.day.toString().padLeft(2, '0')}",
        "end_warranty_date":
            "${endWarrantyDate?.year.toString().padLeft(4, '0')}-${endWarrantyDate?.month.toString().padLeft(2, '0')}-${endWarrantyDate?.day.toString().padLeft(2, '0')}",
        "user_id": userId,
        "is_warranty": isWarranty,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
