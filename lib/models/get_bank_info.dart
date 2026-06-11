class GetBankInfoModel {
  bool status;
  String message;
  BankInfoData data;

  GetBankInfoModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetBankInfoModel.fromJson(Map<String, dynamic> json) =>
      GetBankInfoModel(
        status: json["status"],
        message: json["message"],
        data: BankInfoData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class BankInfoData {
  int id;
  int userId;
  String bankName;
  String branch;
  String accountNo;
  String accountType;
  String ifscCode;
  DateTime createdAt;
  DateTime updatedAt;

  BankInfoData({
    required this.id,
    required this.userId,
    required this.bankName,
    required this.branch,
    required this.accountNo,
    required this.accountType,
    required this.ifscCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BankInfoData.fromJson(Map<String, dynamic> json) => BankInfoData(
        id: json["id"],
        userId: json["user_id"],
        bankName: json["bank_name"],
        branch: json["branch"],
        accountNo: json["account_no"],
        accountType: json["account_type"],
        ifscCode: json["ifsc_code"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "bank_name": bankName,
        "branch": branch,
        "account_no": accountNo,
        "account_type": accountType,
        "ifsc_code": ifscCode,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
