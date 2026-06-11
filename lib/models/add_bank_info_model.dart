class AddBankInfoModel {
  bool status;
  String message;
  Data data;

  AddBankInfoModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AddBankInfoModel.fromJson(Map<String, dynamic> json) =>
      AddBankInfoModel(
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
  String bankName;
  String branch;
  String accountNo;
  String accountType;
  String ifscCode;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  Data({
    required this.userId,
    required this.bankName,
    required this.branch,
    required this.accountNo,
    required this.accountType,
    required this.ifscCode,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        bankName: json["bank_name"],
        branch: json["branch"],
        accountNo: json["account_no"],
        accountType: json["account_type"],
        ifscCode: json["ifsc_code"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "bank_name": bankName,
        "branch": branch,
        "account_no": accountNo,
        "account_type": accountType,
        "ifsc_code": ifscCode,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
