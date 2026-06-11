class SalaryModel {
  bool status;
  String message;
  int currentPage;
  List<SalaryData> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  SalaryModel({
    required this.status,
    required this.message,
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory SalaryModel.fromJson(Map<String, dynamic> json) => SalaryModel(
    status: json["status"],
    message: json["message"],
    currentPage: json["current_page"],
    data: List<SalaryData>.from(
      json["data"].map((x) => SalaryData.fromJson(x)),
    ),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "current_page": currentPage,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": List<dynamic>.from(links.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class SalaryData {
  int id;
  int userId;
  int month;
  int year;
  int totalDaysInMonth;
  int totalSundays;
  int totalHolidays;
  int totalWorkingDays;
  int workingFullTimeDays;
  int workingHalfTimeDays;
  String userWorkingDays;
  String absentDaysMustBe;
  String absentDaysDueToLessTime;
  String lwpLeaveDays;
  String slLeaveDays;
  String clLeaveDays;
  String plLeaveDays;
  String pnltLeaveDays;
  String totalLeaveDays;
  String salaryDeductionDays;
  int grossSalary;
  int perDaySalary;
  int lwpDeductionAmt;
  int pnltDeductionAmt;
  int totalDeductionAmt;
  int paidSalary;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  EmployeeInformation employeeInformation;
  BankInformation? bankInformation;
  User user;

  SalaryData({
    required this.id,
    required this.userId,
    required this.month,
    required this.year,
    required this.totalDaysInMonth,
    required this.totalSundays,
    required this.totalHolidays,
    required this.totalWorkingDays,
    required this.workingFullTimeDays,
    required this.workingHalfTimeDays,
    required this.userWorkingDays,
    required this.absentDaysMustBe,
    required this.absentDaysDueToLessTime,
    required this.lwpLeaveDays,
    required this.slLeaveDays,
    required this.clLeaveDays,
    required this.plLeaveDays,
    required this.pnltLeaveDays,
    required this.totalLeaveDays,
    required this.salaryDeductionDays,
    required this.grossSalary,
    required this.perDaySalary,
    required this.lwpDeductionAmt,
    required this.pnltDeductionAmt,
    required this.totalDeductionAmt,
    required this.paidSalary,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.employeeInformation,
    required this.bankInformation,
    required this.user,
  });

  factory SalaryData.fromJson(Map<String, dynamic> json) => SalaryData(
    id: json["id"],
    userId: json["user_id"],
    month: json["month"],
    year: json["year"],
    totalDaysInMonth: json["total_days_in_month"],
    totalSundays: json["total_sundays"],
    totalHolidays: json["total_holidays"],
    totalWorkingDays: json["total_working_days"],
    workingFullTimeDays: json["working_full_time_days"],
    workingHalfTimeDays: json["working_half_time_days"],
    userWorkingDays: json["user_working_days"],
    absentDaysMustBe: json["absent_days_must_be"],
    absentDaysDueToLessTime: json["absent_days_due_to_less_time"],
    lwpLeaveDays: json["lwp_leave_days"],
    slLeaveDays: json["sl_leave_days"],
    clLeaveDays: json["cl_leave_days"],
    plLeaveDays: json["pl_leave_days"],
    pnltLeaveDays: json["pnlt_leave_days"],
    totalLeaveDays: json["total_leave_days"],
    salaryDeductionDays: json["salary_deduction_days"],
    grossSalary: json["gross_salary"],
    perDaySalary: json["per_day_salary"],
    lwpDeductionAmt: json["lwp_deduction_amt"],
    pnltDeductionAmt: json["pnlt_deduction_amt"],
    totalDeductionAmt: json["total_deduction_amt"],
    paidSalary: json["paid_salary"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    employeeInformation: EmployeeInformation.fromJson(
      json["employee_information"],
    ),
    bankInformation: json["bank_information"] == null
        ? null
        : BankInformation.fromJson(json["bank_information"]),
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "month": month,
    "year": year,
    "total_days_in_month": totalDaysInMonth,
    "total_sundays": totalSundays,
    "total_holidays": totalHolidays,
    "total_working_days": totalWorkingDays,
    "working_full_time_days": workingFullTimeDays,
    "working_half_time_days": workingHalfTimeDays,
    "user_working_days": userWorkingDays,
    "absent_days_must_be": absentDaysMustBe,
    "absent_days_due_to_less_time": absentDaysDueToLessTime,
    "lwp_leave_days": lwpLeaveDays,
    "sl_leave_days": slLeaveDays,
    "cl_leave_days": clLeaveDays,
    "pl_leave_days": plLeaveDays,
    "pnlt_leave_days": pnltLeaveDays,
    "total_leave_days": totalLeaveDays,
    "salary_deduction_days": salaryDeductionDays,
    "gross_salary": grossSalary,
    "per_day_salary": perDaySalary,
    "lwp_deduction_amt": lwpDeductionAmt,
    "pnlt_deduction_amt": pnltDeductionAmt,
    "total_deduction_amt": totalDeductionAmt,
    "paid_salary": paidSalary,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
    "employee_information": employeeInformation.toJson(),
    "bank_information": bankInformation?.toJson(),
    "user": user.toJson(),
  };
}

class BankInformation {
  int id;
  int userId;
  String bankName;
  String branch;
  String accountNo;
  String accountType;
  String ifscCode;
  DateTime createdAt;
  DateTime updatedAt;

  BankInformation({
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

  factory BankInformation.fromJson(Map<String, dynamic> json) =>
      BankInformation(
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

class EmployeeInformation {
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
  String? minimumFullTime;
  String? minimumHalfTime;
  dynamic workFullTime;
  dynamic workHalfTime;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  Department department;
  Department designation;

  EmployeeInformation({
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
    required this.minimumFullTime,
    required this.minimumHalfTime,
    required this.workFullTime,
    required this.workHalfTime,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.department,
    required this.designation,
  });

  factory EmployeeInformation.fromJson(Map<String, dynamic> json) =>
      EmployeeInformation(
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
        minimumFullTime: json["minimum_full_time"],
        minimumHalfTime: json["minimum_half_time"],
        workFullTime: json["work_full_time"],
        workHalfTime: json["work_half_time"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        department: Department.fromJson(json["department"]),
        designation: Department.fromJson(json["designation"]),
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
    "minimum_full_time": minimumFullTime,
    "minimum_half_time": minimumHalfTime,
    "work_full_time": workFullTime,
    "work_half_time": workHalfTime,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
    "department": department.toJson(),
    "designation": designation.toJson(),
  };
}

class Department {
  int id;
  String name;
  String isActive;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  Department({
    required this.id,
    required this.name,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Department.fromJson(Map<String, dynamic> json) => Department(
    id: json["id"],
    name: json["name"],
    isActive: json["is_active"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "is_active": isActive,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
  };
}

class User {
  int id;
  String firstName;
  String lastName;
  String employeeId;
  String email;
  String phone;
  String? alterPhone;
  String? imageUrl;
  dynamic docUrl;
  bool isAdmin;
  bool isPhoneVerified;
  bool isEmailVerified;
  String startTime;
  int isActive;
  dynamic emailVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;
  int recordDeleted;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.employeeId,
    required this.email,
    required this.phone,
    required this.alterPhone,
    required this.imageUrl,
    required this.docUrl,
    required this.isAdmin,
    required this.isPhoneVerified,
    required this.isEmailVerified,
    required this.startTime,
    required this.isActive,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.recordDeleted,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    employeeId: json["employee_id"],
    email: json["email"],
    phone: json["phone"],
    alterPhone: json["alter_phone"],
    imageUrl: json["image_url"],
    docUrl: json["doc_url"],
    isAdmin: json["is_admin"],
    isPhoneVerified: json["is_phone_verified"],
    isEmailVerified: json["is_email_verified"],
    startTime: json["start_time"],
    isActive: json["is_active"],
    emailVerifiedAt: json["email_verified_at"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    recordDeleted: json["record_deleted"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "employee_id": employeeId,
    "email": email,
    "phone": phone,
    "alter_phone": alterPhone,
    "image_url": imageUrl,
    "doc_url": docUrl,
    "is_admin": isAdmin,
    "is_phone_verified": isPhoneVerified,
    "is_email_verified": isEmailVerified,
    "start_time": startTime,
    "is_active": isActive,
    "email_verified_at": emailVerifiedAt,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "record_deleted": recordDeleted,
  };
}

class Link {
  String? url;
  String label;
  bool active;

  Link({required this.url, required this.label, required this.active});

  factory Link.fromJson(Map<String, dynamic> json) =>
      Link(url: json["url"], label: json["label"], active: json["active"]);

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}
