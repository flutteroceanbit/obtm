import 'get_employee_info_model.dart';

class GetEmployeeInfoDetailModel {
  bool status;
  String message;
  EmployeeDetailData data;

  GetEmployeeInfoDetailModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetEmployeeInfoDetailModel.fromJson(Map<String, dynamic> json) =>
      GetEmployeeInfoDetailModel(
        status: json["status"],
        message: json["message"],
        data: EmployeeDetailData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class EmployeeDetailData {
  List<Department> departments;
  List<Department> designations;

  EmployeeDetailData({
    required this.departments,
    required this.designations,
  });

  factory EmployeeDetailData.fromJson(Map<String, dynamic> json) =>
      EmployeeDetailData(
        departments: List<Department>.from(
            json["departments"].map((x) => Department.fromJson(x))),
        designations: List<Department>.from(
            json["designations"].map((x) => Department.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "departments": List<dynamic>.from(departments.map((x) => x.toJson())),
        "designations": List<dynamic>.from(designations.map((x) => x.toJson())),
      };
}
