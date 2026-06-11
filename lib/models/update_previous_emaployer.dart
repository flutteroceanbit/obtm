class UpdatePreviousEmployerModel {
  bool status;
  String message;
  Data data;

  UpdatePreviousEmployerModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UpdatePreviousEmployerModel.fromJson(Map<String, dynamic> json) =>
      UpdatePreviousEmployerModel(
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
  String companyName;
  String profileDesignation;
  String salaryPerYear;
  String companyMail;
  String companyWebsite;
  String companyContactNo;
  DateTime createdAt;
  DateTime updatedAt;

  Data({
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
