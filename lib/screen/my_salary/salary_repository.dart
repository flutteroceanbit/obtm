import 'package:oceanbit_timeclock/local_storage/my_local_storage.dart';
import 'package:oceanbit_timeclock/utils/date_formatter.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../models/salary_detail_model.dart';

class SalaryPDFRepository {
  static final SalaryPDFRepository salaryPDFRepository =
      SalaryPDFRepository._();

  SalaryPDFRepository._();

  factory SalaryPDFRepository() {
    return salaryPDFRepository;
  }

  ///declaration
  String _userName =
      '${MyLocalStorage().getUser()?.firstName} ${MyLocalStorage().getUser()?.lastName}'
          .upperCamelCase;
  String _selectedMonth = DateFormatter.formateDate(
      inputFormatter: 'yyyy-MM-dd hh:mm:ss',
      input: DateTime.now().toString(),
      outputFormatter: 'MMMM yyyy');
  String _selectedMonthShort = DateFormatter.formateDate(
      inputFormatter: 'yyyy-MM-dd hh:mm:ss',
      input: DateTime.now().toString(),
      outputFormatter: 'MMM-yy');
  String? _employeeCode = MyLocalStorage().getUser()?.employeeId;
  String _department = 'Flutter';
  String _bankName = 'HDFC';
  String _bankACno = '123456';
  double totalEarning = 0;
  int netPayable = 0;
  double _totalDeductions = 0;
  SalaryDetailModel salaryModel = SalaryDetailModel();

  ///getter
  String get userName => _userName;
  String get selectedMonth => _selectedMonth;
  String get selectedMonthShort => _selectedMonthShort;
  String? get employeeCode => _employeeCode;
  String get department => _department;
  String get bankName => _bankName;
  String get bankACno => _bankACno;
  double get totalDeductions => _totalDeductions;
  set selectedMonth(String? data) {
    _selectedMonth = data ?? _selectedMonth;
  }

  set selectedMonthShort(String? data) {
    _selectedMonthShort = data ?? _selectedMonthShort;
  }

  set userName(String? data) {
    _userName = data ?? _userName;
  }

  set employeeCode(String? data) {
    _employeeCode = data ?? MyLocalStorage().getUser()?.employeeId;
  }

  set department(String? data) {
    _department = data ?? 'Flutter';
  }

  set bankName(String? data) {
    _bankName = data ?? _bankName;
  }

  set bankACno(String? data) {
    _bankACno = data ?? _bankACno;
  }

  set totalDeduction(double amount) {
    _totalDeductions = amount;
  }
}
