class AddPreviousEmployerModel {
  bool status;
  String message;
  Data data;

  AddPreviousEmployerModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AddPreviousEmployerModel.fromJson(Map<String, dynamic> json) =>
      AddPreviousEmployerModel(
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
  String companyName;
  String profileDesignation;
  String salaryPerYear;
  String companyMail;
  String companyWebsite;
  String companyContactNo;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  Data({
    required this.userId,
    required this.companyName,
    required this.profileDesignation,
    required this.salaryPerYear,
    required this.companyMail,
    required this.companyWebsite,
    required this.companyContactNo,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        companyName: json["company_name"],
        profileDesignation: json["profile_designation"],
        salaryPerYear: json["salary_per_year"],
        companyMail: json["company_mail"],
        companyWebsite: json["company_website"],
        companyContactNo: json["company_contact_no"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "company_name": companyName,
        "profile_designation": profileDesignation,
        "salary_per_year": salaryPerYear,
        "company_mail": companyMail,
        "company_website": companyWebsite,
        "company_contact_no": companyContactNo,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
