import 'dart:convert';
import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/error_model.dart';
import '../../models/get_daily_report_model.dart';
import '../../models/success_model.dart';
import '../../screen/report_list/report_list_screen.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class GetDailyReportRepository {
  static final GetDailyReportRepository getDailyReportRepository =
      GetDailyReportRepository._();
  static const int _perPage = 20;

  GetDailyReportRepository._();

  factory GetDailyReportRepository() {
    return getDailyReportRepository;
  }

  final List<ReportData> _reportList = [];
  int totalReports = 0;

  List<ReportData> get reportList => _reportList;
  int page = 1;
  int month = DateTime.now().month;
  bool isLastPage = false;
  bool isLoading = false;

  set reportList(List<ReportData>? value) {
    _reportList.addAll(value!);
  }

  clearReportList() {
    _reportList.clear();
    reportList.clear();
    totalReports = 0;
    page = 1;
  }

  static Future<GetDailyReportModel> getDailyReport({
    String? token,
    required int page,
  }) async {
    final response = await DioClient().getRequest(
        url:
            '${Api.baseurl}${Api.getDailyReports}?page=$page&limit=$_perPage&month=${getDailyReportRepository.month}&year=$selectedYear',
        token: MyLocalStorage().getToken());
    Logger.println("Get Daily Report Error :: ${response.data}");
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = GetDailyReportModel.fromJson(response.data);
      return responseData;
    } else {
      Logger.println("Get Daily Report Error :::: ${response.data}");
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
