class SalaryDetailModel {
  SalaryDetailModel({
    this.workingDays = 26,
    this.presentDays = 0,
    this.leaves = 0,
    this.overTime = 0,
    this.tds = 0,
    this.basicSalary = 0,
    this.casualLeave = 0,
    this.provisionalLeave = 0,
    this.sickLeave = 0,
    this.leaveWithoutPay = 0,
    this.penaltyLeave = 0,
    this.holiday = 0,
    this.bonus = 0,
    this.hra = 0,
    this.ta = 0,
    this.loan = 0,
    this.others = 0,
    this.paidSalary = 0,
    this.designation = '',
    this.totalDeductionAmt = 0,
    this.professionalTax = 0,
  });
  double? workingDays;
  double? presentDays;
  double? leaves;
  double? overTime;
  double? tds;
  double? basicSalary;
  double? casualLeave;
  double? provisionalLeave;
  double? sickLeave;
  double? leaveWithoutPay;
  double? penaltyLeave;
  double? holiday;
  double? bonus;
  double? hra;
  double? ta;
  double? loan;
  String? designation;
  double? others;
  double? professionalTax;
  double? paidSalary;
  double? totalDeductionAmt;

  SalaryDetailModel.fromJson(Map<String, dynamic> json) {
    workingDays = json['workingDays'];
    presentDays = json['presentDays'];
    leaves = json['leaves'];
    overTime = json['overTime'];
    tds = json['tds'];
    basicSalary = json['basicSalary'];
    casualLeave = json['casualLeave'];
    provisionalLeave = json['provisionalLeave'];
    sickLeave = json['sickLeave'];
    leaveWithoutPay = json['leaveWithoutPay'];
    penaltyLeave = json['penaltyLeave'];
    holiday = json['holiday'];
    bonus = json['bonus'];
    hra = json['hra'];
    ta = json['ta'];
    loan = json['loan'];
    others = json['others'];
    professionalTax = json['professionalTax'];
    paidSalary = json['paidSalary'];
    designation = json['designation'];
    totalDeductionAmt = json['totalDeductionAmt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['workingDays'] = workingDays;
    data['presentDays'] = presentDays;
    data['leaves'] = leaves;
    data['overTime'] = overTime;
    data['tds'] = tds;
    data['basicSalary'] = basicSalary;
    data['casualLeave'] = casualLeave;
    data['provisionalLeave'] = provisionalLeave;
    data['sickLeave'] = sickLeave;
    data['leaveWithoutPay'] = leaveWithoutPay;
    data['penaltyLeave'] = penaltyLeave;
    data['holiday'] = holiday;
    data['bonus'] = bonus;
    data['hra'] = hra;
    data['ta'] = ta;
    data['designation'] = designation;
    data['loan'] = loan;
    data['others'] = others;
    data['professionalTax'] = professionalTax;
    data['paidSalary'] = paidSalary;
    data['totalDeductionAmt'] = totalDeductionAmt;
    return data;
  }
}
