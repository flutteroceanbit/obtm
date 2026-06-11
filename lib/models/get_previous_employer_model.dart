class GetPreviousEmployerModel {
  bool status;
  String message;
  PreviousEmployerData data;

  GetPreviousEmployerModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetPreviousEmployerModel.fromJson(Map<String, dynamic> json) =>
      GetPreviousEmployerModel(
        status: json["status"],
        message: json["message"],
        data: PreviousEmployerData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class PreviousEmployerData {
  int id;
  int userId;
  String companyName;
  String profileDesignation;
  int salaryPerYear;
  String companyMail;
  String companyWebsite;
  String companyContactNo;
  DateTime createdAt;
  DateTime updatedAt;

  PreviousEmployerData({
    required this.id,
    required this.userId,
    required this.companyName,
    required this.profileDesignation,
    required this.salaryPerYear,
    required this.companyMail,
    required this.companyWebsite,
    required this.companyContactNo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PreviousEmployerData.fromJson(Map<String, dynamic> json) =>
      PreviousEmployerData(
        id: json["id"],
        userId: json["user_id"],
        companyName: json["company_name"],
        profileDesignation: json["profile_designation"],
        salaryPerYear: json["salary_per_year"],
        companyMail: json["company_mail"],
        companyWebsite: json["company_website"],
        companyContactNo: json["company_contact_no"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "company_name": companyName,
        "profile_designation": profileDesignation,
        "salary_per_year": salaryPerYear,
        "company_mail": companyMail,
        "company_website": companyWebsite,
        "company_contact_no": companyContactNo,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
