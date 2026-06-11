import 'dart:convert';
import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/error_model.dart';
import '../../models/get_daily_report_model.dart';
import '../../models/success_model.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class MonthlyReportRepository {
  static final MonthlyReportRepository monthlyReportRepository =
      MonthlyReportRepository._();
  static const int _perPageForMonth = 31;

  MonthlyReportRepository._();

  factory MonthlyReportRepository() {
    return monthlyReportRepository;
  }
  final List<ReportData> _monthlyReportDataList = [];
  List<ReportData> get monthlyReportList => _monthlyReportDataList;

  set reportList(List<ReportData>? value) {
    _monthlyReportDataList.addAll(value!);
    Logger.println('monthly reports:${_monthlyReportDataList.length}');
  }

  clearReportList() {
    _monthlyReportDataList.clear();
    monthlyReportList.clear();
  }

  ///Get Monthly Report
  static Future<GetDailyReportModel> getMonthlyReport(
      {String? token,
      required int page,
      required int month,
      required int year}) async {
    final response = await DioClient().getRequest(
        url:
            '${Api.baseurl}${Api.getDailyReports}?page=$page&limit=$_perPageForMonth&month=$month&year=$year',
        token: MyLocalStorage().getToken());
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = GetDailyReportModel.fromJson(response.data);
      return responseData;
    } else {
      Logger.println("Get Monthly Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.error![0].error.toString());
    }
  }

/* ///Order Detail
  static Future<Data> OrderInfo({
    String? token,
    String? keyword,
    String? category,
    String? OrderType,
    String? sortBy,
    String? OrderId
  }) async {
    final response = await ApiClient().getRequest(
        Api.baseurl +Api.OrderInfo + OrderId!,
        token: token);
    if(response.statusCode == 200){
      print("Order info==${response.body}");
      var responseData = Data.fromJson(jsonDecode(response.body));
      return responseData;
    }else{
      var errorBody = ErrorModel.fromJson(jsonDecode(response.body));
      print('Order Info. error=${errorBody.errors}');
      throw ServiceException(
          message: errorBody.errors.toString(), error: errorBody);
    }
  }*/
}
