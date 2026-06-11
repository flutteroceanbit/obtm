class GetInventoryModel {
  bool status;
  String message;
  List<InventoryData> data;

  GetInventoryModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetInventoryModel.fromJson(Map<String, dynamic> json) =>
      GetInventoryModel(
        status: json["status"],
        message: json["message"],
        data: List<InventoryData>.from(
            json["data"].map((x) => InventoryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class InventoryData {
  int id;
  int userId;
  String inventoryName;
  String amount;
  String serialNo;
  DateTime purchaseDate;
  DateTime? endWarrantyDate;
  int isWarranty;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  InventoryData({
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

  factory InventoryData.fromJson(Map<String, dynamic> json) => InventoryData(
        id: json["id"],
        userId: json["user_id"],
        inventoryName: json["inventory_name"],
        amount: json["amount"],
        serialNo: json["serial_no"],
        purchaseDate: DateTime.parse(json["purchase_date"]),
        endWarrantyDate: json["end_warranty_date"] == null
            ? null
            : DateTime.parse(json["end_warranty_date"]),
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
            "${endWarrantyDate!.year.toString().padLeft(4, '0')}-${endWarrantyDate!.month.toString().padLeft(2, '0')}-${endWarrantyDate!.day.toString().padLeft(2, '0')}",
        "is_warranty": isWarranty,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
