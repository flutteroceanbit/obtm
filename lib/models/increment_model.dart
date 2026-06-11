class IncrementModel {
  bool status;
  String message;
  Data data;

  IncrementModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory IncrementModel.fromJson(Map<String, dynamic> json) => IncrementModel(
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
  int departmentId;
  int designationId;
  DateTime startDate;
  DateTime endDate;
  int period;
  int basicSalary;
  int hra;
  int da;
  int ta;
  int securityDeposit;
  int monthlySecurityDeposit;
  int bonusOne;
  int bonusTwo;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  Data({
    required this.id,
    required this.userId,
    required this.departmentId,
    required this.designationId,
    required this.startDate,
    required this.endDate,
    required this.period,
    required this.basicSalary,
    required this.hra,
    required this.da,
    required this.ta,
    required this.securityDeposit,
    required this.monthlySecurityDeposit,
    required this.bonusOne,
    required this.bonusTwo,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["user_id"],
        departmentId: json["department_id"],
        designationId: json["designation_id"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        period: json["period"],
        basicSalary: json["basic_salary"],
        hra: json["HRA"],
        da: json["DA"],
        ta: json["TA"],
        securityDeposit: json["security_deposit"],
        monthlySecurityDeposit: json["monthly_security_deposit"],
        bonusOne: json["bonus_one"],
        bonusTwo: json["bonus_two"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "department_id": departmentId,
        "designation_id": designationId,
        "start_date":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "period": period,
        "basic_salary": basicSalary,
        "HRA": hra,
        "DA": da,
        "TA": ta,
        "security_deposit": securityDeposit,
        "monthly_security_deposit": monthlySecurityDeposit,
        "bonus_one": bonusOne,
        "bonus_two": bonusTwo,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
