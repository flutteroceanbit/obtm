import 'dart:convert';

import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/error_model.dart';
import '../../models/get_holiday_by_month.dart';
import '../../models/holiday_model.dart';
import '../../models/success_model.dart';
import '../../models/update_holiday_model.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class GetHolidayRepository {
  static final GetHolidayRepository getHolidayRepository =
      GetHolidayRepository._();

  GetHolidayRepository._();

  factory GetHolidayRepository() {
    return getHolidayRepository;
  }

  final List<HolidayData> _data = [];

  List<HolidayData> get dataList => _data;

  set dataList(List<HolidayData>? value) {
    _data.addAll(value!);
  }

  clearReportList() {
    _data.clear();
    dataList.clear();
  }

  static Future<HolidayModel> getHoliday({String? token}) async {
    final response = await DioClient().getRequest(
      url: '${Api.baseurl}${Api.allHolidays}',
      token: token,
    );
    var responseStatus = HolidayModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = HolidayModel.fromJson(response.data);
      Logger.println('responseData ::: $responseData');
      return responseData;
    } else {
      Logger.println("Holiday Error ::: ${response.data}");
      var responseError = HolidayModel.fromJson(response.data);
      throw ServiceException(message: responseError.message);
    }
  }

  final List<HolidayInMonth> _holiday = [];

  List<HolidayInMonth> get holidayList => _holiday;

  set holidayList(List<HolidayInMonth>? value) {
    _holiday.addAll(value!);
  }

  clearHolidayList() {
    _holiday.clear();
    holidayList.clear();
  }

  static Future<GetHolidayByMonth> getHolidayByMonth({String? token}) async {
    final response = await DioClient().getRequest(
      url: '${Api.baseurl}${Api.getHolidayByMonth}',
      token: token,
    );
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = GetHolidayByMonth.fromJson(response.data);
      Logger.println('responseData ::: $responseData');
      return responseData;
    } else {
      Logger.println("Holiday Error ::: ${response.data}");
      var responseError = ErrorModel.fromJson(response.data);
      throw ServiceException(message: responseError.message!);
    }
  }

  static Future<UpdateHolidayModel> updateHoliday({
    required String id,
    required String startDate,
    required String endDate,
    required String desc,
    required String holidayTypeId,
  }) async {
    final response = await DioClient().putRequest(
        url: '${Api.baseurl}${Api.updateHoliday}/$id',
        token: MyLocalStorage().getToken(),
        body: {
          "holiday_type_id": holidayTypeId,
          "start_date": startDate,
          "end_date": endDate,
          "description": desc,
        });
    Logger.println("holiday data response : ${response.data}");
    var responseStatus = UpdateHolidayModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = UpdateHolidayModel.fromJson(response.data);
      Logger.println("update holiday Report :::: $responseData");
      return responseData;
    } else {
      Logger.println("update holiday Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<SuccessModel> deleteHoliday({required String id}) async {
    final response = await DioClient().deleteRequest(
      url: '${Api.baseurl}${Api.deleteHoliday}/$id',
      token: MyLocalStorage().getToken(),
    );
    Logger.println("holiday data response : ${response.data}");
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = SuccessModel.fromJson(response.data);
      Logger.println("delete holiday Report :::: $responseData");
      return responseData;
    } else {
      Logger.println("delete holiday Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }
}
