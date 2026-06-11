import 'dart:core';

import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/error_model.dart';
import '../../models/get_salary_model.dart';
import '../../utils/exceptions/service_exception.dart';

class SalaryRepository {
  int page = 0;
  int totalReports = 0;
  int limit = 20;
  bool isLastPage = false;
  bool isLoading = false;
  final List<SalaryData> _reportList = [];

  List<SalaryData> get reportList => _reportList;

  set reportList(List<SalaryData>? value) {
    _reportList.addAll(value!);
  }

  clearReportList() {
    _reportList.clear();
    reportList.clear();
    totalReports = 0;
    page = 1;
  }

  static Future<SalaryModel> getSalary({
    int? userId,
    required int page,
    required int limit,
    String? token,
  }) async {
    final response = await DioClient().postRequest(
      url: '${Api.baseurl}${Api.getSalary}${userId != null ? '/$userId' : ''}',
      token: MyLocalStorage().getToken(),
      body: {"page": page, "limit": limit},
    );
    var responseStatus = response.data;
    if (responseStatus['status'] == true) {
      var responseStatus = SalaryModel.fromJson(response.data);

      return responseStatus;
    } else {
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
        message: responseStatus.message == 'Request Failed'
            ? responseStatus.error![0].error.toString()
            : responseStatus.message!,
      );
    }
  }
}
