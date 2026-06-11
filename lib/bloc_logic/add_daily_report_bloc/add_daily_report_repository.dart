import 'dart:core';
import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/daily_report_model.dart';
import '../../models/error_model.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class AddDailyReportRepository {
  static Future<DailyReportModel> addDailyReport(
      {required String? reportText,
      required String? totalTime,
      required String? intermediateTime,
      String? token}) async {
    final response = await DioClient().postMultipartRequest(
        url: Api.baseurl + Api.addDailyReport,
        token: MyLocalStorage().getToken(),
        body: {
          "report_text": reportText!,
          "total_time": totalTime!,
          "intermediate_time": intermediateTime!,
        });
    var responseStatus = DailyReportModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = DailyReportModel.fromJson(response.data);
      Logger.println("Add Report :::: ${responseData.data}");
      return responseData;
    } else {
      Logger.println("Add Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }
}
