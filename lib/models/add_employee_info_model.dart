class AddEmployeeInfoModel {
  bool status;
  String message;
  Data data;

  AddEmployeeInfoModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AddEmployeeInfoModel.fromJson(Map<String, dynamic> json) =>
      AddEmployeeInfoModel(
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
  int period;
  int basicSalary;
  int hra;
  int da;
  int ta;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  Data({
    required this.id,
    required this.userId,
    required this.departmentId,
    required this.designationId,
    required this.startDate,
    required this.period,
    required this.basicSalary,
    required this.hra,
    required this.da,
    required this.ta,
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
        period: json["period"],
        basicSalary: json["basic_salary"],
        hra: json["HRA"],
        da: json["DA"],
        ta: json["TA"],
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
        "period": period,
        "basic_salary": basicSalary,
        "HRA": hra,
        "DA": da,
        "TA": ta,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
