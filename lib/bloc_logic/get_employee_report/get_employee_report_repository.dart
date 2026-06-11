import 'dart:convert';

import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../models/employee_report_list_model.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class GetEmployeeReportRepository {
  static final GetEmployeeReportRepository getEmployeeReportRepository =
      GetEmployeeReportRepository._();

  GetEmployeeReportRepository._();

  factory GetEmployeeReportRepository() {
    return getEmployeeReportRepository;
  }

  final List<Data> _data = [];
  int totalReports = 0;
  int page = 0;
  int month = DateTime.now().month;
  bool isLastPage = false;
  bool isLoading = false;

  List<Data> get dataList => _data;

  set dataList(List<Data>? value) {
    _data.addAll(value!);
  }

  clearReportList() {
    _data.clear();
    dataList.clear();
    totalReports = 0;
    page = 1;
  }

  ///Employee Report List
  static Future<EmployeeReportListModel> getEmployeeReport({
    String? token,
    String? url,
    required int id,
    required String page,
    required String year,
    int perPageLimit = 30,
  }) async {
    final response = await DioClient().getRequest(
        url: url ??
            '${Api.baseurl}${Api.getDailyReports}/$id?page=$page&limit=$perPageLimit&month=${getEmployeeReportRepository.month}&year=$year',
        token: token);
    var responseStatus = EmployeeReportListModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = EmployeeReportListModel.fromJson(response.data);
      return responseData;
    } else {
      Logger.println("Employee Report Error ::: ${response.data}");
      var responseError = EmployeeReportListModel.fromJson(response.data);
      throw ServiceException(message: responseError.message!);
    }
  }
}
